<cfparam name="attributes.text"      type="string" default="" />
<cfparam name="attributes.style"     type="string" default="bordered" />
<cfparam name="attributes.icon"      type="string" default="" />
<cfparam name="attributes.iconColor" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.baseClass  = "c-label";
		local.classNames = local.baseClass;

		if ( Len( attributes.style ) ) {
			local.classNames &= " #local.baseClass#--style-#encodeForHTMLAttribute( attributes.style )#";
		}

		if ( Len( attributes.iconColor ) ) {
			local.classNames &= " #local.baseClass#--icon-color-#encodeForHTMLAttribute( attributes.iconColor )#";
		}
	</cfscript>

	<cfoutput>
		<span class="#local.classNames#">
			<cfif Len( attributes.icon )>
				<cf_adminui_icon class="#local.baseClass#__icon" name="#attributes.icon#" strokeWidth="2" />
			</cfif>
			<cfif Len( attributes.text )>#encodeForHTML(attributes.text)#</cfif>
	</cfoutput>
</cfif>

<cfif thisTag.executionMode is "end">
	<cfoutput>
		</span>
	</cfoutput>
</cfif>