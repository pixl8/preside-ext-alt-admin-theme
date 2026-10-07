<cfparam name="attributes.id" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<ol class="c-timeline"<cfif Len( Trim( attributes.id ) )> id="#encodeForHTMLAttribute( attributes.id )#"</cfif>>
	</cfoutput>
<cfelse>
	<cfoutput>
		</ol>
	</cfoutput>
</cfif>
