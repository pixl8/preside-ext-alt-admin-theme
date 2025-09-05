<cfscript>
	sidebarMenu = args.sidebarMenu ?: "";
	header      = args.header      ?: "";
	headerClass = prc.sidebarHeaderClass ?: "";

	event.include( "/js/admin/specific/adminSidebar/" );
</cfscript>

<cfoutput>
	<div class="page-content-sidebar">
		<div class="page-content-sidebar-toggle">
			<button class="js-toggle-admin-sidebar page-content-sidebar-toggle-btn" title="#translateResource( uri="admin.adminSidebar:collasibleToggle.title" )#" >
				<span class="icon-arrow">
					<i class="fa fa-chevron-left"></i>
				</span>
				<span class="icon-menu">
					<i class="fa fa-bars"></i>
				</span>
			</button>
		</div>

		<div class="page-content-sidebar-content">
			<cfif Len( Trim( header ) )>
				<header class="#headerClass#">#header#</header>
			</cfif>

			<nav>
				<ul>
					#sidebarMenu#
				</ul>
			</nav>
		</div>
	</div>
</cfoutput>