<cfscript>
	sidebarMenu     = args.sidebarMenu       ?: "";
	siderbarContext = args.siderbarContext   ?: "";
	header          = args.header            ?: "";
	footer          = args.footer            ?: "";
	headerClass     = prc.sidebarHeaderClass ?: "";
	footerClass     = prc.sidebarFooterClass ?: "";

	event.include( "/js/admin/specific/adminSidebar/" );
</cfscript>

<cfoutput>
	<div class="page-content-sidebar" data-cookie="#siderbarContext#" >
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

			<cfif Len( Trim( footer ) )>
				<footer class="#footerClass#">#footer#</footer>
			</cfif>
		</div>
	</div>
</cfoutput>