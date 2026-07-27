<cfscript>
	itemIcon   = args.icon      ?: "";
	itemLink   = args.link      ?: "";
	itemTitle  = args.title     ?: "";
	itemId     = args.id        ?: "";
	subMenu    = args.subMenu   ?: "";
	active     = IsTrue( args.active    ?: "" );
	separator  = IsTrue( args.separator ?: "" );
	hasSubMenu = Len( Trim( subMenu ) );
</cfscript>

<cfoutput>
	<cfif separator>
		<li class="c-menu-app-mobile__item c-menu-app-mobile__item--separator" role="separator" aria-hidden="true"></li>
	<cfelseif hasSubMenu OR Len( Trim( itemLink ) )>
		<li class="c-menu-app-mobile__item<cfif active> is-active</cfif>" data-item-id="#EncodeForHtmlAttribute( itemId )#">
			<cfif hasSubMenu>
			<button class="c-menu-app-mobile__item-link" aria-expanded="false" aria-controls="menu-app-mobile-submenu-#EncodeForHtmlAttribute( itemId )#">
		<cfelse>
			<a href="#itemLink#" class="c-menu-app-mobile__item-link">
		</cfif>
				<cfif Len( Trim( itemIcon ) )>
					<cf_adminui_icon class="c-menu-app-mobile__item-icon" name="#itemIcon#" />
				</cfif>
				<span class="c-menu-app-mobile__item-label">
					#itemTitle#
				</span>
				<cfif hasSubMenu>
				<cf_adminui_icon class="c-menu-app-mobile__item-toggle" name="chevron-down" strokeWidth="2" />
			</button>
			<cfelse>
			</a>
			</cfif>
			<cfif hasSubMenu>
				<ul class="c-menu-app-mobile__submenu" id="menu-app-mobile-submenu-#EncodeForHtmlAttribute( itemId )#">
					#subMenu#
				</ul>
			</cfif>
		</li>
	</cfif>
</cfoutput>
