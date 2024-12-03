<cfscript>
	menu = args.menu ?: "";
	activeItem = args.activeItem ?: "";

	if ( Len( activeItem ) ) {
		event.include( "/js/admin/specific/adminTopNav/" );
	}
</cfscript>


<cfoutput>
	<div id="topLevelNav" class="navbar-header pull-left btn-group mobile-nav" data-active-item="#activeItem#">
		<ul class="nav ace-nav">
			#menu#
		</ul>
	</div>
</cfoutput>