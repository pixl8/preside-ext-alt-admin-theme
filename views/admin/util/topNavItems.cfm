<cfscript>
	menu       = args.menu ?: "";
	activeItem = args.activeItem ?: "";

	event.include( "/js/admin/specific/adminTopNav/" );

	// Overflow item, revealed and filled by the priority nav script
	moreItem = renderView( view="/admin/util/topNav/_item", args={
		  itemClass    = "js-priority-nav-more hide"
		, itemId       = "priorityNavMore"
		, itemIcon     = "fa-ellipsis-h"
		, itemTitle    = translateResource( uri="admin.topNav:more.title", defaultValue="More" )
		, forceSubMenu = true
	} );
</cfscript>

<cfoutput>
	<div id="topLevelNav" class="navbar-header pull-left btn-group mobile-nav" data-active-item="#activeItem#">
		<ul class="nav ace-nav">
			#menu#
			#moreItem#
		</ul>
	</div>
</cfoutput>
