component extends="coldbox.system.Interceptor" {

	property name="adminNavMenuCache"    inject="cachebox:adminMenuCache";
	property name="presideObjectService" inject="delayedInjector:PresideObjectService";
	property name="adminThemeLayout"     inject="coldbox:setting:adminTheme.layout";
	property name="useV2Components"      inject="coldbox:setting:adminTheme.features.v2Components";
	property name="customCss"            inject="coldbox:setting:admin.customCss";

// PUBLIC
	public void function configure() {}

	public void function preViewRecord( event, interceptData ) {
		var prc = event.getCollection( private=true );

		if ( StructKeyExists( prc, "infoCardPlacement" ) ) {
			return;
		}

		var useSidebarInfoCard = adminThemeLayout == "v2" && IsTrue( useV2Components );

		prc.infoCardPlacement = useSidebarInfoCard ? "sidebar" : "inline";
	}

	public void function preLayoutRender( event, interceptData ) {
		if( event.isAdminRequest() || event.isAdminUser() ) {
			if ( !event.isAdminRequest() ) {
				var prc = event.getCollection( private=true );
				prc.adminToolbarDisplayMode = prc.adminToolbarDisplayMode ?: getSystemSetting( "frontend-editing", "admin_toolbar_mode", "fixed" );
				if ( prc.adminToolbarDisplayMode == "none" ) {
					return;
				}
			}

			event.include( "/css/admin/altadmintheme/" );
			if ( event.getCurrentLayout() == "adminLogin.cfm" ) {
				event.include( "/css/admin/altadmintheme/login/" );
			}

			var isV2Layout    = adminThemeLayout == "v2";
			var isLoginLayout = event.getCurrentLayout() == "adminLogin.cfm";

			if ( isV2Layout && isLoginLayout ) {
				var loginViews = "index,forgottenPassword,resetPassword,twoStep,firstTimeUserSetup";

				var loginView = ListLast( event.getCurrentView(), "/" );
				if ( !ListFindNoCase( loginViews, loginView ) ) {
					loginView = ListLast( event.getCurrentEvent(), "." );
				}

				if ( ListFindNoCase( loginViews, loginView ) ) {
					event.setView( "admin/login/v2/" & loginView );
				}
			}

			if ( isV2Layout ) {
				event.include( "/css/admin/altadmintheme-v2/" );
			} else if ( IsTrue( useV2Components ) && !isLoginLayout ) {
				event.include( "/css/admin/altadmintheme-v2-components/" );
			}

			if ( IsArray( customCss ) && ArrayLen( customCss ) ) {
				for( var cssFile in customCss ) {
					event.include( cssFile, false );
				}
			}
		}
	}

	public void function postExtraTopRightButtons( event, interceptData ) {
		if ( adminThemeLayout != "v2" ) {
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