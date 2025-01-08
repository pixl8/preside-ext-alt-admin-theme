component extends="preside.system.base.AdminHandler" {

	public function prehandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );

		prc.adminSidebarHeader = prc.adminSidebarHeader ?: "";

		prc.adminSidebarHeader &= renderView( view="/admin/adminManager/_sidebarHeader" );

		prc.adminSidebarItems  = prc.adminSidebarItems  ?: [];

		var currentEvent = event.getCurrentEvent();

		ArrayAppend( prc.adminSidebarItems, {
			  active = currentEvent == "admin.adminManager.users"
			, link   = event.buildAdminLink( "adminManager.users" )
			, title  = translateResource( uri="admin.adminManager:viewtab.users.title" )
			, badge  = getPresideObject( "security_user" ).selectData( recordCountOnly=true )
		} );

		ArrayAppend( prc.adminSidebarItems, {
			  active = currentEvent == "admin.adminManager.groups"
			, link   = event.buildAdminLink( "adminManager.groups" )
			, title  = translateResource( uri="admin.adminManager:viewtab.groups.title" )
			, badge  = getPresideObject( "security_group" ).selectData( recordCountOnly=true )
		} );

		prc.displayPageHeader = false;
	}

	public function users( event, rc, prc ) {
		prc.pageTitle = translateResource( uri="admin.adminManager:page.users.title" );
		prc.pageIcon  = translateResource( uri="admin.adminManager:page.users.iconClass" );

		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);

		event.addAdminBreadCrumb(
			  title = prc.pageTitle
			, link  = event.buildAdminLink( linkTo="admin.adminManager" )
		);
	}

	public function groups( event, rc, prc ) {
		prc.pageTitle = translateResource( uri="admin.adminManager:page.groups.title" );
		prc.pageIcon  = translateResource( uri="admin.adminManager:page.groups.iconClass" );

		event.addAdminBreadCrumb(
			  title = translateResource( uri="admin.adminManager:title" )
			, link  = event.buildAdminLink( linkTo="adminManager.users" )
		);

		event.addAdminBreadCrumb(
			  title = prc.pageTitle
			, link  = event.buildAdminLink( linkTo="admin.adminManager" )
		);
	}

}