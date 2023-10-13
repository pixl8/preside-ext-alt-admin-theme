component {

	public string function backgroundVideo( event, rc, prc, args={} ) {
		var bgVideo = getSystemSetting( "admin-login-security", "video_background" );

		return renderView( view="/admin/general/adminLoginContent", args={ bgVideo = bgVideo } );
	}
}
