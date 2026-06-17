<cfscript>
	itemIcon  = args.icon  ?: "";
	itemLink  = args.link  ?: "";
	itemTitle = args.title ?: "";
	itemId    = args.id    ?: "";
	active    = IsTrue( args.active    ?: "" );
	separator = IsTrue( args.separator ?: "" );
</cfscript>

<cfoutput>
	<cfif separator>
		<li class="c-menu-app__subitem c-menu-app__subitem--separator" role="separator" aria-hidden="true"></li>
	<cfelseif Len( Trim( itemLink ) )>
		<li class="c-menu-app__subitem<cfif active> is-active</cfif>">
			<a class="c-menu-app__subitem-link" href="#itemLink#">
				#itemTitle#
			</a>
		</li>
	</cfif>
</cfoutput>
