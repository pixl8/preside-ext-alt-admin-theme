<cfparam name="attributes.type"           type="string"  default="a" />
<cfparam name="attributes.style"          type="string"  default="fill" />
<cfparam name="attributes.skin"           type="string"  default="primary" />
<cfparam name="attributes.size"           type="string"  default="" />
<cfparam name="attributes.display"        type="string"  default="inline" />
<cfparam name="attributes.text"           type="string"  default="" />
<cfparam name="attributes.icon"           type="string"  default="" />
<cfparam name="attributes.id"             type="string"  default="" />
<cfparam name="attributes.class"          type="string"  default="" />
<cfparam name="attributes.href"           type="string"  default="" />
<cfparam name="attributes.target"         type="string"  default="" />
<cfparam name="attributes.confirmTitle"   type="string"  default="" />
<cfparam name="attributes.confirmMessage" type="string"  default="" />
<cfparam name="attributes.confirmMatch"   type="string"  default="" />
<cfparam name="attributes.shortcutKey"    type="string"  default="" />
<cfparam name="attributes.popovertarget"  type="string"  default="" />
<cfparam name="attributes.textAlign"      type="string"  default="" />
<cfparam name="attributes.dropdown"       type="boolean" default="false" />
<cfparam name="attributes.attribs"        type="struct"  default="#StructNew()#" /><!--- passthrough html attributes, e.g. data-*, aria-* --->

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.baseClass  = "c-button-#encodeForHTMLAttribute( attributes.style )#";
		local.classNames = "#local.baseClass# #local.baseClass#--skin-#encodeForHTMLAttribute( attributes.skin )#";

		if ( Len( attributes.size ) ) {
			local.classNames &= " #local.baseClass#--size-#encodeForHTMLAttribute( attributes.size )#";
		}
		if (attributes.display is "block") {
			local.classNames &= " #local.baseClass#--display-block";
		}
		if ( Len( attributes.class ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
		if ( Len( attributes.textAlign ) ) {
			local.classNames &= " #local.baseClass#--text-align-#encodeForHTMLAttribute( attributes.textAlign )#";
		}
		if ( Len( attributes.confirmTitle ) ) {
			local.classNames &= " confirmation-prompt";
		}

		local.tagName = ListFindNoCase( "button,submit", attributes.type ) ? "button" : "a";

		local.extraAttribs = "";
		for ( local.attribName in attributes.attribs ) {
			if ( ReFindNoCase( "^[a-z][a-z0-9\-_:]*$", local.attribName ) ) {
				local.extraAttribs &= ' #local.attribName#="#EncodeForHTMLAttribute( attributes.attribs[ local.attribName ] )#"';
			}
		}
	</cfscript>

	<cfoutput>
		<#local.tagName#
			class="#local.classNames#"
			<cfif local.tagName is "button">type="#EncodeForHTMLAttribute( attributes.type )#"</cfif>
			<cfif Len( attributes.id )>id="#EncodeForHTMLAttribute( attributes.id )#"</cfif>
			<cfif Len( attributes.href )>href="#EncodeForHTMLAttribute( attributes.href )#"</cfif>
			<cfif Len( attributes.target )>target="#EncodeForHTMLAttribute( attributes.target )#"</cfif>
			<cfif Len( attributes.text ) && attributes.style == "icon">aria-label="#EncodeForHTMLAttribute( attributes.text )#"</cfif>
			<cfif Len( attributes.confirmTitle )>title="#EncodeForHTMLAttribute( attributes.confirmTitle )#"</cfif>
			<cfif Len( attributes.confirmMessage )>data-message="#EncodeForHTMLAttribute( attributes.confirmMessage )#"</cfif>
			<cfif Len( attributes.confirmMatch )>data-confirmation-match="#EncodeForHTMLAttribute( attributes.confirmMatch )#"</cfif>
			<cfif Len( attributes.shortcutKey )>data-global-key="#EncodeForHTMLAttribute( attributes.shortcutKey )#"</cfif>
			<cfif Len( attributes.popovertarget )>popovertarget="#EncodeForHTMLAttribute( attributes.popovertarget )#"</cfif>
			#local.extraAttribs#
		>
			<cfif Len(attributes.icon)>
				<cf_adminui_icon class="#local.baseClass#__icon" name="#attributes.icon#" />
			</cfif>
			<cfif Len(attributes.text) && attributes.style != "icon">
				#encodeForHTML(attributes.text)#
			</cfif>
			<cfif attributes.style == "icon" && Len( attributes.text )>
				<span class="#local.baseClass#__tooltip" aria-hidden="true">#encodeForHTML( attributes.text )#</span>
			</cfif>
			<cfif attributes.dropdown>
				<cf_adminui_icon class="#local.baseClass#__icon-toggle" name="chevron-down" />
			</cfif>
	</cfoutput>
</cfif>

<cfif thisTag.executionMode is "end">
	<cfoutput>
		</#local.tagName#>
	</cfoutput>
</cfif>