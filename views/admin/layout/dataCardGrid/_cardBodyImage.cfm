<cfscript>
	image       = args.image       ?: "";
	description = args.description ?: "";
</cfscript>

<cfoutput>
	<cfif not isEmptyString( image )>
		#image#
	</cfif>

	<cfif not isEmptyString( description )>
		<p>#description#</p>
	</cfif>
</cfoutput>