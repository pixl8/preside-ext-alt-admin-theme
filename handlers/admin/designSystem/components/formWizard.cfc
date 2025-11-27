component extends="preside.system.base.AdminHandler" {
	function preHandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );
	}

	function index( event, rc, prc ) {
		prc.pageTitle = "Form Wizard";

		event.addAdminBreadCrumb(
			  title = "Design System"
			, link  = event.buildAdminLink( linkTo="designSystem" )
		);

		event.addAdminBreadCrumb(
			  title = "Form Wizard"
			, link  = event.buildAdminLink( linkTo="designSystem/components/formWizard" )
		);

		event.setView( view = "admin/designSystem/components/formWizard" );
	}
}