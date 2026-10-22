<cfscript>
	event.include( "/js/admin/specific/components/menus/menuApp/" );

	menuItems = renderViewlet( event="admin.layout.mainNavigationItems" );

	moreTitle = translateResource( uri="admin.topNav:more.title", defaultValue="More" );
	moreId    = "menu-app-more-" & LCase( Hash( CreateUniqueId() ) );
</cfscript>

<cfoutput>
	<nav class="c-menu-app" data-menu-app-priority-nav>
		<ul class="c-menu-app__items">
			#menuItems#

			<li class="c-menu-app__item is-hidden js-menu-app-more">
				<button type="button" class="c-menu-app__item-link" popovertarget="#moreId#" style="anchor-name: --popover-anchor-#moreId#;">
					<cf_adminui_icon class="c-menu-app__item-icon" name="ellipsis-vertical" />
					<span class="c-menu-app__item-label">#moreTitle#</span>
					<cf_adminui_icon class="c-menu-app__item-toggle" name="chevron-down" strokeWidth="2" />
				</button>
				<ul class="c-menu-app__submenu c-menu-app__more-menu" id="#moreId#" popover style="position-anchor: --popover-anchor-#moreId#;"></ul>
			</li>
		</ul>
	</nav>
</cfoutput>
