<cfscript>
	settingsMenu = renderViewlet( event="admin.layout.adminMenu", args={
		  menuItems        = getSetting( "admin.topNavItems" )
		, legacyViewBase   = "/admin/util/topNav/"
		, itemRenderer     = "/admin/util/topNav/_item"
		, subItemRenderer  = "/admin/layout/topnav/_subitem"
	} );
</cfscript>


<cfoutput>
	<cfif Len( Trim( settingsMenu ) )>
		<div id="topLevelNav" class="navbar-header pull-left btn-group mobile-nav">
			<ul class="nav ace-nav">
				#settingsMenu#
			</ul>
		</div>
	</cfif>
</cfoutput>