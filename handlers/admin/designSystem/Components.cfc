component extends="preside.system.base.AdminHandler" {
	function preHandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );
	}

	function emptyState( event, rc, prc ) {
		prc.pageTitle = "Empty State";

		event.addAdminBreadCrumb(
			  title = "Design System"
			, link  = event.buildAdminLink( linkTo="designSystem" )
		);

		event.addAdminBreadCrumb(
			  title = "Empty State"
			, link  = event.buildAdminLink( linkTo="designSystem.components.emptyState" )
		);

		event.setView( view = "admin/designSystem/components/emptyState" );
	}
}