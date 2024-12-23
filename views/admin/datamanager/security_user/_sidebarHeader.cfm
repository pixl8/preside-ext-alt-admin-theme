<cfscript>
	status = isTrue( args.record.active ) ? "active" : "inactive";
</cfscript>

<cfoutput>

	<div>
		<span class="status-badge status-badge-#translateResource( uri="preside-objects.security_user:status.#status#.className" )#">
			<i class="fa fa-fw #translateResource( uri="preside-objects.security_user:status.#status#.iconClass" )#"></i>
			#translateResource( uri="preside-objects.security_user:status.#status#.label" )#
		</span>
	</div>

	<h2>#args.record.known_as#</h2>

	<p class="sidebar-meta">
		<i class="fa fa-fw fa-id-card"></i>
		<span>#args.record.login_id#</span>
	</p>

	<p class="sidebar-meta">
		<i class="fa fa-fw fa-envelope"></i>
		<a href="mailto:#args.record.email_address#">#args.record.email_address#</a>
	</p>

</cfoutput>