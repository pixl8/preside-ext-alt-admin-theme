component extends="preside.system.base.EnhancedDataManagerBase" {

	property name="datamanagerService" inject="DatamanagerService";

	variables.infoCol1 = [];
	variables.infoCol2 = [];
	variables.infoCol3 = [];

	variables.tabs = [
		"dashboard"
	];

	variables.sidebarNavigation = true;

	private string function renderSidebarHeader( event, rc, prc, args={} ) {
		return renderView( view="/admin/datamanager/security_user/_sidebarHeader", args=args );
	}

	private array function getTopRightButtonsForViewRecord( event, rc, prc, args ) {
		var objectName = args.objectName ?: "";
		var recordId   = args.recordId   ?: "";

		args.actions      = [];
		args.childActions = [];

		if ( prc.canDelete ) {
			if ( ArrayLen( args.childActions ) ) {
				ArrayAppend( args.childActions, "---" );
			}

			ArrayAppend( args.childActions, {
				  link      = event.buildAdminLink( objectName="security_user", recordId=prc.recordId, operation="deleteRecordAction" )
				, icon      = "fa-trash red"
				, globalKey = "d"
				, title     = translateResource( uri="cms:datamanager.deleteRecord.btn" )
				, prompt    = translateResource( uri="cms:datamanager.deleteRecord.prompt", data=[ prc.objectTitle, stripTags( prc.recordLabel ) ] )
				, match     = datamanagerService.getDeletionConfirmationMatch( "security_user", QueryRowToStruct( prc.record ) )
			} );
		}

		if ( prc.canEdit ) {
			ArrayAppend( args.actions, {
				  link      = event.buildAdminLink( objectName="security_user", recordId=recordId, operation="editRecord" )
				, btnClass  = "btn-primary-default"
				, iconClass = "fa-pencil"
				, globalKey = "e"
				, title     = translateResource( "cms:datamanager.editRecord.btn" )
				, children  = args.childActions
			} );
		}

		return args.actions;
	}

	private string function _dashboardTab( event, rc, prc, args={} ) {
		return "";
	}

}