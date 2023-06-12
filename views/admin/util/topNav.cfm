<cfscript>
	topLevelNav       = renderView( view="/admin/util/topNavItems" );
	userMenu          = renderView( view="/admin/util/userMenu", cache=true, cacheSuffix=event.getAdminUserId() );
	applicationNav    = renderViewlet( event="admin.layout.applicationNav", cache=true, cacheSuffix=event.getAdminUserId() );
	systemMenu        = renderView( view="/admin/util/topnav/system", cache=true, cacheSuffix=event.getAdminUserId() );
	notificationsMenu = renderViewlet( "admin.notifications.notificationNavPromo" );
	systemAlertsMenu  = renderViewlet( "admin.systemAlerts.systemAlertsMenuItem" );
	sitePicker        = isFeatureEnabled( "siteSwitcher" ) ? renderViewlet( "admin.sites.sitePicker" ) : "";

	if ( isFeatureEnabled( "launcherExtension" ) ) {
		launcher = renderViewlet( event="admin.layout.launcher" );
		event.include( "/js/admin/specific/launcher/" )
	         .include( "/css/admin/specific/launcher/" );
	} else {
		launcher = "";
	}

	if ( isFeatureEnabled( "contentDependencyTracker" ) ) {
		dependencyTrackerLink = renderViewlet( event="admin.dependencyTracker.linkToTracker", cache=false );
	} else {
		dependencyTrackerLink = "";
	}
</cfscript>

<cfoutput>
	<div class="navbar navbar-default" id="navbar">
		<script type="text/javascript">
			try{ace.settings.check( 'navbar', 'fixed' );}catch(e){}
		</script>

		<div class="navbar-container" id="navbar-container">
			#applicationNav#
			#launcher#
			#sitePicker#
			#topLevelNav#

			<div class="navbar-header pull-right mobile-trigger" role="navigation">
				<ul class="nav ace-nav">
					<li class="hidden-lg">
						<a data-toggle="collapse" href="##topLevelNav" class="dropdown-toggle">
							<i class="fa fa-bars"></i>
						</a>
					</li>
					#dependencyTrackerLink#
					#systemMenu#
					#systemAlertsMenu#
					#notificationsMenu#
					<li>#userMenu#</li>
				</ul>
			</div>
		</div>
	</div>
</cfoutput>