component extends="preside.system.base.AdminHandler" {

	function preHandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );
	}

	function index( event, rc, prc ) {
		prc.pageTitle = "Design System";

		event.addAdminBreadCrumb(
			  title = "Design System"
			, link  = event.buildAdminLink( linkTo="designSystem" )
		);
	}
}