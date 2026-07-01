<cfparam name="attributes.name"             type="string"  default="" />
<cfparam name="attributes.type"             type="string"  default="text" />
<cfparam name="attributes.label"            type="string"  default="" />
<cfparam name="attributes.placeholder"      type="string"  default="" />
<cfparam name="attributes.description"      type="string"  default="" />
<cfparam name="attributes.value"            type="string"  default="" />
<cfparam name="attributes.id"              type="string"  default="" />
<cfparam name="attributes.icon"            type="string"  default="" />
<cfparam name="attributes.error"           type="string"  default="" />
<cfparam name="attributes.class"           type="string"  default="" />
<cfparam name="attributes.required"        type="boolean" default="false" />
<cfparam name="attributes.toggleVisibility" type="boolean" default="false" />
<cfparam name="attributes.autofocus"        type="boolean" default="false" />

<cfif thisTag.executionMode is "start">
	<cfif attributes.type is "hidden">
		<cfoutput><input type="hidden" name="#EncodeForHTMLAttribute( attributes.name )#" value="#EncodeForHTMLAttribute( attributes.value )#" /></cfoutput>
		<cfexit method="exittag" />
	</cfif>

	<cfscript>
		local.baseClass  = "c-form__field";
		local.classNames = local.baseClass;
		local.inputClass = "#local.baseClass#-input";
		local.inputId    = Len( attributes.id ) ? attributes.id : attributes.name;

		if ( Len( attributes.error ) ) {
			local.inputClass &= " #local.baseClass#-input--error";
		}
		if ( Len( attributes.class ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>

	<cfoutput>
		<div class="#local.classNames#">
			<cfif Len( attributes.label )>
				<label class="#local.baseClass#-label" for="#EncodeForHTMLAttribute( local.inputId )#">
					#EncodeForHTML( attributes.label )#
				</label>
			</cfif>
			<cfif Len( attributes.description )>
				<div class="#local.baseClass#-description">#EncodeForHTML( attributes.description )#</div>
			</cfif>
			<cfif Len( attributes.icon ) OR attributes.toggleVisibility>
				<div class="#local.baseClass#-input-wrapper">
			</cfif>
				<input
					class="#local.inputClass#"
					type="#EncodeForHTMLAttribute( attributes.type )#"
					name="#EncodeForHTMLAttribute( attributes.name )#"
					id="#EncodeForHTMLAttribute( local.inputId )#"
					<cfif Len( attributes.placeholder )>placeholder="#EncodeForHTMLAttribute( attributes.placeholder )#"</cfif>
					<cfif Len( attributes.value )>value="#EncodeForHTMLAttribute( attributes.value )#"</cfif>
					<cfif attributes.required>required</cfif>
					<cfif attributes.autofocus>autofocus</cfif>
				/>
				<cfif attributes.toggleVisibility>
					<button type="button" class="#local.baseClass#-input-toggle" data-target="###EncodeForHTMLAttribute( local.inputId )#" aria-label="Toggle visibility">
						<cf_adminui_icon name="eye" class="#local.baseClass#-input-toggle-icon #local.baseClass#-input-toggle-icon--on" strokeWidth="1.5" />
						<cf_adminui_icon name="eye-off" class="#local.baseClass#-input-toggle-icon #local.baseClass#-input-toggle-icon--off" strokeWidth="1.5" />
					</button>
				<cfelseif Len( attributes.icon )>
					<cf_adminui_icon name="#attributes.icon#" class="#local.baseClass#-input-icon" strokeWidth="1.5" />
				</cfif>
			<cfif Len( attributes.icon ) OR attributes.toggleVisibility>
				</div>
			</cfif>
			<cfif Len( attributes.error )>
				<div class="#local.baseClass#-error">#EncodeForHTML( attributes.error )#</div>
			</cfif>
			<cfif attributes.toggleVisibility>
				<script>
					( function() {
						var input = document.getElementById( '#encodeForJavaScript( local.inputId )#' );
						if ( !input ) return;

						var toggle = input.parentNode.querySelector( '.#local.baseClass#-input-toggle' );
						if ( !toggle ) return;

						var iconOn  = toggle.querySelector( '.#local.baseClass#-input-toggle-icon--on' );
						var iconOff = toggle.querySelector( '.#local.baseClass#-input-toggle-icon--off' );

						toggle.addEventListener( 'click', function() {
							var isHidden = input.type === 'password';
							input.type = isHidden ? 'text' : 'password';

							iconOn.style.display  = isHidden ? 'none' : 'block';
							iconOff.style.display = isHidden ? 'block' : 'none';
						} );
					} )();
				</script>
			</cfif>
		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>