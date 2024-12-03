component {

	property name="presideObjectService"            inject="PresideObjectService";
	property name="dataManagerService"              inject="DataManagerService";
	property name="dataManagerCustomizationService" inject="DataManagerCustomizationService";

	public string function object( event, rc, prc, args={} ) {
		if ( !isEmptyString( rc.objectName ?: "" ) ) {
			StructAppend( args, { objectName=rc.objectName }, true );
		}

		return runEvent(
			  event          = "admin.layout.DataCardGrid._object"
			, prePostExempt  = true
			, private        = true
			, eventArguments = args
		);
	}

	private string function _object(
		  required string objectName
		,          string orderBy    = "datecreated desc"
		,          string labelField = presideObjectService.getLabelField( objectName=arguments.objectName )
	) {
		var args = StructCopy( arguments );
		StructDelete( args, "event" );
		StructDelete( args, "rc" );
		StructDelete( args, "prc" );

		args.search               = rc.q    ?: "";
		args.currentPage          = rc.page ?: 1;
		args.maxRows              = rc.len  ?: getSetting( name="adminTheme.defaults.dataCardGrid.resultsPerPage", defaultValue=12 );
		args.showAddNewRecordCard = args.currentPage == 1;
		args.offsetRows           = args.showAddNewRecordCard ? -1 : ( rc.offset ?: 0 );

		args.totalResults = _getRecords( objectName=arguments.objectName, search=args.search, recordCountOnly=true );
		args.totalPages   = Ceiling( args.totalResults / args.maxRows );
		args.startRow     = ( ( args.currentPage - 1 ) * args.maxRows ) + 1 + args.offsetRows;

		if ( args.startRow < 1 ) {
			args.startRow = 1;
		}

		event.initializeDatamanagerPage( objectName=args.objectName );

		var defaultIcon = translateResource( uri="preside-objects.#arguments.objectName#:iconClass", defaultValue="" );
		var records     = _getRecords( objectName=arguments.objectName, search=args.search, maxRows=( args.maxRows - ( args.showAddNewRecordCard ? 1 : 0 ) ), startRow=args.startRow );

		args.cardItems = [];
		for ( var record in records ) {
			ArrayAppend( args.cardItems, {
				  cardHeaderIcon    = dataManagerCustomizationService.runCustomization(
					  objectName     = objectName
					, action         = "getHeaderIconForDataCard"
					, defaultResult  = defaultIcon
					, args           = {
						  objectName = objectName
						, record     = record
					  }
				  )
				, cardHeaderLabel   = dataManagerCustomizationService.runCustomization(
					  objectName     = objectName
					, action         = "getHeaderLabelForDataCard"
					, defaultResult  = record[ arguments.labelField ] ?: renderLabel( objectName=args.objectName, recordId=record.id )
					, args           = {
						  objectName = objectName
						, record     = record
					  }
				  )
				, cardHeaderOptions = dataManagerCustomizationService.runCustomization(
					  objectName     = objectName
					, action         = "getHeaderOptionsForDataCard"
					, defaultHandler = "admin.layout.dataCardGrid._getCardHeaderOptions"
					, args           = {
						  objectName = objectName
						, record     = record
					  }
				  )
				, cardBody          = dataManagerCustomizationService.runCustomization(
					  objectName     = objectName
					, action         = "getBodyForDataCard"
					, defaultHandler = "admin.layout.dataCardGrid._getCardBody"
					, args           = {
						  objectName = objectName
						, record     = record
					  }
				  )
			} );
		}

		if ( event.isAjax() ) {
			event.setLayout( "alpineAjax" );
		} else {
			event
				.include( assetId="/css/admin/altadmintheme/dataCardGrid/" )
				.include( assetId="alpine"     , group="top" )
				.include( assetId="alpine-ajax", group="top" )
			;
		}

		return renderView( view="/admin/layout/dataCardGrid/_object", args=args );
	}

	private string function _search( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: prc.objectName ?: "";
		return renderView( view="/admin/layout/dataCardGrid/_search", args=args );
	}

	private string function _list( event, rc, prc, args={} ) {
		var objectName           = args.objectName ?: prc.objectName ?: "";
		var showAddNewRecordCard = args.showAddNewRecordCard ?: false;

		if ( showAddNewRecordCard ) {
			args.addNewRecordLink  = args.addNewRecordLink  ?: event.buildAdminLink( objectName=objectName, operation="addRecord" );
			args.addNewRecordIcon  = args.addNewRecordIcon  ?: translateResource( uri="admin.dataCardGrid:card.add.iconClass" );
			args.addNewRecordLabel = args.addNewRecordLabel ?: translateResource( uri="admin.dataCardGrid:card.add.label", data=[ prc.objectTitle ?: "" ] );
		}

		return renderView( view="/admin/layout/dataCardGrid/_list", args=args );
	}

	private string function _footer( event, rc, prc, args={} ) {
		return renderView( view="/admin/layout/dataCardGrid/_footer", args=args );
	}

	private array function _getCardHeaderOptions( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: "";
		var record     = args.record     ?: QueryNew( "" );
		var labelField = args.labelField ?: presideObjectService.getLabelField( objectName=objectName );

		var options = [];
		var more    = [];

		if ( prc.canEdit ) {
			ArrayAppend( options, {
				  label = translateResource( uri="admin.datacardGrid:option.edit.label" )
				, link  = event.buildAdminLink( objectName=objectName, operation="editRecord", recordId=record.id )
			} );
		}

		if ( prc.canClone ) {
			ArrayAppend( more, {
				  label     = translateResource( uri="admin.datacardGrid:option.clone.label" )
				, link      = event.buildAdminLink( objectName=objectName, operation="cloneRecord", recordId=record.id )
				, iconClass = "fa-clone"
			} );
		}

		if ( prc.canDelete ) {
			ArrayAppend( more, "---" );

			ArrayAppend( more, {
				  label     = translateResource( uri="admin.datacardGrid:option.delete.label" )
				, link      = event.buildAdminLink( objectName=objectName, operation="deleteRecordAction", recordId=record.id )
				, iconClass = "fa-trash-o"
				, title     = translateResource( uri="admin.datacardGrid:option.delete.prompt.title", data=[ LCase( translateResource( uri="preside-objects.site_theme:title.singular" ) ), record[ labelField ] ?: "" ] )
				, prompt    = true
			} );
		}

		if ( ArrayLen( more ) ) {
			ArrayAppend( options, { more=more } );
		}

		return options;
	}

	private string function _getCardBody( event, rc, prc, args={} ) {
		return "";
	}

	private any function _getRecords(
		  required string  objectName
		,          string  orderBy         = "datecreated desc"
		,          numeric maxRows         = 0
		,          numeric startRow        = 1
		,          boolean recordCountOnly = false
		,          string  search          = ""
	) {
		var extraFilters      = [];
		var filter            = [];
		var filterParams      = {};


		if ( !isEmptyString( arguments.search ) ) {
			try {
				ArrayAppend( extraFilters, dataManagerService.buildSearchFilter(
						  q            = arguments.search
						, objectName   = arguments.objectName
						, gridFields   = dataManagerService.listGridFields( arguments.objectName )
						, searchFields = dataManagerService.listSearchFields( arguments.objectName )
						, expandTerms  = true
					)
				);
			} catch( any e ){}
		}

		return presideObjectService.selectData(
			  objectName        = arguments.objectName
			, filter            = ArrayToList( filter, " and " )
			, filterParams      = filterParams
			, extraFilters      = extraFilters
			, orderBy           = arguments.orderBy
			, maxRows           = arguments.recordCountOnly ? 0 : arguments.maxRows
			, startRow          = arguments.recordCountOnly ? 1 : arguments.startRow
			, recordCountOnly   = arguments.recordCountOnly
		);
	}

}