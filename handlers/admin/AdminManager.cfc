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

		prc.adminSidebarHeader = prc.adminSidebarHeader ?: "";

		prc.adminSidebarHeader &= renderView( view="/admin/adminManager/_sidebarHeader" );

		prc.adminSidebarItems = prc.adminSidebarItems  ?: [];

		var currentEvent = event.getCurrentEvent();

		ArrayAppend( prc.adminSidebarItems, {
			  active = currentEvent == "admin.adminManager.users"
			, link   = event.buildAdminLink( linkTo="adminManager.users" )
			, title  = translateResource( uri="admin.adminManager:viewtab.users.title" )
			, badge  = getPresideObject( "security_user" ).selectData( recordCountOnly=true )
		} );

		ArrayAppend( prc.adminSidebarItems, {
			  active = currentEvent == "admin.adminManager.groups"
			, link   = event.buildAdminLink( linkTo="adminManager.groups" )
			, title  = translateResource( uri="admin.adminManager:viewtab.groups.title" )
			, badge  = getPresideObject( "security_group" ).selectData( recordCountOnly=true )
		} );

		ArrayAppend( prc.adminSidebarItems, {
			  active = currentEvent == "admin.adminManager.security"
			, title  = translateResource( uri="admin.adminManager:viewtab.security.title" )
			, subMenuItems = [
				 {
					  active        = ( rc.tab ?: "" ) == "rememberme"
					, link          = event.buildAdminLink( linkTo="adminManager.sysConfig", queryString="tab=rememberme" )
					, title         = translateResource( uri="admin.adminManager:viewtab.rememberme.title" )
					, icon          = "fa-clock"
					, permissionKey = "systemConfiguration.manage"
				  }
				, {
					  active        = ( rc.tab ?: "" ) == "2fa"
					, link          = event.buildAdminLink( linkTo="adminManager.sysConfig", queryString="tab=2fa" )
					, title         = translateResource( uri="admin.adminManager:viewtab.2fa.title" )
					, icon          = "fa-mobile"
					, permissionKey = "systemConfiguration.manage"
				  }
				, {
					  active        = currentEvent == "admin.adminManager.policies"
					, link          = event.buildAdminLink( linkTo="adminManager.policies" )
					, title         = translateResource( uri="admin.adminManager:viewtab.policies.title" )
					, icon          = "fa-key"
					, permissionKey = "passwordpolicymanager.manage"
				  }
			  ]
		} );
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

	public function sysConfig( event, rc, prc ) {
		if ( !isFeatureEnabled( "systemConfiguration" ) ) {
			event.notFound();
		}

		if ( !hasCmsPermission( permissionKey="systemConfiguration.manage" ) ) {
			event.adminAccessDenied();
		}

		prc.categoryId = rc.category ?: "admin-login-security";
		prc.tenantId   = rc.tenant   ?: "";
		prc.tabId      = rc.tab      ?: "";

		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);

		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:viewtab.security.title" )
			, link  = ""
		);

		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:viewtab.#tab#.title" )
			, link  = ""
		);

		prc.pageTitle = translateResource( uri="admin.adminManager:viewtab.#tab#.title" );
		prc.pageIcon  = translateResource( uri="admin.adminManager:viewtab.#tab#.iconClass" );

		try {
			prc.category = systemConfigurationService.getConfigCategory( id=prc.categoryId );
		} catch( any e ) {}

		prc.savedData     = {};
		prc.tenancy       = systemConfigurationService.getConfigCategoryTenancy( id=prc.categoryId );
		prc.tenancyConfig = false;

		if ( Len( prc.tenancy ) ) {
			prc.tenancyObject    = tenancySetting[ prc.tenancy ].object ?: prc.tenancy;
			prc.tenancyRecords   = presideObjectService.selectData(
				  objectName   = prc.tenancyObject
				, selectFields = [ "id" ]
			);
			prc.tenancyConfig = !isEmptyString( prc.tenantId ) && prc.tenancyRecords.recordCount > 1;

			if ( prc.tenancyConfig ) {
				prc.savedData = systemConfigurationService.getCategorySettings(
					  category        = prc.categoryId
					, includeDefaults = false
					, tenantId        = prc.tenantId
				);
			}
		}

		if ( !prc.tenancyConfig ) {
			prc.savedData = systemConfigurationService.getCategorySettings(
				  category           = prc.categoryId
				, globalDefaultsOnly = true
			);
		}

		prc.formName = formsService.createForm( basedOn=prc.category.getSiteForm(), generator=function( formDefinition ) {
			var rawDefinition = formDefinition.getRawDefinition();

			for( var formTab in rawDefinition.tabs ) {
				if ( formTab.id == prc.tabId ) {
					formDefinition.modifyTab(
						  id        = formTab.id
						, title     = ""
						, iconclass = ""
					);
				} else {
					formDefinition.modifyTab(
						  id      = formTab.id
						, deleted = true
					);
				}
			}
		} );
	}

	public function sysConfigAction( event, rc, prc ) {
		if ( !isFeatureEnabled( "systemConfiguration" ) ) {
			event.notFound();
		}

		if ( !hasCmsPermission( permissionKey="systemConfiguration.manage" ) ) {
			event.adminAccessDenied();
		}

		var categoryId = rc.category_id ?: "";
		var tenantId   = rc.tenant_id   ?: "";
		var formName   = rc.form_name   ?: "";
		var tabId      = rc.tab_id      ?: "";

		try {
			prc.category = systemConfigurationService.getConfigCategory( id=categoryId );
		} catch( any e ) {
			event.notFound();
		}

		var formData = event.getCollectionForForm( formName );

		var validationResult = validateForm(
			  formName      = formName
			, formData      = formData
			, ignoreMissing = Len( Trim( tenantId ) )
		);

		if ( !validationResult.validated() ) {
			messageBox.error( translateResource( uri="cms:sysconfig.validation.failed" ) );

			var persist = formData;

			persist.validationResult = validationResult;

			setNextEvent(
				  url           = event.buildAdminLink( linkTo="adminManager.sysConfig", queryString="tab=#tabId#" )
				, persistStruct = persist
			);
		}

		announceInterception( "preSaveSystemConfig", {
			  category         = categoryId
			, configuration    = formData
			, validationResult = validationResult
		} );

		if ( !isEmptyString( tenantId ) ) {
			for ( var setting in formData ){
				if ( isFalse( rc[ "_override_" & setting ] ?: "" ) ) {
					StructDelete( formData, setting );

					systemConfigurationService.deleteSetting(
						  category = categoryId
						, setting  = setting
						, tenantId = tenantId
					);
				}
			}
		}

		for ( var setting in formData ) {
			systemConfigurationService.saveSetting(
				  category = categoryId
				, setting  = setting
				, value    = formData[ setting ]
				, tenantId = tenantId
			);
		}

		systemAlertsService.runWatchedSettingsChecks( categoryId );

		event.audit(
			  action   = "save_sysconfig_category"
			, type     = "sysconfig"
			, recordId = categoryId
			, detail   = formData
		);

		announceInterception( "postSaveSystemConfig", {
			  category         = categoryId
			, configuration    = formData
		} );

		messageBox.info( translateResource( uri="cms:sysconfig.saved" ) );

		setNextEvent( url=event.buildAdminLink( linkTo="adminManager.sysConfig", queryString="tab=#tabId#&tenant=#tenantId#" ) );
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

}