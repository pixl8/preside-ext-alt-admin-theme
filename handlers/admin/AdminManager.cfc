component extends="preside.system.base.AdminHandler" {

	property name="dataManagerCustomizationService"  inject="DataManagerCustomizationService";

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
	}

	public function users( event, rc, prc ) {
		_initManager( argumentCollection=arguments, objectName="security_user" );
	}

	public function groups( event, rc, prc ) {
		_initManager( argumentCollection=arguments, objectName="security_group" );
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