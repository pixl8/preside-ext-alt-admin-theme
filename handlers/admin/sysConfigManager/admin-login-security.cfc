component extends="app.extensions.preside-ext-alt-admin-theme.handlers.admin.SysConfigManager" {

	variables.sidebarNavigation = true;

	private string function sidebarHeader() {
		return renderView( view="/admin/SysConfigManager/_sidebarHeader", args={
			  title       = translateResource( uri="admin.adminManager:title" )
			, description = translateResource( uri="admin.adminManager:description" )
		} );
	}

	private array function sidebarItems() {
		return runEvent(
			  event          = "admin.adminManager._loadSidebarItems"
			, prePostExempt  = true
			, private        = true
			, eventArguments = {}
		);
	}

	private void function rootBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);
	}

	private void function categoryBreadcrumb( event, rc, prc, args={} ) {
		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:viewtab.security.title" )
			, link  = ""
		);
	}

}