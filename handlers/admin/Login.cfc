component extends="preside.system.handlers.admin.Login" {

	property name="adminThemeLayout" inject="coldbox:setting:adminTheme.layout";

	public void function preHandler( event, action, eventArguments ) {
		super.preHandler( argumentCollection=arguments );

		if ( adminThemeLayout != "header" ) {
			return;
		}

		if ( arguments.action == "index" ) {
			event.setView( "admin/login/header/index" );
		} else if ( arguments.action == "forgottenPassword" ) {
			event.setView( "admin/login/header/forgottenPassword" );
		}
	}

}
