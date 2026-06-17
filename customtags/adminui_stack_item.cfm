<cfparam name="attributes.align" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classNames = "c-stack__item";

		if ( Len(Trim(attributes.align)) ) {
			local.classNames &= " c-stack__item--align-#encodeForHTMLAttribute(attributes.align)#";
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