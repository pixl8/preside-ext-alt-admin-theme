<cfscript>
	settingsMenu = renderViewlet( event="admin.layout.adminMenu", args={
		  menuItems       = getSetting( "adminConfigurationMenuItems" )
		, legacyViewBase  = "/admin/layout/configurationMenu/"
		, itemRenderer    = "/admin/layout/topnav/_subitem"
		, subItemRenderer = "/admin/layout/topnav/_subitem"
	} );
</cfscript>
<cfoutput>
	<cfif Len( Trim( settingsMenu ) )>
		<li>
			<a data-toggle="dropdown" href="##" class="dropdown-toggle">
				<i class="fa fa-wrench"></i>
				<i class="fa fa-caret-down"></i>
			</a>

			<ul class="dropdown-menu dropdown-yellow dropdown-close dropdown-menu-right">
				#settingsMenu#
			</ul>
		</li>
	</cfif>
</cfoutput>