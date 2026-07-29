<cfscript>
	itemIcon   = args.icon    ?: "";
	itemLink   = args.link    ?: "";
	itemTitle  = args.title   ?: "";
	itemId     = args.id      ?: "";
	subMenu    = args.subMenu ?: "";
	active     = IsTrue( args.active    ?: "" );
	separator  = IsTrue( args.separator ?: "" );
	hasSubMenu = Len( Trim( subMenu ) );
</cfscript>

<cfoutput>
	<cfif separator>
		<li class="c-menu-app__item c-menu-app__item--separator" role="separator" aria-hidden="true"></li>
	<cfelseif hasSubMenu OR Len( Trim( itemLink ) )>
		<li class="c-menu-app__item<cfif active> is-active</cfif>">
			<cfif hasSubMenu>
				<button class="c-menu-app__item-link" popovertarget="menu-app-submenu-#EncodeForHtmlAttribute( itemId )#" style="anchor-name: --popover-anchor-menu-app-submenu-#EncodeForHtmlAttribute( itemId )#;">
			<cfelse>
				<a class="c-menu-app__item-link" href="#itemLink#">
			</cfif>
					<cfif Len( Trim( itemIcon ) )>
						<cf_adminui_icon class="c-menu-app__item-icon" name="#itemIcon#" />
					</cfif>
					<span class="c-menu-app__item-label">
						#itemTitle#
					</span>
			<cfif hasSubMenu>
					<cf_adminui_icon class="c-menu-app__item-toggle" name="chevron-down" strokeWidth="2" />
				</button>
			<cfelse>
				</a>
			</cfif>
			<cfif hasSubMenu>
				<ul class="c-menu-app__submenu" id="menu-app-submenu-#EncodeForHtmlAttribute( itemId )#" popover style="position-anchor: --popover-anchor-menu-app-submenu-#EncodeForHtmlAttribute( itemId )#;">
					#subMenu#
				</ul>
			</cfif>
		</li>
	</cfif>
</cfoutput>
