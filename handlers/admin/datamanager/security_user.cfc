component extends="preside.system.base.EnhancedDataManagerBase" {

	property name="datamanagerService"  inject="DatamanagerService";
	property name="securityUserService" inject="SecurityUserService";
	property name="loginService"        inject="LoginService";

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

		if ( isFalse( args.record.active ) ) {
			ArrayAppend( args.childActions, {
				  link   = event.buildAdminLink( linkTo="datamanager.security_user.activateUserAction", queryString="id=#recordId#" )
				, icon   = "fa-check-circle green"
				, title  = translateResource( uri="preside-objects.security_user:action.activate.label" )
				, prompt = translateResource( uri="preside-objects.security_user:action.activate.prompt", data=[ args.record.known_as ] )
			} );
		} else {
			ArrayAppend( args.childActions, {
				  link   = event.buildAdminLink( linkTo="datamanager.security_user.deactivateUserAction", queryString="id=#recordId#" )
				, icon   = "fa-times-circle red"
				, title  = translateResource( uri="preside-objects.security_user:action.deactivate.label" )
				, prompt = translateResource( uri="preside-objects.security_user:action.deactivate.prompt", data=[ args.record.known_as ] )
			} );
		}

		ArrayAppend( args.childActions, {
			  link  = event.buildAdminLink( linkTo="datamanager.security_user.sendWelcomeEmail", queryString="id=#recordId#" )
			, icon  = "fa-envelope"
			, title = translateResource( uri="preside-objects.security_user:action.send.label" )
		} );

		if ( loginService.isTwoFactorAuthenticationEnabled() ) {
			if ( isTrue( args.record.two_step_auth_key_in_use ) ) {
				ArrayAppend( args.childActions, {
					  link   = event.buildAdminLink( linkTo="datamanager.security_user.disableTwoFactorAuthAction", queryString="id=#recordId#" )
					, icon   = "fa-unlock red"
					, title  = translateResource( uri="preside-objects.security_user:action.2fa.disable.label" )
					, prompt = translateResource( uri="preside-objects.security_user:action.2fa.disable.prompt", data=[ args.record.known_as ] )
				} );
			}
		}

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
		if ( loginService.isTwoFactorAuthenticationEnabled() ) {
			var twoFactorAuth = isTrue( args.record.two_step_auth_key_in_use ) ? "enabled" : "disabled";

			return '<i class="fa fa-fw #translateResource( uri="preside-objects.security_user:infocard.two_step_auth_key_in_use.#twoFactorAuth#.iconClass" )#"></i> #translateResource( uri="preside-objects.security_user:infocard.two_step_auth_key_in_use.#twoFactorAuth#.label" )#';
		}

		return "";
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

	public void function activateUserAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		var securityUser = securityUserService.getUser( id=recordId, selectFields=[ "known_as" ] );

		if ( securityUserService.activateUser( id=recordId ) ) {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.activate.success", data=[ securityUser.known_as ] ) );
		} else {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.activate.error", data=[ securityUser.known_as ] ) );
		}

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=recordId ) );
	}

	public void function deactivateUserAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		var securityUser = securityUserService.getUser( id=recordId, selectFields=[ "known_as" ] );

		if ( securityUserService.deactivateUser( id=recordId ) ) {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.deactivate.success", data=[ securityUser.known_as ] ) );
		} else {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.deactivate.error", data=[ securityUser.known_as ] ) );
		}


		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=recordId ) );
	}

	public void function sendWelcomeEmail( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		event.initializeDatamanagerPage( "security_user", recordId );

		prc.record = securityUserService.getUser( id=recordId, selectFields=[ "id", "known_as" ] );

		if ( !prc.record.recordCount ) {
			messageBox.error( translateResource( uri="cms:websiteUserManager.userNotFound.error" ) );

			setNextEvent( url=event.buildAdminLink( objectName="security_user" ) );
		}

		prc.pageTitle = translateResource( uri="preside-objects.security_user:page.sendwelcomeemail.title", data=[ prc.record.known_as ] );
		prc.pageIcon  = "fa-envelope";

		event.addAdminBreadCrumb(
			  title = translateResource( uri="preside-objects.security_user:page.sendwelcomeemail.breadcrumb" )
			, link  = ""
		);
	}

	public void function disableTwoFactorAuthAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		loginService.disableTwoFactorAuthenticationForUser( userId=recordId );

		event.audit(
			  action = "disable_2fa"
			, type   = "userprofile"
		);

		var securityUser = securityUserService.getUser( id=recordId, selectFields=[ "known_as" ] );

		messagebox.info( translateResource( uri="preside-objects.security_user:message.2fa.disable.success", data=[ securityUser.known_as ] ) );

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=recordId ) );
	}

	public void function sendWelcomeEmailAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		event.initializeDatamanagerPage( "security_user", recordId );

		var securityUser = securityUserService.getUser( id=recordId, selectFields=[ "id", "known_as" ] );

		if ( !securityUser.recordCount ) {
			messageBox.error( translateResource( uri="cms:websiteUserManager.userNotFound.error" ) );

			setNextEvent( url=event.buildAdminLink( objectName="security_user" ) );
		}

		var formName         = "preside-objects.security_user.email.welcome";
		var formData         = event.getCollectionForForm( formName );
		var validationResult = validateForm( formName, formData );

		if ( !validationResult.validated() ) {
			var persist = formData;

			persist.validationResult = validationResult;

			messageBox.error( translateResource( "cms:datamanager.data.validation.error" ) );

			setNextEvent( url=event.buildAdminLink( linkTo="datamanager.security_user.sendWelcomeEmail", queryString="id=#recordId#" ), persistStruct=persist );
		}

		loginService.sendWelcomeEmail( userId=securityUser.id, createdBy=event.getAdminUserDetails().known_as, welcomeMessage=( formData.welcome_message ?: "" ) );

		messageBox.info( translateResource( uri="preside-objects.security_user:message.sendwelcomeemail.success", data=[ securityUser.known_as ] ) );

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=recordId ) );
	}

	private void function _checkPermissions( required any event, required string key ) {
		if ( !hasCmsPermission( arguments.key ) ) {
			event.adminAccessDenied();
		}
	}

}