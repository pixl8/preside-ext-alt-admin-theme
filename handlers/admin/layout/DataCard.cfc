component {

	property name="presideObjectService"            inject="PresideObjectService";
	property name="dataManagerCustomizationService" inject="DataManagerCustomizationService";

	public string function object( event, rc, prc, args={} ) {
		return runEvent(
			  event          = "admin.layout.DataCard._object"
			, prePostExempt  = true
			, private        = true
			, eventArguments = {
				objectName = rc.objectName ?: ""
			  }
		);
	}

	private string function _object(
		  required string objectName
		,          string orderBy          = "datecreated desc"
		,          string labelField       = presideObjectService.getLabelField( objectName=arguments.objectName )
		,          string descriptionField = "description"
	) {
		event.initializeDatamanagerPage( objectName=arguments.objectName );

		args.objectName           = arguments.objectName;
		args.search               = rc.q    ?: "";
		args.currentPage          = rc.page ?: 1;
		args.maxRows              = rc.len  ?: getSetting( name="adminTheme.defaults.dataCard.resultsPerPage", defaultValue=12 );
		args.showAddNewRecordCard = args.currentPage == 1;
		args.offsetRows           = args.showAddNewRecordCard ? -1 : ( rc.offset ?: 0 );

		args.totalResults = _getRecords( objectName=arguments.objectName, search=args.search, labelField=arguments.labelField, recordCountOnly=true, labelField=arguments.labelField );
		args.totalPages   = Ceiling( args.totalResults / args.maxRows );
		args.startRow     = ( ( args.currentPage - 1 ) * args.maxRows ) + 1 + args.offsetRows;

		if ( args.startRow < 1 ) {
			args.startRow = 1;
		}

		var icon    = translateResource( uri="preside-objects.#arguments.objectName#:iconClass", defaultValue="" );
		var records = _getRecords( objectName=arguments.objectName, search=args.search, labelField=arguments.labelField, maxRows=( args.maxRows - ( args.showAddNewRecordCard ? 1 : 0 ) ), startRow=args.startRow );

		args.cardItems = [];
		for ( var record in records ) {
			ArrayAppend( args.cardItems, {
				  cardHeaderIcon    = icon
				, cardHeaderLabel   = record[ arguments.labelField ] ?: ""
				, cardHeaderOptions = dataManagerCustomizationService.runCustomization(
					  objectName     = objectName
					, action         = "getHeaderOptionsForDataCard"
					, defaultHandler = "admin.layout.dataCard._getCardHeaderOptions"
					, args           = {
						  objectName = objectName
						, record     = record
					  }
				  )
				, cardBodyImage     = dataManagerCustomizationService.runCustomization(
					  objectName     = objectName
					, action         = "getBodyImageForDataCard"
					, defaultHandler = "admin.layout.dataCard._getCardBodyImage"
					, args           = {
						  objectName = objectName
						, record     = record
					  }
				  )
				, cardBody          = record[ arguments.descriptionField ] ?: ""
			} );
		}

		return renderView( view="/admin/layout/dataCard/_object", args=args );
	}

	private string function _search( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: prc.objectName ?: "";
		return renderView( view="/admin/layout/dataCard/_search", args=args );
	}

	private string function _list( event, rc, prc, args={} ) {
		var objectName           = args.objectName ?: prc.objectName ?: "";
		var showAddNewRecordCard = args.showAddNewRecordCard ?: false;

		if ( showAddNewRecordCard ) {
			args.addNewRecordLink  = args.addNewRecordLink  ?: event.buildAdminLink( objectName=objectName, operation="addRecord" );
			args.addNewRecordIcon  = args.addNewRecordIcon  ?: translateResource( uri="admin.dataCard:card.add.iconClass" );
			args.addNewRecordLabel = args.addNewRecordLabel ?: translateResource( uri="admin.dataCard:card.add.label", data=[ prc.objectTitle ?: "" ] );
		}

		return renderView( view="/admin/layout/dataCard/_list", args=args );
	}

	private string function _footer( event, rc, prc, args={} ) {
		return renderView( view="/admin/layout/dataCard/_footer", args=args );
	}

	private array function _getCardHeaderOptions( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: "";
		var record     = args.record     ?: QueryNew( "" );
		var labelField = args.labelField ?: presideObjectService.getLabelField( objectName=objectName );

		var options = [];
		var more    = [];

		if ( prc.canEdit ) {
			ArrayAppend( options, {
				  label = translateResource( uri="admin.datacard:option.edit.label" )
				, link  = event.buildAdminLink( objectName=objectName, operation="editRecord", recordId=record.id )
			} );
		}

		if ( prc.canClone ) {
			ArrayAppend( more, {
				  label     = translateResource( uri="admin.datacard:option.clone.label" )
				, link      = event.buildAdminLink( objectName=objectName, operation="cloneRecord", recordId=record.id )
				, iconClass = "fa-clone"
			} );
		}

		if ( prc.canDelete ) {
			ArrayAppend( more, "---" );

			ArrayAppend( more, {
				  label     = translateResource( uri="admin.datacard:option.delete.label" )
				, link      = event.buildAdminLink( objectName=objectName, operation="deleteRecordAction", recordId=record.id )
				, iconClass = "fa-trash-o"
				, title     = translateResource( uri="admin.datacard:option.delete.prompt.title", data=[ LCase( translateResource( uri="preside-objects.site_theme:title.singular" ) ), record[ labelField ] ?: "" ] )
				, prompt    = true
			} );
		}

		if ( ArrayLen( more ) ) {
			ArrayAppend( options, { more=more } );
		}

		return options;
	}

	private string function _getCardBodyImage( event, rc, prc, args={} ) {
		return "";
	}

	private any function _getRecords(
		  required string  objectName
		,          string  orderBy         = "datecreated desc"
		,          numeric maxRows         = 0
		,          numeric startRow        = 1
		,          boolean recordCountOnly = false
		,          string  search          = ""
		,          string  labelField      = presideObjectService.getLabelField( objectName=arguments.objectName )
	) {
		var filter       = [];
		var filterParams = {};

		if ( !isEmptyString( arguments.search ) ) {
			ArrayAppend( filter, "( #labelField# like :search )" );
			StructAppend( filterParams, { "search"={ type="cf_sql_varchar", value="%#arguments.search#%" } } );
		}

		return presideObjectService.selectData(
			  objectName      = arguments.objectName
			, filter          = ArrayToList( filter, " and " )
			, filterParams    = filterParams
			, orderBy         = arguments.orderBy
			, maxRows         = arguments.recordCountOnly ? 0 : arguments.maxRows
			, startRow        = arguments.recordCountOnly ? 1 : arguments.startRow
			, recordCountOnly = arguments.recordCountOnly
		);
	}

}