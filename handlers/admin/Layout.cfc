component {

	property name="navItems"             inject="coldbox:setting:admin.topNavItems";
	property name="adminMenuItemService" inject="adminMenuItemService";

	public string function renderAdminSidebar( event, rc, prc, args={} ) {
		var adminSidebarItems  = prc.adminSidebarItems    ?: [];
		var adminSidebarHeader = prc.adminSidebarHeader   ?: "";
		var adminSidebarFooter = prc.adminSidebarFooter   ?: "";
		var siderbarContext    = prc.adminSiderbarContext ?: "";
		var eventHandler       = rc.event                 ?: "";

		if ( !ArrayLen( adminSidebarItems ) ) {
			return "";
		}

		if ( !Len( Trim( siderbarContext ) ) ) {
			siderbarContext = "global";

			if ( Len( Trim( prc.objectName ?: "" ) ) ) {
				siderbarContext = prc.objectName;
			} else if ( ListLen( eventHandler, "." ) > 1 ) {
				siderbarContext = ListGetAt( eventHandler, 2, "." );
			}
		}

		var renderedSidebarMenu = renderViewlet( event="admin.layout.renderMenuItems", args={
			  menuItems        = adminSidebarItems
			, itemRenderer     = "admin.layout.adminSidebar._menuItem"
			, subItemRenderer  = "admin.layout.adminSidebar._menuItem"
		} );

		return renderView( view="admin/layout/adminSidebar", args={ sidebarMenu=renderedSidebarMenu, header=adminSidebarHeader, footer=adminSidebarFooter, siderbarContext=siderbarContext } );
	}

	private string function topNavItems( event, rc, prc, args={} ) {
		var supportCache = StructKeyExists( adminMenuItemService, "getActiveItemForRequest" );
		var suffix       = supportCache ? ( args.cacheSuffix ?: event.getAdminUserId() ) : "";

		args.menu = renderViewlet( event="admin.layout.adminMenu", cache=supportCache, cacheProvider="adminMenuCache", cacheSuffix=suffix, args={
			  menuItems        = navItems
			, legacyViewBase   = "/admin/util/topNav/"
			, itemRenderer     = "/admin/util/topNav/_item"
			, subItemRenderer  = "/admin/layout/topnav/_subitem"
			, runActiveChecks  = false
		} );

		if ( Len( args.menu ) ) {
			args.activeItem = supportCache ? adminMenuItemService.getActiveItemForRequest( navItems ) : "";

			return renderView( view="/admin/util/topNavItems", args=args );
		}

		return "";
	}

}
