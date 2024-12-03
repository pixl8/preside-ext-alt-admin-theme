component extends="coldbox.system.Interceptor" {

	property name="adminNavMenuCache" inject="cachebox:adminMenuCache";

// PUBLIC
	public void function configure() {}

	public void function preLayoutRender( event, interceptData ) {
		if( event.isAdminRequest() || event.isAdminUser() ) {
			if ( !event.isAdminRequest() ) {
				var prc = event.getCollection( private=true );
				prc.adminToolbarDisplayMode = prc.adminToolbarDisplayMode ?: getSystemSetting( "frontend-editing", "admin_toolbar_mode", "fixed" );
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

	public void function postUpdateObjectData( event, interceptData ) {
		if ( ( arguments.interceptData.objectName == "security_user" && StructKeyExists( interceptData.data, "groups" ) ) || arguments.interceptData.objectName == "security_group" ) {
			adminNavMenuCache.clearAll();
		}
	}
	public void function postInsertObjectData( event, interceptData ) {
		if ( arguments.interceptData.objectName == "security_group" ) {
			adminNavMenuCache.clearAll();
		}
	}
	public void function postDeleteObjectData( event, interceptData ) {
		if ( arguments.interceptData.objectName == "security_group" ) {
			adminNavMenuCache.clearAll();
		}
	}
}