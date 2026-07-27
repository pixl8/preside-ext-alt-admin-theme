<cfscript>
	event.include( "/js/admin/specific/components/menus/menuAppMobile/" );

	menu = renderViewlet( event="admin.layout.mobileMainNavigationItems" );
</cfscript>

<cfoutput>
	<nav class="c-menu-app-mobile">
		<ul class="c-menu-app-mobile__items">
			#menu#
		</ul>
	</nav>
</cfoutput>
