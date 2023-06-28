component extends="coldbox.system.Interceptor" {

// PUBLIC
	public void function configure() {}

	public void function preLayoutRender( event, interceptData ) {
		if( event.isAdminRequest() || event.isAdminUser() ) {
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

	public void function postLayoutRender( event, interceptData={} ) {

		if ( event.getCurrentLayout() == "adminLogin.cfm" ) {
			var bgVideo = getSystemSetting( "admin-login-security", "video_background" );

			var adminLoginContent = Trim( renderView( view="/admin/general/adminLoginContent", args={ bgVideo = bgVideo } ) );
			interceptData.renderedLayout = reReplaceNoCase( interceptData.renderedLayout ?: "", "<head(.*?)>", "<head\1>#chr(10)##adminLoginContent#" );

		}

	}

}