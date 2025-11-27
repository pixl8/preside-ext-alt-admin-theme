component extends="preside.system.base.AdminHandler" {

	property name="dataManagerCustomizationService" inject="DataManagerCustomizationService";
	property name="passwordPolicyService"           inject="PasswordPolicyService";
	property name="systemConfigurationService"      inject="SystemConfigurationService";
	property name="presideObjectService"            inject="PresideObjectService";
	property name="systemAlertsService"             inject="SystemAlertsService";
	property name="formsService"                    inject="FormsService";
	property name="tenancySetting"                  inject="coldbox:setting:tenancy";

	public function prehandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );

		prc.adminSidebarHeader = renderView( view="/admin/sysConfigManager/_sidebarHeader", args={
			  title       = translateResource( uri="admin.adminManager:title" )
			, description = translateResource( uri="admin.adminManager:description" )
		} );

		prc.adminSidebarItems    = _loadSidebarItems( argumentCollection=arguments );
		prc.adminSiderbarContext = "adminManager";
	}

	public function index( event, rc, prc ) {
		var firstItem = ArrayFirst( prc.adminSidebarItems );

		if ( !isEmptyString( firstItem.link ?: "" ) ) {
			setNextEvent( url=firstItem.link );
		}
	}

	public function users( event, rc, prc ) {
		_initManager( argumentCollection=arguments, objectName="security_user" );
	}

	public function groups( event, rc, prc ) {
		_initManager( argumentCollection=arguments, objectName="security_group" );
	}

	public function policies( event, rc, prc ) {
		if ( !isFeatureEnabled( "passwordPolicyManager" ) ) {
			event.notFound();
		}

		if ( !hasCmsPermission( permissionKey="passwordPolicyManager.manage" ) ) {
			event.adminAccessDenied();
		}

		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);

		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:viewtab.security.title" )
			, link  = ""
		);

		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:viewtab.policies.title" )
			, link  = ""
		);

		prc.pageTitle = translateResource( uri="admin.adminManager:viewtab.policies.title" );
		prc.pageIcon  = translateResource( uri="admin.adminManager:viewtab.policies.iconClass" );

		prc.formName   = "preside-objects.password_policy.admin.edit";
		prc.formAction = event.buildAdminLink( linkTo="adminManager.policiesAction" );
		prc.savedData  = passwordPolicyService.getPolicy( "cms" );
	}

	public function policiesAction( event, rc, prc ) {
		if ( !isFeatureEnabled( "passwordPolicyManager" ) ) {
			event.notFound();
		}

		if ( !hasCmsPermission( permissionKey="passwordPolicyManager.manage" ) ) {
			event.adminAccessDenied();
		}

		if ( ArrayFindNoCase( passwordPolicyService.listContexts(), "cms" ) ) {
			var formName = "preside-objects.password_policy.admin.edit";
			var formData = event.getCollectionForForm( formName );

			var validationResult = validateForm( formName, formData );

			formData.min_length    = Val( formData.min_length    ?: "" );
			formData.min_numeric   = Val( formData.min_numeric   ?: "" );
			formData.min_strength  = Val( formData.min_strength  ?: "" );
			formData.min_symbols   = Val( formData.min_symbols   ?: "" );
			formData.min_uppercase = Val( formData.min_uppercase ?: "" );

			if ( validationResult.validated() ) {
				passwordPolicyService.savePolicy( argumentCollection=formData, context="cms" );

				messagebox.info( translateResource( "cms:passwordpolicymanager.policy.saved.confirmation" ) );
			} else {
				messagebox.info( translateResource( "cms:passwordpolicymanager.policy.validation.failed.message" ) );
			}
		}

		setNextEvent( url=event.buildAdminLink( linkTo="adminManager.policies" ) );
	}

	private function _initManager( required string objectName ) {
		rc.id = arguments.objectName;

		event.initializeDatamanagerPage( objectName=arguments.objectName );

		prc.topRightButtons = dataManagerCustomizationService.runCustomization(
			  objectName     = objectName
			, action         = "topRightButtons"
			, defaultHandler = "admin.datamanager.topRightButtons"
			, args           = { objectName=objectName, action="object" }
		);

		prc.pageTitle = translateResource( uri="preside-objects.#arguments.objectName#:title" );
		prc.pageIcon  = translateResource( uri="preside-objects.#arguments.objectName#:iconClass" );
	}

	private array function _loadSidebarItems( event, rc, prc, args={} ) {
		var items        = [];
		var currentEvent = event.getCurrentEvent();

		ArrayAppend( items, {
			  active        = currentEvent == "admin.adminManager.users"
			, link          = event.buildAdminLink( linkTo="adminManager.users" )
			, title         = translateResource( uri="admin.adminManager:viewtab.users.title" )
			, permissionKey = "usermanager.navigate"
			, badge         = getPresideObject( "security_user" ).selectData( recordCountOnly=true )
		} );

		ArrayAppend( items, {
			  active        = currentEvent == "admin.adminManager.groups"
			, link          = event.buildAdminLink( linkTo="adminManager.groups" )
			, title         = translateResource( uri="admin.adminManager:viewtab.groups.title" )
			, permissionKey = "groupmanager.manage"
			, badge         = getPresideObject( "security_group" ).selectData( recordCountOnly=true )
		} );

		var subItems = args.subItems ?: [];

		ArrayAppend( subItems, {
			  active        = currentEvent == "admin.adminManager.policies"
			, link          = event.buildAdminLink( linkTo="adminManager.policies" )
			, title         = translateResource( uri="admin.adminManager:viewtab.policies.title" )
			, icon          = "fa-key"
			, permissionKey = "passwordpolicymanager.manage"
		} );

		ArrayAppend( subItems, runEvent(
			  event          = "admin.sysConfigManager._sidebarItems"
			, prePostExempt  = true
			, private        = true
			, includeActions = false
			, eventArguments = {
				args = {
					  categoryId = "admin-login-security"
					, tabId      = rc.tab ?: ""
					, useTabs    = true
				}
			  }
		), true );

		if ( ArrayLen( subItems ) ) {
			ArrayAppend( items, {
				  title        = translateResource( uri="admin.adminManager:viewtab.security.title" )
				, subMenuItems = subItems
			} );
		}

		return items;
	}

	public void function getUserRecordsForAjaxDataTables( event, rc, prc ) {
		runEvent(
			  event          = "admin.DataManager._getObjectRecordsForAjaxDataTables"
			, prePostExempt  = true
			, private        = true
			, eventArguments = {
				  object       = "security_user"
				, gridFields   = "active,known_as,email_address,last_request_made,group_labels,has_two_step_auth"
				, searchFields = [ "known_as", "email_address" ]
			}
		);
	}

	public void function getGroupRecordsForAjaxDataTables( event, rc, prc ) {
		runEvent(
			  event          = "admin.DataManager._getObjectRecordsForAjaxDataTables"
			, prePostExempt  = true
			, private        = true
			, eventArguments = {
				  object       = "security_group"
				, gridFields   = "label,group_roles,user_count,is_catch_all"
				, searchFields = [ "label" ]
			}
		);
	}

}