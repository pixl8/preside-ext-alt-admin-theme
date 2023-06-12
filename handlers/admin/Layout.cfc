component {

	public string function customAdminCss( event, rc, prc, args={} ) {
		var cssFiles = getSetting( "admin.customCss" );

		for( var cssFile in cssFiles ) {
			event.include( cssFile, false );
		}

		return "";
	}

	public string function renderAdminSidebar( event, rc, prc, args={} ) {
		var adminSidebarItems   = prc.adminSidebarItems  ?: [];
		var adminSidebarHeader  = prc.adminSidebarHeader ?: "";

		if ( !ArrayLen( adminSidebarItems ) ) {
			return "";
		}

		var renderedSidebarMenu = renderViewlet( event="admin.layout.renderMenuItems", args={
			  menuItems        = adminSidebarItems
			, itemRenderer     = "admin.layout.adminSidebar._menuItem"
			, subItemRenderer  = "admin.layout.adminSidebar._menuItem"
		} );

		return renderView( view="admin/layout/adminSidebar", args={ sidebarMenu=renderedSidebarMenu, header=adminSidebarHeader } );
	}

}
