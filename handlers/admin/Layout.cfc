component {

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
