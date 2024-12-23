component extends="preside.system.base.EnhancedDataManagerBase" {

	property name="datamanagerService" inject="DatamanagerService";

	variables.infoCol1 = [ "language", "twoFactorAuth" ];
	variables.infoCol2 = [ "lastLoggedIn", "lastLoggedOut", "lastActive" ];

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

	private string function _infoCardLanguage( event, rc, prc, args={} ) {
		var locale = translateResource( uri="preside-objects.security_user:infocard.user_language.empty.label" );

		if ( !isEmptyString( args.record.user_language ) ) {
			var language = ListFirst( args.record.user_language, "_" );
			var country  = ListLen( args.record.user_language, "_" ) > 1 ? ListRest( args.record.user_language, "_" ) : "";

			locale = translateResource( uri="locale:title", language=language, country=country );
		}

		return '<i class="fa fa-fw fa-globe blue"></i> #translateResource( uri="preside-objects.security_user:infocard.user_language.label", data=[ locale ] )#';
	}

	private string function _infoCardTwoFactorAuth( event, rc, prc, args={} ) {
		var twoFactorAuth = isTrue( args.record.two_step_auth_key_in_use ) ? "enabled" : "disabled";

		return '<i class="fa fa-fw #translateResource( uri="preside-objects.security_user:infocard.two_step_auth_key_in_use.#twoFactorAuth#.iconClass" )#"></i> #translateResource( uri="preside-objects.security_user:infocard.two_step_auth_key_in_use.#twoFactorAuth#.label" )#';
	}

	private string function _infoCardLastLoggedIn( event, rc, prc, args={} ) {
		return '<i class="fa fa-fw fa-sign-in blue"></i> #translateResource( uri="preside-objects.security_user:infocard.last_logged_in.label", data=[ renderContent( renderer="DateTime", data=args.record.last_logged_in, context="relative" ) ] )#';
	}

	private string function _infoCardLastLoggedOut( event, rc, prc, args={} ) {
		return '<i class="fa fa-fw fa-sign-out red"></i> #translateResource( uri="preside-objects.security_user:infocard.last_logged_out.label", data=[ renderContent( renderer="DateTime", data=args.record.last_logged_out, context="relative" ) ] )#';
	}

	private string function _infoCardLastActive( event, rc, prc, args={} ) {
		return '<i class="fa fa-fw fa-history grey"></i> #translateResource( uri="preside-objects.security_user:infocard.last_request_made.label", data=[ renderContent( renderer="DateTime", data=args.record.last_request_made, context="relative" ) ] )#';
	}

	private string function _dashboardTab( event, rc, prc, args={} ) {
		return "";
	}

}