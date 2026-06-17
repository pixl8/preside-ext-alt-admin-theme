component extends="preside.system.handlers.admin.Login" {

	public void function preHandler( event, action, eventArguments ) {
		super.preHandler( argumentCollection=arguments );

		if ( getSetting( name="adminTheme.layout", defaultValue="sidebar" ) != "header" ) {
			return;
		}

		if ( arguments.action == "index" ) {
			event.setView( "admin/login/header/index" );
		} else if ( arguments.action == "forgottenPassword" ) {
			event.setView( "admin/login/header/forgottenPassword" );
		}
	}

}
