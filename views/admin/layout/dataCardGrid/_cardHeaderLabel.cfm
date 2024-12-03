<cfscript>
	icon  = args.icon  ?: "";
	label = args.label ?: "";
	link  = args.link  ?: "";
</cfscript>

<cfoutput>
	<cfif not isEmptyString( icon )>
		<i class="fa fa-fw #icon#"></i>
	</cfif>
	<cfif Len( link )>
		<a href="#link#">#label#</a>
	<cfelse>
		#label#
	</cfif>
</cfoutput>