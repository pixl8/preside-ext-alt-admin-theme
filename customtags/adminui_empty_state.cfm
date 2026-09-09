<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.title"        type="string"  default="" />
<cfparam name="attributes.description"  type="string"  default="" />
<cfparam name="attributes.allowHtml"    type="boolean" default="false" /><!--- description is HTML-encoded unless this is true (opt in for trusted HTML) --->
<cfparam name="attributes.image"        type="string"  default="" />
<cfparam name="attributes.imageUrl"     type="string"  default="" />
<cfparam name="attributes.buttonText"   type="string"  default="" />
<cfparam name="attributes.buttonLink"   type="string"  default="" />
<cfparam name="attributes.buttonIcon"   type="string"  default="" />
<cfparam name="attributes.buttonTarget" type="string"  default="_self" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="c-empty-state">

			<cfif Len( Trim( attributes.imageUrl ) )>
				<img class="c-empty-state__image" src="#encodeForHTMLAttribute( attributes.imageUrl )#" alt="" aria-hidden="true" />
			<cfelseif Len( Trim( attributes.image ) )>
				#_adminuiRenderEmptyStateIllustration( _adminuiResolveEmptyStateIllustration( attributes.image ) )#
			</cfif>

			<cfif Len( Trim( attributes.title ) )>
				<div class="c-empty-state__title">#encodeForHTML( attributes.title )#</div>
			</cfif>

			<cfif Len( Trim( attributes.description ) )>
				<div class="c-empty-state__description">#( attributes.allowHtml ? attributes.description : encodeForHTML( attributes.description ) )#</div>
			</cfif>

			<cfif Len( Trim( attributes.buttonText ) ) && Len( Trim( attributes.buttonLink ) )>
				<div class="c-empty-state__button">
					<cf_adminui_button
						icon   = "#attributes.buttonIcon#"
						text   = "#attributes.buttonText#"
						href   = "#attributes.buttonLink#"
						target = "#attributes.buttonTarget#"
					/>
				</div>
			</cfif>

		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
