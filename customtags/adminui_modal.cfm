<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.id"          type="string"  default="" />
<cfparam name="attributes.title"       type="string"  default="" />
<cfparam name="attributes.description" type="string"  default="" />
<cfparam name="attributes.size"        type="string"  default="md" /><!--- sm | md | lg | xl | full --->
<cfparam name="attributes.fill"        type="boolean" default="false" /><!--- as tall as the screen allows --->
<cfparam name="attributes.flush"       type="boolean" default="false" /><!--- no padding or scrolling round the body --->
<cfparam name="attributes.open"        type="boolean" default="false" />
<cfparam name="attributes.closeLabel"  type="string"  default="" />
<cfparam name="attributes.class"       type="string"  default="" />

<cfif thisTag.executionMode is "start">
	<cfif !Len( Trim( attributes.id ) )>
		<cfthrow
			type    = "MissingArgument"
			message = "Missing required argument: id"
			detail  = "The 'id' parameter is required for this tag."
		>
	</cfif>

	<cfset _adminuiIncludeAsset( "/js/admin/specific/components/modal/" ) />
<cfelse>
	<cfscript>
		if ( !Len( Trim( attributes.closeLabel ) ) ) {
			attributes.closeLabel = _adminuiTranslateResource( uri="admin.components.modal:close.label" );
		}

		// the body is what's left once cf_adminui_modal_footer has taken its own content
		local.body    = thisTag.generatedContent;
		local.footers = thisTag.footers ?: [];
		thisTag.generatedContent = "";

		local.classNames = "c-modal c-modal--size-" & encodeForHTMLAttribute( attributes.size );

		if ( attributes.fill ) {
			local.classNames &= " c-modal--fill";
		}
		if ( attributes.flush ) {
			local.classNames &= " c-modal--flush";
		}
		if ( Len( Trim( attributes.class ) ) ) {
			local.classNames &= " " & encodeForHTMLAttribute( attributes.class );
		}
	</cfscript>

	<cfoutput>
		<dialog class="#local.classNames#" id="#encodeForHTMLAttribute( attributes.id )#" aria-modal="true"<cfif Len( attributes.title )> aria-labelledby="#encodeForHTMLAttribute( attributes.id )#-title"</cfif><cfif attributes.open> open</cfif>>
			<div class="c-modal__panel">
				<div class="c-modal__header">
					<cfif Len( attributes.title ) || Len( attributes.description )>
						<div class="c-modal__heading">
							<cfif Len( attributes.title )>
								<h2 class="c-modal__title" id="#encodeForHTMLAttribute( attributes.id )#-title">#encodeForHTML( attributes.title )#</h2>
							</cfif>
							<cfif Len( attributes.description )>
								<p class="c-modal__description">#encodeForHTML( attributes.description )#</p>
							</cfif>
						</div>
					</cfif>
					<button type="button" class="c-modal__close" data-modal-close aria-label="#encodeForHTMLAttribute( attributes.closeLabel )#">
						<cf_adminui_icon class="c-modal__close-icon" name="x" strokeWidth="2" />
					</button>
				</div>
				<div class="c-modal__body">#local.body#</div>
				<cfif ArrayLen( local.footers )>
					<div class="c-modal__footer"><cfloop array="#local.footers#" item="local.footer">#local.footer.content#</cfloop></div>
				</cfif>
			</div>
		</dialog>
	</cfoutput>
</cfif>
