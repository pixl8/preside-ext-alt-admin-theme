component extends="preside.system.base.AdminHandler" {
	function preHandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );
	}

	function index( event, rc, prc ) {
		prc.pageTitle = "List Steps";

		event.addAdminBreadCrumb(
			  title = "Design System"
			, link  = event.buildAdminLink( linkTo="designSystem" )
		);

		event.addAdminBreadCrumb(
			  title = "List Steps"
			, link  = event.buildAdminLink( linkTo="designSystem/components/listSteps" )
		);

		event.setView( view = "admin/designSystem/components/listSteps" );
	}
}