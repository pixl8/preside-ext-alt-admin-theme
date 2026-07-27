<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.id"           type="string" default="" />
<cfparam name="attributes.closeLabel"   type="string" default="" />
<cfparam name="attributes.title"        type="string" default="" />
<cfparam name="attributes.description"  type="string" default="" />
<cfparam name="attributes.image"        type="string" default="" />
<cfparam name="attributes.imageAlt"     type="string" default="" />
<cfparam name="attributes.buttonLabel"  type="string" default="" />
<cfparam name="attributes.buttonIcon"   type="string" default="plus" />
<cfparam name="attributes.buttonLink"   type="string" default="" />
<cfparam name="attributes.buttonTarget" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfif !Len( Trim( attributes.closeLabel ) )>
		<cfset attributes.closeLabel = _adminuiTranslateResource( uri="admin.components.imagePopup:close.label" ) />
	</cfif>

	<cfif !Len( Trim( attributes.id ) )>
		<cfthrow
			type    = "MissingArgument"
			message = "Missing required argument: id"
			detail  = "The 'id' parameter is required for this tag."
		>
	</cfif>
	<cfoutput>
		<dialog class="c-image-popup" id="#encodeForHtmlAttribute( attributes.id )#">
			<div class="c-image-popup__wrapper">
				<button class="c-image-popup__close" aria-label="#encodeForHtmlAttribute( attributes.closeLabel )#">
					<cf_adminui_icon name="x" class="c-image-popup__close-icon" />
				</button>
				<cfif Len( attributes.image )>
					<img class="c-image-popup__image" src="#encodeForHtmlAttribute( attributes.image )#" alt="#encodeForHtmlAttribute( attributes.imageAlt )#" />
				</cfif>
				<div class="c-image-popup__main">
					<cfif Len( attributes.title )>
						<div class="c-image-popup__title">
							#encodeForHTML( attributes.title )#
						</div>
					</cfif>
					<cfif Len( attributes.description )>
						<div class="c-image-popup__description">
							#encodeForHTML( attributes.description )#
						</div>
					</cfif>
					<cfif Len( attributes.buttonLabel ) && Len( attributes.buttonLink )>
						<div class="c-image-popup__button">
							<cf_adminui_button
								text="#attributes.buttonLabel#"
								href="#attributes.buttonLink#"
								target="#attributes.buttonTarget#"
								icon="#attributes.buttonIcon#"
							/>
						</div>
					</cfif>
				</div>
			</div>
		</dialog>
		<script type="module" nonce="#_adminuiGetRequestNonce()#">
			const popup       = document.querySelector("###encodeForJavaScript(attributes.id)#");
			const closeButton = document.querySelector("###encodeForJavaScript(attributes.id)# .c-image-popup__close");

			if (popup && closeButton) {
				closeButton.addEventListener( "click", () => {
					popup.close();
				} );
			}
		</script>
	</cfoutput>
</cfif>
