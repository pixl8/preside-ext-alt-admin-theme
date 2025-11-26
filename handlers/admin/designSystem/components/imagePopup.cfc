component extends="preside.system.base.AdminHandler" {
	function preHandler( event, rc, prc ) {
		super.preHandler( argumentCollection = arguments );
	}

	function index( event, rc, prc ) {
		prc.pageTitle = "Image Popup";

		event.addAdminBreadCrumb(
			title = "Design System"
			, link  = event.buildAdminLink( linkTo="designSystem" )
		);

		event.addAdminBreadCrumb(
			  title = "Image Popup"
			, link  = event.buildAdminLink( linkTo="designSystem/components/imagePopup" )
		);

		event.setView( view = "admin/designSystem/components/imagePopup" );
	}
}