<cfscript>
	user = args.user ?: QueryNew( "" );
</cfscript>

<cfoutput>
	<h2>#( user.known_as ?: "" )#</h2>

	<p class="sidebar-meta">
		<i class="fa fa-fw fa-envelope"></i>
		#( user.email_address ?: "" )#
	</p>
</cfoutput>
