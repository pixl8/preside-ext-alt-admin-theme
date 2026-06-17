<cfparam name="attributes.class" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classNames = "c-grid";
		if ( Len( attributes.class ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>
	<cfoutput>
		<div class="#local.classNames#">
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>