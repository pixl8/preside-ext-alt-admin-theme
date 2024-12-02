<cfscript>
	icon  = args.icon  ?: "";
	label = args.label ?: "";
</cfscript>

<cfoutput>
	<cfif not isEmptyString( icon )>
		<i class="fa fa-fw #icon#"></i>
	</cfif>

	#label#
</cfoutput>