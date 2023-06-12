<cfscript>
	sidebarMenu = args.sidebarMenu ?: "";
	header      = args.header      ?: "";
	headerClass = prc.sidebarHeaderClass ?: "";

	event.include( "/js/admin/specific/adminSidebar/" );
</cfscript>

<cfoutput>
	<div class="page-content-sidebar">
		<cfif Len( Trim( header ) )>
			<header class="#headerClass#">#header#</header>
		</cfif>

		<nav>
			<ul>
				#sidebarMenu#
			</ul>
		</nav>
	</div>
</cfoutput>