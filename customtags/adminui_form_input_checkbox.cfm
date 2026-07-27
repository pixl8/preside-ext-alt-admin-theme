<cfparam name="attributes.name"    type="string"  default="" />
<cfparam name="attributes.label"   type="string"  default="" />
<cfparam name="attributes.value"   type="string"  default="true" />
<cfparam name="attributes.checked" type="boolean" default="false" />
<cfparam name="attributes.id"      type="string"  default="" />
<cfparam name="attributes.class"   type="string"  default="" />
<cfparam name="attributes.skin"    type="string"  default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.baseClass  = "c-form__field";
		local.classNames = local.baseClass;
		local.inputId    = Len( attributes.id ) ? attributes.id : attributes.name;

		if ( Len( attributes.skin ) ) {
			local.classNames &= " #local.baseClass#--skin-#encodeForHTMLAttribute( attributes.skin )#";
		}
		if ( Len( attributes.class ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>

	<cfoutput>
		<div class="#local.classNames#">
			<div class="#local.baseClass#-checkbox">
				<input
					class="#local.baseClass#-checkbox-input"
					type="checkbox"
					name="#EncodeForHTMLAttribute( attributes.name )#"
					id="#EncodeForHTMLAttribute( local.inputId )#"
					value="#EncodeForHTMLAttribute( attributes.value )#"
					<cfif attributes.checked>checked</cfif>
				/>
				<label class="#local.baseClass#-checkbox-label" for="#EncodeForHTMLAttribute( local.inputId )#">#EncodeForHTML( attributes.label )#</label>
			</div>
		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
