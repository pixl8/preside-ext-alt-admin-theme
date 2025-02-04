<cfscript>
	title       = args.title       ?: "";
	description = args.description ?: "";
</cfscript>

<cfoutput>
	<cfif not isEmptyString( title )>
		<h2>#title#</h2>
	</cfif>

	<cfif not isEmptyString( description )>
		<p>#description#</p>
	</cfif>
</cfoutput>