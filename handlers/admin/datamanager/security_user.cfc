component extends="preside.system.base.EnhancedDataManagerBase" {

	property name="presideObjectService" inject="PresideObjectService";
	property name="datamanagerService"   inject="DatamanagerService";
	property name="securityUserService"  inject="SecurityUserService";
	property name="loginService"         inject="LoginService";
	property name="notificationService"  inject="NotificationService";
	property name="permissionsCache"     inject="cachebox:PermissionsCache";

	variables.infoCol1 = [ "language", "twoFactorAuth", "notification" ];
	variables.infoCol2 = [ "lastLoggedIn", "lastLoggedOut", "lastActive" ];

	variables.tabs = [
		  "dashboard"
		, "groups"
		, "notifications"
	];

	variables.sidebarNavigation = true;

	private array function getActionsForGridListing( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: "";
		var records    = args.records    ?: QueryNew( "" );
		var operations = [];

		for ( var record in records ) {
			var actions = [];

			if ( hasCmsPermission( "usermanager.read" ) ) {
				ArrayAppend( actions, {
					  link       = event.buildAdminLink( objectName=objectName, recordId=record.id )
					, icon       = "fa-eye"
					, contextKey = "v"
				} );
			}

			if ( hasCmsPermission( "usermanager.edit" ) ) {
				ArrayAppend( actions, {
					  link       = event.buildAdminLink( objectName=objectName, recordId=record.id, operation="editRecord" )
					, icon       = "fa-pencil"
					, contextKey = "e"
				} );
			}

			if ( hasCmsPermission( "usermanager.delete" ) && record.id != event.getAdminUserId() ) {
				ArrayAppend( actions, {
					  link       = event.buildAdminLink( objectName=objectName, recordId=record.id, operation="deleteRecordAction" )
					, icon       = "fa-trash"
					, contextKey = "d"
					, class      = "confirmation-prompt"
					, title      = translateResource( uri="cms:datamanager.deleteRecord.prompt", data=[ translateResource( uri="preside-objects.#objectName#:title.singular", defaultValue=objectName ), record.known_as ] )
					, match      = dataManagerService.useTypedConfirmationForDeletion( objectName ) ? datamanagerService.getDeletionConfirmationMatch( objectName, record ) : ""
				} );
			} else {
				ArrayAppend( actions, {
					  link       = "##"
					, icon       = "fa-trash grey"
					, contextKey = "d"
				} );
			}

			ArrayAppend( operations, renderView( view="/admin/datamanager/_listingActions", args={ actions=actions } ) );
		}

		return operations;
	}

	private string function renderSidebarHeader( event, rc, prc, args={} ) {
		prc.displayPageHeader  = false;

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

	private string function _infoCard( event, rc, prc, args={} ) {
		var activeTab = rc.tab ?: "dashboard";

		if ( activeTab == "dashboard" ) {
			return super._infoCard( argumentCollection=arguments );
		}

		return "";
	}

	private string function _infoCardLanguage( event, rc, prc, args={} ) {
		var locale = translateResource( uri="preside-objects.security_user:infocard.user_language.empty.label" );

		if ( !isEmptyString( args.record.user_language ) ) {
			var language = ListFirst( args.record.user_language, "_" );
			var country  = ListLen( args.record.user_language, "_" ) > 1 ? ListRest( args.record.user_language, "_" ) : "";

			locale = translateResource( uri="locale:title", language=language, country=country );
		}

		return '<i class="fa fa-fw fa-globe grey"></i> #translateResource( uri="preside-objects.security_user:infocard.user_language.label", data=[ locale ] )#';
	}

	private string function _infoCardTwoFactorAuth( event, rc, prc, args={} ) {
		if ( loginService.isTwoFactorAuthenticationEnabled() ) {
			return '<i class="fa fa-fw fa-user-secret grey"></i> #translateResource( uri="preside-objects.security_user:infocard.two_step_auth_key_in_use.label", data=[ renderContent( renderer="TwoFactorAuth", data=args.record.two_step_auth_key_in_use ) ] )#';
		}

		return "";
	}

	private string function _infoCardNotification( event, rc, prc, args={} ) {
		var recordId = args.recordId ?: "";

		var notification = isTrue( args.record.subscribed_to_all_notifications ) ? "all" : "none";

		if ( notification == "none" ) {
			var subscriptions = notificationService.getUserSubscriptions( userId=recordId );

			if ( ArrayLen( subscriptions ) ) {
				notification = '<a href="#event.buildAdminLink( objectName="security_user", recordId=recordId, queryString="tab=notifications" )#">#translateResource( uri="preside-objects.security_user:infocard.subscribed_to_all_notifications.custom" )#</a>';
			}
		} else {
			notification = translateResource( uri="preside-objects.security_user:infocard.subscribed_to_all_notifications.#notification#" );
		}


		return '<i class="fa fa-fw fa-bell grey"></i> #translateResource( uri="preside-objects.security_user:infocard.subscribed_to_all_notifications.label", data=[ notification ] )#';
	}

	private string function _infoCardLastLoggedIn( event, rc, prc, args={} ) {
		return '<i class="fa fa-fw fa-sign-in grey"></i> #translateResource( uri="preside-objects.security_user:infocard.last_logged_in.label", data=[ renderContent( renderer="DateTime", data=args.record.last_logged_in, context="relative" ) ] )#';
	}

	private string function _infoCardLastLoggedOut( event, rc, prc, args={} ) {
		return '<i class="fa fa-fw fa-sign-out grey"></i> #translateResource( uri="preside-objects.security_user:infocard.last_logged_out.label", data=[ renderContent( renderer="DateTime", data=args.record.last_logged_out, context="relative" ) ] )#';
	}

	private string function _infoCardLastActive( event, rc, prc, args={} ) {
		return '<i class="fa fa-fw fa-history grey"></i> #translateResource( uri="preside-objects.security_user:infocard.last_request_made.label", data=[ renderContent( renderer="DateTime", data=args.record.last_request_made, context="relative" ) ] )#';
	}

	private string function _dashboardTab( event, rc, prc, args={} ) {
		var userId = args.recordId ?: "";

		return renderViewlet( event="admin.audittrail.recordTrailViewlet", args={ recordId=userId } );;
	}

	private struct function _groupsMenuItem( event, rc, prc, args={} ) {
		var userId = args.recordId ?: "";

		return { badge=securityUserService.getGroupCount( userId=userId )};
	}

	private string function _groupsTab( event, rc, prc, args={} ) {
		var recordId = args.recordId ?: "";

		return objectDataTable(
			  objectName = "security_group"
			, args       = {
				  gridFields        = [ "label", "group_roles" ]
				, compact           = true
				, useMultiActions   = false
				, allowFilter       = false
				, allowDataExport   = false
				, datasourceUrl     = event.buildAdminLink( linkTo="datamanager.security_user.getGroupsForAjaxDataTable", queryString="recordId=#recordId#" )
				, objectTitlePlural = translateResource( uri="preside-objects.security_group:title" )
			  }
		);
	}

	public void function getGroupsForAjaxDataTable( event, rc, prc ) {
		var extraFilters = [ {
			  filter=" users.id = :userId"
			, filterParams = {
				"userId"={ type="cf_sql_varchar", value=( rc.recordId ?: "" ) }
			  }
		} ];

		runEvent(
			  event          = "admin.DataManager._getObjectRecordsForAjaxDataTables"
			, prePostExempt  = true
			, private        = true
			, eventArguments = {
				  object          = "security_group"
				, gridFields      = "label,group_roles"
				, extraFilters    = extraFilters
				, useMultiActions = false
				, actionsView     = "admin.datamanager.security_user._getGroupsActionsViewForAjaxDataTables"
				, useCache        = false
			}
		);
	}

	private string function _getGroupsActionsViewForAjaxDataTables( event, rc, prc, args={} ) {
		var actions = [];

		if ( hasCmsPermission( "usermanager.edit" ) ) {
			var groupId = args.id     ?: "";
			var userId  = rc.recordId ?: "";

			ArrayAppend( actions, {
				  link  = event.buildAdminLink( linkTo="datamanager.security_user.deleteGroupAction", queryString="id=#groupId#&user_id=#userId#" )
				, icon  = "fa-trash"
				, class = "confirmation-prompt"
				, title = translateResource( uri="preside-objects.security_user:action.group.delete.prompt", data=[ args.label ] )
			} );
		}

		return renderView( view="/admin/datamanager/_listingActions", args={ actions=actions } );
	}

	private struct function _notificationsMenuItem( event, rc, prc, args={} ) {
		var userId = args.recordId ?: "";

		return { badge=securityUserService.getSubscriptionCount( userId=userId ) };
	}

	private string function _notificationsTab( event, rc, prc, args={} ) {
		var recordId = args.recordId ?: "";

		return objectDataTable(
			  objectName = "admin_notification_topic"
			, args       = {
				  gridFields        = [ "topic_label", "topic_subscription", "topic_email" ]
				, compact           = true
				, useMultiActions   = false
				, allowFilter       = false
				, allowDataExport   = false
				, datasourceUrl     = event.buildAdminLink( linkTo="datamanager.security_user.getNotificationsForAjaxDataTable", queryString="recordId=#recordId#" )
				, objectTitlePlural = translateResource( uri="preside-objects.admin_notification_subscription:title.listing" )
				, orderBy           = "topic_subscription desc"
			  }
		);
	}

	public void function getNotificationsForAjaxDataTable( event, rc, prc ) {
		var extraFilters = [];
		var filterParams = {};

		var subQuery = getPresideObject( "admin_notification_subscription" ).selectData(
			  selectFields        = [ "id", "topic", "security_user", "get_email_notifications" ]
			, filter              = { security_user=( rc.recordId ?: "" ) }
			, getSqlAndParamsOnly = true
		);

		for( var param in subQuery.params ) { filterParams[ param.name ] = param; }

		ArrayAppend( extraFilters, {
			filter="1=1", filterParams=filterParams, extraJoins=[ {
				  type           = "left"
				, subQuery       = subQuery.sql
				, subQueryAlias  = "admin_notification_subscription_subquery"
				, subQueryColumn = "topic"
				, joinToTable    = "admin_notification_topic"
				, joinToColumn   = "topic"
			} ]
		} );

		runEvent(
			  event          = "admin.DataManager._getObjectRecordsForAjaxDataTables"
			, prePostExempt  = true
			, private        = true
			, eventArguments = {
				  object          = "admin_notification_topic"
				, gridFields      = "id,topic,topic_label,topic_subscription,topic_subscription_id,topic_email"
				, extraFilters    = extraFilters
				, useMultiActions = false
				, actionsView     = "admin.datamanager.security_user._getNotificationsActionsViewForAjaxDataTable"
				, useCache        = false
			}
		);
	}

	private string function _getNotificationsActionsViewForAjaxDataTable( event, rc, prc, args={} ) {
		var actions = [];

		if ( hasCmsPermission( "usermanager.edit" ) ) {
			var topicId = args.id ?: "";
			var topic        = args.topic                 ?: "";
			var userId         = rc.recordId                ?: "";

			ArrayAppend( actions, {
				  link = event.buildAdminLink( linkTo="datamanager.security_user.editNotificationSubscription", queryString="id=#topicId#&user_id=#userId#&topic=#topic#" )
				, icon = "fa-pencil"
			} );
		}

		return renderView( view="/admin/datamanager/_listingActions", args={ actions=actions } );
	}

	private void function postAddRecordAction( event, rc, prc, args={} ) {
		if ( isTrue( args.formData.send_welcome ?: "" ) ) {
			var recordId = args.newId ?: "";

			var securityUser = securityUserService.getUser( userId=recordId, selectFields=[ "id", "known_as" ] );

			loginService.sendWelcomeEmail( userId=securityUser.id, createdBy=event.getAdminUserDetails().known_as, welcomeMessage=( args.formData.welcome_message ?: "" ) );

			event.audit(
				  action   = "send_welcome_email"
				, type     = "usermanager"
				, recordId = recordId
				, detail   = queryRowToStruct( securityUser )
			);
		}
	}

	public void function activateUserAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		var securityUser = securityUserService.getUser( userId=recordId, selectFields=[ "known_as" ] );

		if ( securityUserService.activateUser( userId=recordId ) ) {
			permissionsCache.clearAll();

			event.audit(
				  action   = "activate_user"
				, type     = "usermanager"
				, recordId = recordId
				, detail   = queryRowToStruct( securityUser )
			);

			messagebox.info( translateResource( uri="preside-objects.security_user:message.user.activate.success", data=[ securityUser.known_as ] ) );
		} else {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.user.activate.error", data=[ securityUser.known_as ] ) );
		}

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=recordId ) );
	}

	public void function deactivateUserAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		var securityUser = securityUserService.getUser( userId=recordId, selectFields=[ "known_as" ] );

		if ( securityUserService.deactivateUser( userId=recordId ) ) {
			permissionsCache.clearAll();

			event.audit(
				  action   = "deactivate_user"
				, type     = "usermanager"
				, recordId = recordId
				, detail   = queryRowToStruct( securityUser )
			);

			messagebox.info( translateResource( uri="preside-objects.security_user:message.user.deactivate.success", data=[ securityUser.known_as ] ) );
		} else {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.user.deactivate.error", data=[ securityUser.known_as ] ) );
		}

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=recordId ) );
	}

	public void function disableTwoFactorAuthAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		loginService.disableTwoFactorAuthenticationForUser( userId=recordId );

		var securityUser = securityUserService.getUser( userId=recordId, selectFields=[ "known_as" ] );

		event.audit(
			  action   = "disable_2fa"
			, type     = "usermanager"
			, recordId = recordId
			, detail   = queryRowToStruct( securityUser )
		);

		messagebox.info( translateResource( uri="preside-objects.security_user:message.2fa.disable.success", data=[ securityUser.known_as ] ) );

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=recordId ) );
	}

	public void function deleteGroupAction( event, rc, prc, args={} ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id      ?: "";
		var userId   = rc.user_id ?: "" ;

		var securityGroup = securityUserService.getGroup( groupId=recordId, selectFields=[ "label" ] );
		var securityUser  = securityUserService.getUser( userId=userId, selectFields=[ "known_as" ] );

		if ( securityUserService.deleteGroup( groupId=recordId, userId=userId ) ) {
			permissionsCache.clearAll();

			event.audit(
				  action   = "edit_user"
				, type     = "usermanager"
				, recordId = userId
				, detail   = queryRowToStruct( securityUser )
			);

			messagebox.info( translateResource( uri="preside-objects.security_user:message.group.delete.success", data=[ securityGroup.label, securityUser.known_as ] ) );
		} else {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.group.delete.error", data=[ securityGroup.label, securityUser.known_as ] ) );
		}

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=userId, queryString="tab=groups" ) );
	}

	public void function sendWelcomeEmail( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id ?: "";

		event.initializeDatamanagerPage( "security_user", recordId );

		prc.record = securityUserService.getUser( userId=recordId, selectFields=[ "id", "known_as" ] );

		if ( !prc.record.recordCount ) {
			messageBox.error( translateResource( uri="cms:websiteUserManager.userNotFound.error" ) );

			setNextEvent( url=event.buildAdminLink( objectName="security_user" ) );
		}

		prc.pageTitle = translateResource( uri="preside-objects.security_user:page.sendWelcomeEmail.title", data=[ prc.record.known_as ] );
		prc.pageIcon  = "fa-envelope";

		event.addAdminBreadCrumb(
			  title = translateResource( uri="preside-objects.security_user:page.sendWelcomeEmail.breadcrumb" )
			, link  = ""
		);
	}

	public void function sendWelcomeEmailAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var userId = rc.id ?: "";

		var securityUser = securityUserService.getUser( userId=userId, selectFields=[ "known_as" ] );

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

			setNextEvent( url=event.buildAdminLink( linkTo="datamanager.security_user.sendWelcomeEmail", queryString="id=#userId#" ), persistStruct=persist );
		}

		loginService.sendWelcomeEmail( userId=userId, createdBy=event.getAdminUserDetails().known_as, welcomeMessage=( formData.welcome_message ?: "" ) );

		event.audit(
			  action   = "send_welcome_email"
			, type     = "usermanager"
			, recordId = userId
			, detail   = queryRowToStruct( securityUser )
		);

		messageBox.info( translateResource( uri="preside-objects.security_user:message.sendwelcomeemail.success", data=[ securityUser.known_as ] ) );

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=userId ) );
	}

	public void function editNotificationSubscription( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var topicId = rc.id      ?: "";
		var topic   = rc.topic   ?: "";
		var userId  = rc.user_id ?: "";

		event.initializeDatamanagerPage( "admin_notification_topic", topicId );

		prc.record = securityUserService.getSubscription( topic=topic, userId=userId, selectFields=[ "id", "topic_subscription_id", "topic", "security_user", "get_email_notifications" ] );

		prc.savedData = {
			  notification = !isEmptyString( prc.record.topic_subscription_id ?: "" )
			, email        = isTrue( prc.record.get_email_notifications ?: "" )
		};

		prc.pageTitle = translateResource( uri="preside-objects.security_user:page.editNotificationSubscription.title", data=[ renderLabel( "security_user", userId ), translateResource( uri="notifications.#topic#:title", defaultValue=topic ) ] );
		prc.pageIcon  = "fa-bell";

		event.addAdminBreadCrumb(
			  title = translateResource( uri="preside-objects.security_user:page.editNotificationSubscription.breadcrumb" )
			, link  = ""
		);
	}

	public void function editNotificationSubscriptionAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var topicId = rc.id      ?: "";
		var topic   = rc.topic   ?: "";
		var userId  = rc.user_id ?: "";

		var formName         = "preside-objects.security_user.notification.subscription";
		var formData         = event.getCollectionForForm( formName );
		var validationResult = validateForm( formName, formData );

		if ( !validationResult.validated() ) {
			var persist = formData;

			persist.validationResult = validationResult;

			messageBox.error( translateResource( "cms:datamanager.data.validation.error" ) );

			setNextEvent( url=event.buildAdminLink( linkTo="datamanager.security_user.notification.subscription", queryString="id=#subscriptionId#&user_id=#userId#" ), persistStruct=persist );
		}

		if ( securityUserService.saveSubscription( topic=topic, userId=userId, notification=isTrue( formData.notification ?: "" ), email=isTrue( formData.email ?: "" ) ) ) {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.notification.save.success", data=[ renderContent( renderer="AdminNotificationTopicLabel", data=topic ) ] ) );
		} else {
			messagebox.info( translateResource( uri="preside-objects.security_user:message.notification.save.error", data=[ renderContent( renderer="AdminNotificationTopicLabel", data=topic ) ] ) );
		}

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=userId, queryString="tab=notifications" ) );
	}

	private void function _checkPermissions( required any event, required string key ) {
		if ( !hasCmsPermission( arguments.key ) ) {
			event.adminAccessDenied();
		}
	}

}