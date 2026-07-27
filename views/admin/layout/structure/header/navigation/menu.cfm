<cfscript>
	menuItems = renderViewlet( event="admin.layout.mainNavigationItems" );
</cfscript>

<cfoutput>
	<nav class="c-menu-app">
		<ul class="c-menu-app__items">
			#menuItems#
		</ul>
	</nav>
</cfoutput>
