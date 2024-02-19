component extends="coldbox.system.Interceptor" {

// PUBLIC
	public void function configure() {}

	public void function preLayoutRender( event, interceptData ) {
		if( event.isAdminRequest() || event.isAdminUser() ) {
			if ( !event.isAdminRequest() ) {
				var prc = event.getCollection( private=true );
				prc.adminToolbarDisplayMode = prc.adminToolbarDisplayMode ?: getSystemSetting( "admin-users", "admin_toolbar_mode", "fixed" );
				if ( prc.adminToolbarDisplayMode == "none" ) {
					return;
				}
			}

			var cssFiles = getSetting( "admin.customCss" );

			event.include( "/css/admin/altadmintheme/" );
			if ( event.getCurrentLayout() == "adminLogin.cfm" ) {
				event.include( "/css/admin/altadmintheme/login/" );
			}

			for( var cssFile in cssFiles ) {
				event.include( cssFile, false );
			}
		}
	}
}