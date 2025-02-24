<cfscript>
	body = args.body ?: "";
</cfscript>

<cfoutput>
	<cfif not isEmptyString( body )>
		#body#
	</cfif>
</cfoutput>