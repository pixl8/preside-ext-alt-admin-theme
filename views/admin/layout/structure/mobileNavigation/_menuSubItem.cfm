<cfscript>
	itemIcon  = args.icon      ?: "";
	itemLink  = args.link      ?: "";
	itemTitle = args.title     ?: "";
	itemId    = args.id        ?: "";
	active    = IsTrue( args.active    ?: "" );
	separator = IsTrue( args.separator ?: "" );
</cfscript>

<cfoutput>
	<cfif separator>
		<li class="c-menu-app-mobile__subitem c-menu-app-mobile__subitem--separator" role="separator" aria-hidden="true"></li>
	<cfelseif Len( Trim( itemLink ) )>
		<li class="c-menu-app-mobile__subitem<cfif active> is-active</cfif>">
			<a href="#itemLink#" class="c-menu-app-mobile__subitem-link" data-item-id="#EncodeForHtmlAttribute( itemId )#">
				#itemTitle#
			</a>
		</li>
	</cfif>
</cfoutput>
