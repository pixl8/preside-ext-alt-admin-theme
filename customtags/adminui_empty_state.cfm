<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.title"        type="string"  default="" />
<cfparam name="attributes.description"  type="string"  default="" />
<cfparam name="attributes.allowHtml"    type="boolean" default="false" /><!--- description is HTML-encoded unless this is true (opt in for trusted HTML) --->
<cfparam name="attributes.image"        type="string"  default="" />
<cfparam name="attributes.imageUrl"     type="string"  default="" />
<cfparam name="attributes.actions"      type="array"   default="#[]#" /><!--- buttons, each a struct of label, href, icon, style, skin, type, target, attribs --->

<!--- deprecated: shorthand for a single entry in actions, kept so existing callers keep working --->
<cfparam name="attributes.buttonText"   type="string"  default="" />
<cfparam name="attributes.buttonLink"   type="string"  default="" />
<cfparam name="attributes.buttonIcon"   type="string"  default="" />
<cfparam name="attributes.buttonTarget" type="string"  default="_self" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.actions = attributes.actions;

		if ( !ArrayLen( local.actions ) && Len( Trim( attributes.buttonText ) ) && Len( Trim( attributes.buttonLink ) ) ) {
			local.actions = [ {
				  label  = attributes.buttonText
				, href   = attributes.buttonLink
				, icon   = attributes.buttonIcon
				, target = attributes.buttonTarget
			} ];
		}
	</cfscript>

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

			<cfif ArrayLen( local.actions )>
				<div class="c-empty-state__actions">
					<cfloop array="#local.actions#" index="local.action">
						<cf_adminui_button
							type    = "#( local.action.type    ?: 'a'       )#"
							style   = "#( local.action.style   ?: 'fill'    )#"
							skin    = "#( local.action.skin    ?: 'primary' )#"
							icon    = "#( local.action.icon    ?: ''        )#"
							text    = "#( local.action.label   ?: ''        )#"
							href    = "#( local.action.href    ?: ''        )#"
							target  = "#( local.action.target  ?: ''        )#"
							attribs = "#( local.action.attribs ?: {}        )#"
						/>
					</cfloop>
				</div>
			</cfif>

		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
