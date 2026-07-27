<cfparam name="attributes.class" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classNames = "c-form";
		if ( Len( attributes.class ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>

	<cfset attribs = "" />
	<cfloop collection="#attributes#" item="key">
		<cfif key neq "class">
			<cfset attribs &= ' #lCase( key )#="#EncodeForHTMLAttribute( attributes[ key ] )#"' />
		</cfif>
	</cfloop>
	<cfoutput><form class="#local.classNames#"#attribs#></cfoutput>
</cfif>

<cfif thisTag.executionMode is "end">
	<cfoutput></form></cfoutput>
</cfif>
