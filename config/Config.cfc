component {

	public void function configure( required struct config ) {
		var conf     = arguments.config;
		var settings = conf.settings ?: {};

		_setupAdminTheme( settings );
		_setupFeatures( settings );
		_setupPermissionsAndRoles( settings );
		_setupInterceptors( conf );
		_configureAdminTheme( settings );
		_setupNavigation( settings );
		_setupDerivatives( settings );
	}

	private void function _setupAdminTheme( required settings ) {
		settings.adminTheme.layout = settings.adminTheme.layout ?: "v1";

		settings.adminTheme.features              = settings.adminTheme.features ?: {};
		settings.adminTheme.features.v2Components = settings.adminTheme.features.v2Components ?: false;

		settings.adminTheme.iconBasePath = settings.adminTheme.iconBasePath ?: "/application/extensions/preside-ext-alt-admin-theme/assets/icons/adminui";

		_setupIcons( settings );

		settings.adminTheme.defaults.dataCardGrid.resultsPerPageOptions = [ 6, 12, 24, 48 ];
		settings.adminTheme.defaults.dataCardGrid.resultsPerPage        = 6;
	}

	private void function _setupIcons( required settings ) {
		var basePath = settings.adminTheme.iconBasePath;
		var defaults = {
			  "fa-android"              = { path = basePath & "/bot.svg" }
			, "fa-bolt"                 = { path = basePath & "/zap.svg" }
			, "fa-bell"                 = { path = basePath & "/bell.svg" }
			, "fa-book"                 = { path = basePath & "/book-open-check.svg" }
			, "fa-calendar"             = { path = basePath & "/calendar.svg" }
			, "fa-chart-line"           = { path = basePath & "/chart-line.svg" }
			, "fa-clipboard-list"       = { path = basePath & "/clipboard-list.svg" }
			, "fa-clock-o"              = { path = basePath & "/clock.svg" }
			, "fa-clone"                = { path = basePath & "/copy.svg" }
			, "fa-code"                 = { path = basePath & "/code.svg" }
			, "fa-code-fork"            = { path = basePath & "/git-fork.svg" }
			, "fa-star"                 = { path = basePath & "/star.svg" }
			, "fa-cloud-upload"         = { path = basePath & "/cloud-upload.svg" }
			, "fa-cogs"                 = { path = basePath & "/settings.svg" }
			, "fa-comment"              = { path = basePath & "/message-square.svg" }
			, "fa-ellipsis-v"           = { path = basePath & "/ellipsis-vertical.svg" }
			, "fa-envelope"             = { path = basePath & "/mail.svg" }
			, "fa-file-alt"             = { path = basePath & "/file-text.svg" }
			, "fa-group"                = { path = basePath & "/users.svg" }
			, "fa-magic"                = { path = basePath & "/sparkles.svg" }
			, "fa-money"                = { path = basePath & "/banknote.svg" }
			, "fa-check-circle"         = { path = basePath & "/circle-check.svg" }
			, "fa-times-circle"         = { path = basePath & "/circle-x.svg" }
			, "fa-exclamation-circle"   = { path = basePath & "/circle-alert.svg" }
			, "fa-eye"                  = { path = basePath & "/eye.svg" }
			, "fa-file-pdf"             = { path = basePath & "/file-text.svg" }
			, "fa-globe"                = { path = basePath & "/globe.svg" }
			, "fa-graduation-cap"       = { path = basePath & "/graduation-cap.svg" }
			, "fa-history"              = { path = basePath & "/history.svg" }
			, "fa-hourglass-half"       = { path = basePath & "/hourglass.svg" }
			, "fa-info-circle"          = { path = basePath & "/info.svg" }
			, "fa-key"                  = { path = basePath & "/key-round.svg" }
			, "fa-lightbulb-o"          = { path = basePath & "/lightbulb.svg" }
			, "fa-link"                 = { path = basePath & "/link.svg" }
			, "fa-map-signs"            = { path = basePath & "/signpost.svg" }
			, "fa-medkit"               = { path = basePath & "/briefcase-medical.svg" }
			, "fa-pencil"               = { path = basePath & "/pencil.svg" }
			, "fa-plus"                 = { path = basePath & "/plus.svg" }
			, "fa-hdd"                  = { path = basePath & "/hard-drive.svg" }
			, "fa-google-drive"         = { path = basePath & "/hard-drive.svg" }
			, "fa-google"               = { path = basePath & "/google.svg" }
			, "fa-dropbox"              = { path = basePath & "/dropbox.svg" }
			, "fa-windows"              = { path = basePath & "/microsoft.svg" }
			, "fa-vimeo"                = { path = basePath & "/video.svg" }
			, "fa-lock"                 = { path = basePath & "/lock.svg" }
			, "fa-sign-in"              = { path = basePath & "/log-in.svg" }
			, "fa-sign-out"             = { path = basePath & "/log-out.svg" }
			, "fa-sliders"              = { path = basePath & "/sliders-horizontal.svg" }
			, "fa-shield"               = { path = basePath & "/shield-check.svg" }
			, "fa-sitemap"              = { path = basePath & "/list-tree.svg" }
			, "fa-user-shield"          = { path = basePath & "/shield-user.svg" }
			, "fa-refresh"              = { path = basePath & "/refresh-cw.svg" }
			, "fa-refresh-cw"           = { path = basePath & "/refresh-cw.svg" }
			, "fa-tachometer"           = { path = basePath & "/gauge.svg" }
			, "fa-trash"                = { path = basePath & "/trash.svg" }
			, "fa-trash-o"              = { path = basePath & "/trash.svg" }
			, "fa-trash red"            = { path = basePath & "/trash.svg" }
			, "fa-ban"                  = { path = basePath & "/ban.svg" }
			, "fa-ban red"              = { path = basePath & "/ban.svg" }
			, "fa-database"             = { path = basePath & "/database.svg" }
			, "fa-file-text"            = { path = basePath & "/file-text.svg" }
			, "fa-file-text-o"          = { path = basePath & "/file-text.svg" }
			, "fa-hashtag"              = { path = basePath & "/hash.svg" }
			, "fa-line-chart"           = { path = basePath & "/chart-line.svg" }
			, "fa-list-ul"              = { path = basePath & "/list.svg" }
			, "fa-paperclip"            = { path = basePath & "/paperclip.svg" }
			, "fa-paragraph"            = { path = basePath & "/pilcrow.svg" }
			, "fa-server"               = { path = basePath & "/server.svg" }
			, "fa-tag"                  = { path = basePath & "/tag.svg" }
			, "fa-tags"                 = { path = basePath & "/tags.svg" }
			, "fa-tools"                = { path = basePath & "/toolbox.svg" }
			, "fa-users"                = { path = basePath & "/users.svg" }
			, "fa-play"                 = { path = basePath & "/play.svg" }
			, "fa-plug"                 = { path = basePath & "/plug.svg" }
			, "fa-plus-circle"          = { path = basePath & "/circle-plus.svg" }
			, "fa-share-alt"            = { path = basePath & "/share-2.svg" }
			, "fa-share-square-o"       = { path = basePath & "/square-arrow-out-up-right.svg" }
			, "fa-stop"                 = { path = basePath & "/circle-stop.svg" }
			, "fa-bookmark"             = { path = basePath & "/bookmark.svg" }
			, "fa-thumbs-down"          = { path = basePath & "/thumbs-down.svg" }
			, "fa-thumbs-up"            = { path = basePath & "/thumbs-up.svg" }
			, "fa-user-tie"             = { path = basePath & "/user.svg" }
			, "fa-user-times"           = { path = basePath & "/user-x.svg" }
			, "fa-user"                 = { path = basePath & "/user.svg" }
			, "fa-check"                = { path = basePath & "/check.svg" }
			, "fa-times"                = { path = basePath & "/x.svg" }
			, "fa-clock"                = { path = basePath & "/clock.svg" }
			, "fa-spinner"              = { path = basePath & "/loader-circle.svg" }
			, "fa-pause"                = { path = basePath & "/pause.svg" }
			, "fa-exclamation-triangle" = { path = basePath & "/triangle-alert.svg" }
		};

		settings.adminTheme.icons = settings.adminTheme.icons ?: {};
		StructAppend( settings.adminTheme.icons, defaults, false );
	}

	private void function _setupFeatures( settings ) {
		settings.features.siteSwitcher = {
			  enabled   = true
			, dependsOn = [ "sites" ]
		};
	}

	private void function _setupPermissionsAndRoles( settings ) {
		settings.adminPermissions.notifications = settings.adminPermissions.notifications ?: [];
		settings.adminPermissions.notifications.append( "view" );

		settings.adminRoles.viewNotifications = [ "notifications.view" ];
	}

	private void function _setupInterceptors( conf ) {
		ArrayAppend( conf.interceptors, { class="app.extensions.preside-ext-alt-admin-theme.interceptors.AltAdminThemeInterceptors", properties={} } );

		conf.interceptorSettings = conf.interceptorSettings ?: {};
		conf.interceptorSettings.customInterceptionPoints = conf.interceptorSettings.customInterceptionPoints ?: [];
		ArrayAppend( conf.interceptorSettings.customInterceptionPoints, "onAdminThemePrepareTopNavigationItems" );
		ArrayAppend( conf.interceptorSettings.customInterceptionPoints, "onAdminThemePrepareSettingsNavigationItems" );
	}

	private void function _configureAdminTheme( settings ) {
		settings.admin = {
			  topNavItems       = []
			, topNavMenuIcons   = true
			, favicon           = "/preside/system/assets/extension/preside-ext-alt-admin-theme/assets/images/preside-favicon.png"
			, adminAvatarSize   = 56
			, customCss         = []
			, topNavCacheSuffix = function( event, args={} ){
				return event.getAdminUserId() & "-" & event.getSiteId();
			}
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

		settings.adminConfigurationMenuItems = settings.adminConfigurationMenuItems ?: [];

		ArrayPrepend( settings.adminConfigurationMenuItems, "adminManager" );

		settings.adminMenuItems = settings.adminMenuItems ?: {};

		settings.adminMenuItems.adminManager = {
			  buildLinkArgs = { linkTo="adminManager.users" }
			, activeChecks  = { handlerPatterns="^admin\.adminManager\.users" }
			, permissionKey = "usermanager.navigate"
			, feature       = "cmsUserManager"
		};

		StructDelete( settings.adminMenuItems, "usermanager" );
		StructDelete( settings.adminMenuItems, "usergroupmanager" );
	}

	private void function _setupDerivatives( settings ) {
		settings.assetManager.derivatives.customHeaderImg75px = {
			  permissions     = "inherit"
			, transformations = [ { method="Resize", args={ width=75, height=75, maintainAspectRatio=true, useCropHint=true } } ]
		};
	}

}
