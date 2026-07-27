<cfparam name="attributes.target"    type="string" />
<cfparam name="attributes.ariaLabel" type="string" default="" />
<cfparam name="attributes.class"     type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<button popovertarget="#encodeForHtmlAttribute( attributes.target )#"
		        type="button"
		        aria-haspopup="true"
		        aria-expanded="false"
		        aria-controls="#encodeForHtmlAttribute( attributes.target )#"
		        <cfif Len( attributes.ariaLabel )>aria-label="#encodeForHtmlAttribute( attributes.ariaLabel )#"</cfif>
		        <cfif Len( attributes.class )>class="#encodeForHtmlAttribute( attributes.class )#"</cfif>>
	</cfoutput>
</cfif>

<cfif thisTag.executionMode is "end">
	<cfoutput>
		</button>
	</cfoutput>
</cfif>
