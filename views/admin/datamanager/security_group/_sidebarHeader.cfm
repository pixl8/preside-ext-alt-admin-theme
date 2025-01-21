<cfoutput>

	<h2>#args.record.label#</h2>

	<cfif not isEmptyString( args.record.description ?: "" )>
		<p class="sidebar-meta">
			#args.record.description#
		</p>
	</cfif>

</cfoutput>