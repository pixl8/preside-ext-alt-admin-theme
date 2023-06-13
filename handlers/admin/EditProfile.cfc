component extends="preside.system.handlers.admin.EditProfile" {

	private void function _setupEditProfileTabs( event, rc, prc ) {
		prc.adminSidebarHeader = prc.adminSidebarHeader ?: "";

		prc.adminSidebarHeader &= renderView( view="/admin/layout/adminSidebar/_header", args={
			user = userDao.selectData( id=event.getAdminUserId() )
		} );

		prc.adminSidebarItems  = prc.adminSidebarItems  ?: [];

		var currentEvent = event.getCurrentEvent();

		ArrayAppend( prc.adminSidebarItems, {
			  active = currentEvent == "admin.editProfile.index"
			, link   = event.buildAdminLink( "editProfile" )
			, title  = translateResource( uri="cms:editProfile.secondary.nav.title" )
			, icon   = "fa-user"
		} );

		ArrayAppend( prc.adminSidebarItems, {
			  active = currentEvent == "admin.editProfile.updatePassword"
			, link   = event.buildAdminLink( "editProfile.updatePassword" )
			, title  = translateResource( uri="cms:editProfile.password.secondary.nav.title" )
			, icon   = "fa-key"
		} );

		if ( loginService.isTwoFactorAuthenticationEnabled() ) {
			ArrayAppend( prc.adminSidebarItems, {
				  active = currentEvent == "admin.editProfile.twoFactorAuthentication"
				, link   = event.buildAdminLink( "editProfile.twofactorauthentication" )
				, title  = translateResource( uri="cms:editProfile.twoFactorAuthentication.secondary.nav.title" )
				, icon   = "fa-user-secret"
			} );
		}

		ArrayAppend( prc.adminSidebarItems, {
			  active = currentEvent == "admin.notifications.preferences"
			, link   = event.buildAdminLink( "notifications.preferences" )
			, title  = translateResource( uri="cms:notifications.preferences.tab.title" )
			, icon   = "fa-bell"
		} );
	}

}
