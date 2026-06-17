component extends="coldbox.system.Interceptor" {

	property name="adminNavMenuCache"    inject="cachebox:adminMenuCache";
	property name="presideObjectService" inject="delayedInjector:PresideObjectService";

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

			var isHeaderLayout = getSetting( name="adminTheme.layout", defaultValue="sidebar" ) == "header";
			var isLoginLayout  = event.getCurrentLayout() == "adminLogin.cfm";

			if ( IsTrue( getSetting( name="adminTheme.features.modernComponents", defaultValue=false ) ) ) {
				if ( !isLoginLayout || isHeaderLayout ) {
					event.include( "/css/admin/altadmintheme-modern/" );
				}
			}

			if ( IsTrue( getSetting( name="adminTheme.features.modernDataTables", defaultValue=false ) ) ) {
				event.include( "/css/admin/altadmintheme-modern-data-tables/" );
			}

			for( var cssFile in cssFiles ) {
				event.include( cssFile, false );
			}
		}
	}

	public void function postExtraTopRightButtons( event, interceptData ) {
		if ( getSetting( name="adminTheme.layout", defaultValue="sidebar" ) != "header" ) {
			return;
		}

		event.setPrivateValue( "topRightButtonActions", Duplicate( interceptData.actions ?: [] ) );
		interceptData.actions.clear();
	}

	public void function postParseSelectFields( event, interceptData ) {
		if ( interceptData.objectName == "security_group" && interceptData.includeAllFormulaFields ) {
			// Prevent include formula fields view record error.
			ArrayDelete( interceptData.selectFields, "coalesce( group_concat( case when users.id = :userId then 1 else null end ), 0 ) as `is_assigned`" );
			ArrayDelete( interceptData.extraSelectFields, "coalesce( group_concat( case when users.id = :userId then 1 else null end ), 0 ) as `is_assigned`" );
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

	public void function onBuildLink( event, interceptData ) {
		// Workaround hardcoded cancel link in view.
		if ( ArrayContainsNoCase( [ "admin.usermanager.groups", "admin.notifications" ], ( interceptData.linkTo ?: "" )  )  ) {
			var operationSource = event.getAdminOperationSource();

			if ( operationSource == "adminManager" ) {
				var rc  = event.getCollection();

				if ( !isEmptyString( rc.user_id ?: "" ) ) {
					interceptData.queryString = "id=#rc.user_id#&tab=#ListLast( interceptData.linkTo, "." )#";
					interceptData.linkTo      = "admin.datamanager.security_user.viewRecord";
				}
			}
		}
	}

}