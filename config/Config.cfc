component {

	public void function configure( required struct config ) {
		var conf     = arguments.config;
		var settings = conf.settings ?: {};

		_setupFeatures( settings );
		_setupPermissionsAndRoles( settings );
		_setupInterceptors( conf );
		_configureAdminTheme( settings );
		_setupNavigation( settings );
		_setupDerivatives( settings );
	}


	private void function _setupFeatures( settings ) {
		settings.features.siteSwitcher.enabled = true;
	}

	private void function _setupPermissionsAndRoles( settings ) {
		settings.adminPermissions.notifications = settings.adminPermissions.notifications ?: [];
		settings.adminPermissions.notifications.append( "view" );

		settings.adminRoles.viewNotifications = [ "notifications.view" ];
	}

	private void function _setupInterceptors( conf ) {
		ArrayAppend( conf.interceptors, { class="app.extensions.preside-ext-alt-admin-theme.interceptors.AltAdminThemeInterceptors", properties={} } );
	}

	private void function _configureAdminTheme( settings ) {
		settings.admin = {
			  topNavItems     = []
			, topNavMenuIcons = true
			, favicon         = "/preside/system/assets/extension/preside-ext-alt-admin-theme/assets/images/preside-favicon.png"
			, adminAvatarSize = 56
			, customCss       = []
		};
	}

	private void function _setupNavigation( settings ) {
		settings.admin.topNavItems = [
			  "sitetree"
			, "assetmanager"
			, "datamanager"
			, "websiteusers"
			, "formbuilder"
			, "emailcenter"
		];

		settings.adminMenuItems.assetmanager.title = "admin.menuitem:assetmanager.title";
		settings.adminMenuItems.datamanager.title  = "admin.menuitem:datamanager.title";
		settings.adminMenuItems.formbuilder.title  = "admin.menuitem:formbuilder.title";
		settings.adminMenuItems.emailcenter.title  = "admin.menuitem:emailcenter.title";

		settings.adminMenuItems.siteManager = {
			  buildLinkArgs = { linkto="sites.manage" }
			, activeChecks  = { handlerPatterns="^admin\.sites\." }
			, title         = "cms:sitenav.managesites"
			, icon          = "fa-globe"
		};
	}

	private void function _setupDerivatives( settings ) {
		settings.assetManager.derivatives.customHeaderImg75px = {
			  permissions     = "inherit"
			, transformations = [ { method="Resize", args={ width=75, height=75, maintainAspectRatio=true, useCropHint=true } } ]
		};
	}

}
