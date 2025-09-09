component extends="preside.system.base.AdminHandler" {

	property name="systemConfigurationService"              inject="SystemConfigurationService";
	property name="systemConfigurationCustomisationService" inject="SystemConfigurationCustomisationService";
	property name="presideObjectService"                    inject="PresideObjectService";
	property name="formsService"                            inject="FormsService";
	property name="systemAlertsService"                     inject="SystemAlertsService";

	variables.maxTabCount = 6;

	public void function prehandler( event, rc, prc ) {
		super.preHandler( argumentCollection=arguments );

		prc.categoryId = rc.category ?: "";
		prc.tenantId   = rc.tenant   ?: "";
		prc.tabId      = rc.tab      ?: "";
		prc.tabClass   = "tabs-left";
		prc.tabsMax    = variables.maxTabCount;

		_loadVariables( argumentCollection=arguments );
	}

	public void function editConfig( event, rc, prc ) {
		_loadSidebar(
			  argumentCollection = arguments
			, args               = {
				  categoryId = prc.categoryId
				, tabId      = prc.tabId
				, tenantId   = prc.tenantId
				, useTabs    = !isEmptyString( prc.tabId )
			}
		);

		_loadBreadCrumbs(
			  argumentCollection = arguments
			, args               = {
				  categoryId = prc.categoryId
				, tabId      = prc.tabId
			}
		);



		prc.pageTitle    = translateResource( uri="cms:sysconfig.editCategory.title", data=[ prc.categoryName ] );
		prc.pageSubtitle = translateResource( uri=prc.category.getDescription(), defaultValue="" );
		prc.pageIcon     = translateResource( uri=prc.category.getIcon(), defaultValue="fa-cogs" );

		prc.savedData = systemConfigurationService.getCategorySettings(
			  category           = prc.categoryId
			, tenantId           = Len( prc.tenancy ) ? prc.tenantId : ""
			, includeDefaults    = !Len( prc.tenancy )
			, globalDefaultsOnly = !prc.tenancyConfig
		);;

		var formNameBase = prc.tenancyConfig ? prc.category.getSiteForm() : prc.category.getForm();

		prc.formName = formNameBase;

		if ( !isEmptyString( prc.tabId ) ) {
			prc.formName = formsService.createForm( basedOn=formNameBase, generator=function( formDefinition ) {
				var rawDefinition = formDefinition.getRawDefinition();

				for( var formTab in rawDefinition.tabs ) {
					if ( formTab.id == prc.tabId ) {
						formDefinition.modifyTab(
							  id        = formTab.id
							, title     = ""
							, iconclass = ""
						);

						if ( prc.tenancyConfig ) {
							for ( var formFieldset in formTab.fieldsets ) {
								formDefinition.modifyTab(
									  id          = formFieldset.id
									, tab         = formTab.id
									, description = '<div class="alert alert-warning"><i class="fa fa-fw fa-exclamation-triangle"></i> #translateResource( uri="admin.adminManager:fieldset.tenancy.description", data=[ renderLabel( prc.tenancyObject, prc.tenantId ) ] )#</div>'
								);
							}
						}
					} else {
						formDefinition.modifyTab(
							  id      = formTab.id
							, deleted = true
						);
					}
				}

				var tabTitle = translateResource( uri="#rawDefinition.i18nBaseUri#tab.#prc.tabId#.title", defaultValue=prc.tabId );

				event.addAdminBreadCrumb(
					  title = tabTitle
					, link  = ""
				);

				prc.pageTitle    = translateResource( uri="cms:sysconfig.editCategory.title", data=[ tabTitle ] );
				prc.pageSubtitle = translateResource( uri="#rawDefinition.i18nBaseUri#tab.#prc.tabId#.description", defaultValue="" );

				prc.tabClass = "";
			} );
		}

		event.setView( view="/admin/sysConfigManager/_editConfig" );
	}

	public void function editConfigAction( event, rc, prc ) {
		var formName = rc.$presideform ?: "";
		var formData = event.getCollectionForForm( formName );

		if ( Len( Trim( prc.tenantId  ) ) ) {
			for ( var setting in formData ) {
				if ( IsFalse( rc[ "_override_" & setting ] ?: "" ) ) {
					formData.delete( setting );

					systemConfigurationService.deleteSetting(
						  category = prc.categoryId
						, tenantId = prc.tenantId
						, setting  = setting
					);
				}
			}
		}

		var validationResult = validateForm(
			  formName      = formName
			, formData      = formData
			, ignoreMissing = Len( Trim( prc.tenantId ) )
		);

		announceInterception( "preSaveSystemConfig", {
			  category         = prc.categoryId
			, configuration    = formData
			, validationResult = validationResult
		} );

		if ( !validationResult.validated() ) {
			messageBox.error( translateResource( uri="cms:sysconfig.validation.failed" ) );

			var persist = formData;

			persist.validationResult = validationResult;

			setNextEvent(
				  url           = event.buildAdminLink(linkTo="sysconfig.category", queryString="id=#prc.categoryId#&tenantId=#prc.tenantId#" )
				, persistStruct = persist
			);
		}

		for( var setting in formData ) {
			systemConfigurationService.saveSetting(
				  category = prc.categoryId
				, tenantId = prc.tenantId
				, setting  = setting
				, value    = formData[ setting ]
			);
		}

		if ( prc.categoryId != "dynamicform" ) {
			systemAlertsService.runWatchedSettingsChecks( prc.categoryId );
		}

		event.audit(
			  action   = "save_sysconfig_category"
			, type     = "sysconfig"
			, recordId = prc.categoryId
			, detail   = formData
		);

		announceInterception( "postSaveSystemConfig", {
			  category      = prc.categoryId
			, configuration = formData
		} );

		messageBox.info( translateResource( uri="cms:sysconfig.saved" ) );

		setNextEvent( url=event.buildAdminLink( linkTo="sysConfigManager.editConfig", queryString="category=#prc.categoryId#&tab=#prc.tabId#&tenant=#prc.tenantId#" ) );
	}

	private void function _checkPermissions( event, rc, prc ) {
		if ( !isFeatureEnabled( "systemConfiguration" ) ) {
			event.notFound();
		}

		if ( !hasCmsPermission( permissionKey="systemConfiguration.manage" ) ) {
			event.adminAccessDenied();
		}
	}

	private void function _loadVariables( event, rc, prc ) {
		try {
			prc.category     = systemConfigurationService.getConfigCategory( id=prc.categoryId );
			prc.categoryName = translateResource( uri=prc.category.getName(), defaultValue=prc.category.getId() );
		} catch( any e ) {
			event.notFound();
		}

		prc.tenancy       = systemConfigurationService.getConfigCategoryTenancy( id=prc.categoryId );
		prc.tenancyConfig = false;

		if ( Len( prc.tenancy ) ) {
			prc.tenancyObject  = tenancySetting[ prc.tenancy ].object ?: prc.tenancy;
			prc.tenancyRecords = presideObjectService.selectData(
				  objectName   = prc.tenancyObject
				, selectFields = [ "id" ]
			);
			prc.tenancyConfig  = !isEmptyString( prc.tenantId ?: "" ) && prc.tenancyRecords.recordCount > 1;
		}
	}

	private string function _sidebarHeader( event, rc, prc, args={} ) {
		return renderView( view="/admin/sysConfigManager/_sidebarHeader", args={
			  title       = args.categoryName ?: ""
			, description = translateResource( uri=( args.categoryDescription ?: "" ), defaultValue="" )
		} );
	}

	private array function _sidebarItems( event, rc, prc, args={} ) {
		var items = args.items ?: [];

		if ( isTrue( args.useTabs ?: false ) ) {
			if ( !isEmptyString( args.categoryId ?: "" ) ) {
				prc.categoryId = args.categoryId;

				_loadVariables( argumentCollection=arguments );
			}

			var formName       = prc.tenancyConfig ? prc.category.getSiteForm() : prc.category.getForm()
			var formDefinition = formsService.getForm( formName=formName );

			for ( var formTab in formDefinition.tabs ) {
				ArrayAppend( items, {
					  active        = formTab.id == ( args.tabId ?: "" )
					, link          = event.buildAdminLink( linkTo="sysConfigManager.editConfig", queryString="category=#args.categoryId#&tab=#formTab.id#" )
					, title         = translateResource( uri="#formDefinition.i18nBaseUri#tab.#formTab.id#.title"    , defaultValue=formTab.id )
					, icon          = translateResource( uri="#formDefinition.i18nBaseUri#tab.#formTab.id#.iconClass", defaultValue="" )
					, permissionKey = "systemConfiguration.manage"
				} );
			}
		}

		return items;
	}

	private void function _loadSidebar( event, rc, prc, args={} ) {
		var args = {
			  categoryId = args.categoryId ?: ""
			, tabId      = args.tabId      ?: ""
			, useTabs    = args.useTabs    ?: ""
		};

		prc.adminSiderbarContext = "adminManager";

		prc.adminSidebarHeader = systemConfigurationCustomisationService.runCustomisation(
			  category       = args.categoryId ?: ""
			, action         = "sidebarHeader"
			, defaultAction  = "admin.sysConfigManager._sidebarHeader"
			, args           = args
			, defaultResult  = ""
		);

		prc.adminSidebarItems = systemConfigurationCustomisationService.runCustomisation(
			  category       = args.categoryId ?: ""
			, action         = "sidebarItems"
			, defaultAction  = "admin.sysConfigManager._sidebarItems"
			, args           = args
			, defaultResult  = []
		);
	}

	private void function _rootBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.sysConfigManager:title" )
			, link  = ""
		);
	}

	private void function _categoryBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri=prc.category.getName(), defaultValue=prc.category.getId() )
			, link  = ""
		);
	}

	private void function _loadBreadCrumbs( event, rc, prc, args={} ) {
		systemConfigurationCustomisationService.runCustomisation(
			  category      = args.categoryId ?: ""
			, action        = "rootBreadcrumb"
			, defaultAction = "admin.sysConfigManager._rootBreadcrumb"
			, args          = args
		);

		if ( !isEmptyString( args.categoryId ) ) {
			systemConfigurationCustomisationService.runCustomisation(
				  category       = args.categoryId ?: ""
				, action         = "categoryBreadcrumb"
				, defaultAction  = "admin.sysConfigManager._categoryBreadcrumb"
				, args           = args
			);
		}
	}

}