<cfscript>
	addNewRecordLink  = args.addNewRecordLink  ?: "";
	addNewRecordIcon  = args.addNewRecordIcon  ?: "";
	addNewRecordLabel = args.addNewRecordLabel ?: "";
</cfscript>

<cfoutput>
	<a href="#addNewRecordLink#">
		<cfif !isEmptyString( addNewRecordIcon ) >
			<i class="fa fa-fw #addNewRecordIcon#"></i>
		</cfif>
		#addNewRecordLabel#
	</a>
</cfoutput>