component extends="preside.system.base.AdminHandler" {
	function preHandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );
	}

	function onboardingChecklist( event, rc, prc ) {
		prc.pageTitle = "Onboarding Checklist";

		event.addAdminBreadCrumb(
			  title = "Design System"
			, link  = event.buildAdminLink( linkTo="designSystem" )
		);

		event.addAdminBreadCrumb(
			  title = "Onboarding Checklist"
			, link  = event.buildAdminLink( linkTo="designSystem.pages.onboardingChecklist" )
		);

		event.setView( view = "admin/designSystem/pages/onboardingChecklist" );
	}
}