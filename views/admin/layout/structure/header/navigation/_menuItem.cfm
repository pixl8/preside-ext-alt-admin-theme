<cfscript>
	itemIcon   = args.icon    ?: "";
	itemLink   = args.link    ?: "";
	itemTitle  = args.title   ?: "";
	itemId     = args.id      ?: "";
	subMenu    = args.subMenu ?: "";
	active     = IsTrue( args.active    ?: "" );
	separator  = IsTrue( args.separator ?: "" );
	hasSubMenu = Len( Trim( subMenu ) );

	popoverId  = "menu-app-submenu-" & LCase( Hash( itemId & CreateUniqueId() ) );
</cfscript>

<cfoutput>
	<cfif separator>
		<li class="c-menu-app__item is-separator" role="separator" aria-hidden="true"></li>
	<cfelseif hasSubMenu OR Len( Trim( itemLink ) )>
		<li class="c-menu-app__item<cfif active> is-active</cfif>">
			<cfif hasSubMenu>
				<button type="button" class="c-menu-app__item-link" popovertarget="#popoverId#" style="anchor-name: --popover-anchor-#popoverId#;">
			<cfelse>
				<a class="c-menu-app__item-link" href="#itemLink#">
			</cfif>
					<cfif Len( Trim( itemIcon ) )>
						<cf_adminui_icon class="c-menu-app__item-icon" name="#itemIcon#" />
					</cfif>
					<span class="c-menu-app__item-label">#itemTitle#</span>
					<cfif hasSubMenu>
						<cf_adminui_icon class="c-menu-app__item-toggle" name="chevron-down" strokeWidth="2" />
					</cfif>
			<cfif hasSubMenu>
				</button>
				<ul class="c-menu-app__submenu" id="#popoverId#" popover style="position-anchor: --popover-anchor-#popoverId#;">
					#subMenu#
				</ul>
			<cfelse>
				</a>
			</cfif>
		</li>
	</cfif>
</cfoutput>
