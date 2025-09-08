component extends="preside.system.base.EnhancedDataManagerBase" {

	property name="presideObjectService" inject="PresideObjectService";
	property name="datamanagerService"   inject="DatamanagerService";
	property name="securityUserService"  inject="SecurityUserService";
	property name="loginService"         inject="LoginService";
	property name="notificationService"  inject="NotificationService";
	property name="permissionsCache"     inject="cachebox:PermissionsCache";

	variables.permissionBase = "usermanager";

	variables.infoCol1 = [ "language", "twoFactorAuth" ];
	variables.infoCol2 = [ "lastLoggedIn", "lastLoggedOut", "lastActive" ];

	variables.tabs = [ "dashboard", "groups", "notifications" ];

	variables.sidebarNavigation = true;

	private void function rootBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);
	}

	private void function objectBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri="preside-objects.security_user:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);
	}

	private array function getRecordActionsForGridListing( event, rc, prc, args={} ) {
		var objectName  = args.objectName ?: "";
		var record      = args.record     ?: {};
		var isDashboard = isTrue( args.isDashboard ?: "" );

		var actions = [];

		if ( hasCmsPermission( "usermanager.read" ) ) {
			ArrayAppend( actions, {
				  link       = event.buildAdminLink( objectName=objectName, recordId=record.id )
				, icon       = "fa-eye"
				, contextKey = "v"
			} );
		}

		if ( hasCmsPermission( "usermanager.edit" ) && !isDashboard ) {
			ArrayAppend( actions, {
				  link       = event.buildAdminLink( objectName=objectName, recordId=record.id, operation="editRecord", queryString="result_action=manager" )
				, icon       = "fa-pencil"
				, contextKey = "e"
			} );
		}

		if ( !isDashboard ) {
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
		}

		return actions;
	}

	private string function renderSidebarHeader( event, rc, prc, args={} ) {
		if ( !isEmptyString( args.record.id ?: "" ) ) {
			return renderView( view="/admin/datamanager/security_user/_sidebarHeader", args=args );
		}

		return "";
	}

	private array function getTopRightButtonsForViewRecord( event, rc, prc, args ) {
		var recordId    = prc.recordId ?: "";
		var recordLabel = Len( Trim( prc.record.known_as ?: "" ) ) ? prc.record.known_as : ( prc.recordLabel ?: "" );

		var actions  = [];
		var children = [];

		if ( isTrue( prc.record.active ?: "" ) ) {
			if ( recordId != event.getAdminUserId() ) {
				ArrayAppend( children, {
					  link   = event.buildAdminLink( linkTo="datamanager.security_user.setUserActivationAction", queryString="id=#recordId#&active=false" )
					, icon   = "fa-times-circle red"
					, title  = translateResource( uri="preside-objects.security_user:action.deactivate.label" )
					, prompt = translateResource( uri="preside-objects.security_user:action.deactivate.prompt", data=[ recordLabel ] )
				} );

				if ( isTrue( prc.record.subscribed_to_all_notifications ?:"" ) ) {
					ArrayAppend( children, {
						  link   = event.buildAdminLink( linkTo="datamanager.security_user.setNotificationSubscriptionAction", queryString="user_id=#recordId#&all=false" )
						, icon   = "fa-bell-slash red"
						, title  = translateResource( uri="preside-objects.security_user:action.notification.unsubscribe.all.label" )
						, prompt = translateResource( uri="preside-objects.security_user:action.notification.unsubscribe.all.prompt", data=[ recordLabel ] )
					} );
				} else {
					ArrayAppend( children, {
						  link   = event.buildAdminLink( linkTo="datamanager.security_user.setNotificationSubscriptionAction", queryString="user_id=#recordId#&all=true" )
						, icon   = "fa-bell"
						, title  = translateResource( uri="preside-objects.security_user:action.notification.subscribe.all.label" )
						, prompt = translateResource( uri="preside-objects.security_user:action.notification.subscribe.all.prompt", data=[ recordLabel ] )
					} );
				}
			}

			if ( loginService.isTwoFactorAuthenticationEnabled() ) {
				if ( isTrue( prc.record.two_step_auth_key_in_use ?: "" ) ) {
					ArrayAppend( children, {
						  link   = event.buildAdminLink( linkTo="datamanager.security_user.disableTwoFactorAuthAction", queryString="id=#recordId#" )
						, icon   = "fa-unlock red"
						, title  = translateResource( uri="preside-objects.security_user:action.2fa.disable.label" )
						, prompt = translateResource( uri="preside-objects.security_user:action.2fa.disable.prompt", data=[ recordLabel ] )
					} );
				}
			}

			ArrayAppend( children, {
				  link  = event.buildAdminLink( linkTo="datamanager.security_user.sendWelcomeEmail", queryString="id=#recordId#" )
				, icon  = "fa-envelope"
				, title = translateResource( uri="preside-objects.security_user:action.email.welcome.label" )
			} );

			ArrayAppend( children, {
				  link  = event.buildAdminLink( objectName="security_user", recordId=recordId, queryString="tab=groups" )
				, icon  = "fa-users"
				, title = translateResource( uri="preside-objects.security_user:action.groups.label" )
			} );
		} else {
			if ( recordId != event.getAdminUserId() ) {
				ArrayAppend( children, {
					  link   = event.buildAdminLink( linkTo="datamanager.security_user.setUserActivationAction", queryString="id=#recordId#&active=true" )
					, icon   = "fa-check-circle green"
					, title  = translateResource( uri="preside-objects.security_user:action.activate.label" )
					, prompt = translateResource( uri="preside-objects.security_user:action.activate.prompt", data=[ recordLabel ] )
				} );
			}
		}

		if ( prc.canDelete && recordId != event.getAdminUserId() ) {
			if ( ArrayLen( children ) ) {
				ArrayAppend( children, "---" );
			}

			ArrayAppend( children, {
				  link      = event.buildAdminLink( objectName="security_user", recordId=prc.recordId, operation="deleteRecordAction" )
				, icon      = "fa-trash red"
				, globalKey = "d"
				, title     = translateResource( uri="cms:datamanager.deleteRecord.btn" )
				, prompt    = translateResource( uri="cms:datamanager.deleteRecord.prompt", data=[ prc.objectTitle, stripTags( prc.recordLabel ) ] )
				, match     = datamanagerService.getDeletionConfirmationMatch( "security_user", QueryRowToStruct( prc.record ) )
			} );
		}

		if ( prc.canEdit ) {
			ArrayAppend( actions, {
				  link      = event.buildAdminLink( objectName="security_user", recordId=recordId, operation="editRecord" )
				, btnClass  = "btn-primary-default"
				, iconClass = "fa-pencil"
				, globalKey = "e"
				, title     = translateResource( "cms:datamanager.editRecord.btn" )
				, children  = children
			} );
		}

		return actions;
	}

	private function buildListingLink() {
		return event.buildAdminLink( linkto="adminManager.users", queryString=( args.queryString ?: "" ) );
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
		return renderView( view="/admin/datamanager/security_user/dashboard", args=args );
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
				  gridFields        = [ "label", "group_roles", "is_assigned" ]
				, compact           = true
				, useMultiActions   = false
				, allowFilter       = false
				, allowDataExport   = false
				, datasourceUrl     = event.buildAdminLink( linkTo="datamanager.security_user.getGroupsForAjaxDataTable", queryString="record_id=#recordId#" )
				, objectTitlePlural = translateResource( uri="preside-objects.security_group:title" )
			  }
		);
	}

	public void function getGroupsForAjaxDataTable( event, rc, prc ) {
		runEvent(
			  event          = "admin.DataManager._getObjectRecordsForAjaxDataTables"
			, prePostExempt  = true
			, private        = true
			, eventArguments = {
				  object          = "security_group"
				, gridFields      = "label,group_roles,is_assigned"
				, searchFields      = [ "label" ]
				, filterParams    = { "userId"={ type="cf_sql_varchar", value=( rc.record_id ?: "" ) } }
				, useMultiActions = false
				, actionsView     = "admin.datamanager.security_user._getGroupsActionsViewForAjaxDataTables"
				, useCache        = false
				, orderBy         = rc.order_by ?: ""
			}
		);
	}

	private string function _getGroupsActionsViewForAjaxDataTables( event, rc, prc, args={} ) {
		if ( hasCmsPermission( "usermanager.edit" ) ) {
			args.user_id     = rc.record_id ?: "";
			args.isDashboard = isTrue( rc.is_dashboard ?: "" );

			if ( args.isDashboard ) {
				args.record = args;

				var actions = runEvent(
					  event          = "admin.datamanager.security_user.getRecordActionsForGridListing"
					, prePostExempt  = true
					, private        = true
					, eventArguments = {
						  args=args
					  }
				);

				return renderView( view="/admin/datamanager/_listingActions", args={ actions=actions } );
			} else {
				return renderView( view="/admin/datamanager/security_user/_groupGridActions", args=args );
			}
		}

		return "";
	}

	private struct function _notificationsMenuItem( event, rc, prc, args={} ) {
		var userId = args.recordId ?: "";

		return { badge=securityUserService.getSubscriptionCount( userId=userId ) };
	}

	private string function _notificationsTab( event, rc, prc, args={} ) {
		var userId = args.recordId ?: "";

		return objectDataTable(
			  objectName = "admin_notification_topic"
			, args       = {
				  gridFields        = [ "topic_label", "topic_subscription", "topic_email" ]
				, compact           = true
				, useMultiActions   = false
				, allowFilter       = false
				, allowDataExport   = false
				, datasourceUrl     = event.buildAdminLink( linkTo="datamanager.security_user.getNotificationsForAjaxDataTable", queryString="recordId=#userId#" )
				, objectTitlePlural = translateResource( uri="preside-objects.admin_notification_subscription:title.listing" )
			  }
		);
	}

	public void function getNotificationsForAjaxDataTable( event, rc, prc ) {
		var userId = rc.recordId ?: "";

		var extraFilters = [ { filter={ topic=notificationService.listTopics( userId=userId ) } } ];
		var filterParams = {};

		var subQuery = getPresideObject( "admin_notification_subscription" ).selectData(
			  selectFields        = [ "id", "topic", "get_email_notifications" ]
			, filter              = { security_user=userId }
			, getSqlAndParamsOnly = true
			, formatSqlParams     = true
		);

		StructAppend( filterParams, subQuery.params );

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
				, gridFields      = "id,topic,topic_label,topic_subscription,topic_email"
				, extraFilters    = extraFilters
				, useMultiActions = false
				, actionsView     = "admin.datamanager.security_user._getNotificationsActionsViewForAjaxDataTable"
				, useCache        = false
			}
		);
	}

	private string function _getNotificationsActionsViewForAjaxDataTable( event, rc, prc, args={} ) {
		if ( hasCmsPermission( "usermanager.edit" ) ) {
			args.user_id = rc.recordId ?: "";

			return renderView( view="/admin/datamanager/security_user/_notificationGridActions", args=args );
		}

		return "";
	}

	private void function postAddRecordAction( event, rc, prc, args={} ) {
		if ( isTrue( args.formData.send_welcome ?: "" ) ) {
			var userId = args.newId ?: "";

			loginService.sendWelcomeEmail( userId=userId, createdBy=event.getAdminUserDetails().known_as, welcomeMessage=( args.formData.welcome_message ?: "" ) );

			var securityUser = securityUserService.getUser( userId=userId, selectFields=[ "known_as" ] );

			event.audit(
				  action   = "send_welcome_email"
				, type     = "usermanager"
				, recordId = userId
				, detail   = queryRowToStruct( securityUser )
			);
		}
	}

	private void function preRenderEditRecordForm( event, rc, prc, args={} ) {
		var objectName = args.objectName ?: "";
		var recordId   = args.recordId   ?: "";

		args.cancelAction = ( rc.result_action ?: "" ) == "manager" ? event.buildAdminLink( linkTo="adminManager.users" ) : event.buildAdminLink( objectName=objectName, recordId=recordId );
	}

	public void function setUserActivationAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var userId = rc.id ?: "";
		var active = isTrue( rc.active ?: "" );

		var securityUser = securityUserService.getUser( userId=userId, selectFields=[ "known_as" ] );

		if ( securityUserService.saveActivation( userId=userId, active=active ) ) {
			permissionsCache.clearAll();

			event.audit(
				  action   =  active ? "activate_user" : "deactivate_user"
				, type     = "usermanager"
				, recordId = userId
				, detail   = queryRowToStruct( securityUser )
			);

			messagebox.info( translateResource( uri="preside-objects.security_user:message.user.#( active ? "activate" : "deactivate" )#.success", data=[ securityUser.known_as ] ) );
		} else {
			messagebox.error( translateResource( uri="preside-objects.security_user:message.user.#( active ? "activate" : "deactivate" )#.error", data=[ securityUser.known_as ] ) );
		}

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=userId ) );
	}

	public void function disableTwoFactorAuthAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var userId = rc.id ?: "";

		loginService.disableTwoFactorAuthenticationForUser( userId=userId );

		var securityUser = securityUserService.getUser( userId=userId, selectFields=[ "known_as" ] );

		event.audit(
			  action   = "disable_2fa"
			, type     = "usermanager"
			, recordId = userId
			, detail   = queryRowToStruct( securityUser )
		);

		messagebox.info( translateResource( uri="preside-objects.security_user:message.2fa.disable.success", data=[ securityUser.known_as ] ) );

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=userId ) );
	}

	public void function setGroupAssignationAction( event, rc, prc, args={} ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var recordId = rc.id      ?: "";
		var userId   = rc.user_id ?: "";
		var assign   = isTrue( rc.assign ?: "" );

		var securityGroup = securityUserService.getGroup( groupId=recordId, selectFields=[ "label" ] );
		var securityUser  = securityUserService.getUser( userId=userId, selectFields=[ "known_as" ] );

		if ( securityUserService.saveGroup( groupId=recordId, userId=userId, assign=assign ) ) {
			permissionsCache.clearAll();

			event.audit(
				  action   = "edit_user"
				, type     = "usermanager"
				, recordId = userId
				, detail   = queryRowToStruct( securityUser )
			);

			messagebox.info( translateResource( uri="preside-objects.security_user:message.group.#( assign ? "add" : "delete" )#.success", data=[ securityUser.known_as, securityGroup.label ] ) );
		} else {
			messagebox.error( translateResource( uri="preside-objects.security_user:message.group.add.error", data=[ securityUser.known_as, securityGroup.label ] ) );
		}

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=userId, queryString="tab=groups" ) );
	}

	public void function sendWelcomeEmail( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var userId = rc.id ?: "";

		event.initializeDatamanagerPage( "security_user", userId );

		prc.record = securityUserService.getUser( userId=userId, selectFields=[ "id", "known_as" ] );

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

	public void function setNotificationSubscriptionAction( event, rc, prc ) {
		_checkPermissions( event=event, key="usermanager.edit" );

		var userId       = rc.user_id ?: "";
		var notification = isTrue( rc.notification ?: "" );
		var email        = isTrue( rc.email        ?: "" );

		var topics = [];

		if ( StructKeyExists( rc, "all" ) ) {
			topics = notificationService.listTopics( userId=userId );

			notification = isTrue( rc.all );
		} else {
			ArrayAppend( topics, rc.topic ?: "" );
		}

		try {
			for ( var topic in topics ) {
				securityUserService.saveSubscription( topic=topic, userId=userId, notification=notification, email=email );
			}

			messagebox.info( translateResource( uri="preside-objects.security_user:message.notification.save.success" ) );
		} catch ( any e ) {
			messagebox.error( translateResource( uri="preside-objects.security_user:message.notification.save.error" ) );
		}

		setNextEvent( url=event.buildAdminLink( objectName="security_user", recordId=userId, queryString="tab=notifications" ) );
	}

	private void function _checkPermissions( required any event, required string key ) {
		if ( !hasCmsPermission( arguments.key ) ) {
			event.adminAccessDenied();
		}
	}

}