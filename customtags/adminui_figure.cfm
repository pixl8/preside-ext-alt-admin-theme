<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.src"        type="string"  default="" />
<cfparam name="attributes.alt"        type="string"  default="" />
<cfparam name="attributes.zoom"       type="boolean" default="false" /><!--- zoom button that opens the image, at its own proportions, in a dialog --->
<cfparam name="attributes.zoomLabel"  type="string"  default="" />
<cfparam name="attributes.closeLabel" type="string"  default="" />
<cfparam name="attributes.id"         type="string"  default="" />
<cfparam name="attributes.class"      type="string"  default="" />

<!--- cf_adminui_figure_caption tags fill the left, center and right caption placeholders; other body content goes left --->
<cfif thisTag.executionMode is "end">
	<cfscript>
		local.captions = { left=[], center=[], right=[] };

		if ( Len( Trim( thisTag.generatedContent ) ) ) {
			ArrayAppend( local.captions.left, Trim( thisTag.generatedContent ) );
		}
		thisTag.generatedContent = "";

		for ( local.caption in ( thisTag.captions ?: [] ) ) {
			if ( Len( local.caption.content ) ) {
				ArrayAppend( local.captions[ StructKeyExists( local.captions, local.caption.position ) ? local.caption.position : "left" ], local.caption.content );
			}
		}

		local.hasCaption        = ArrayLen( local.captions.left ) || ArrayLen( local.captions.center ) || ArrayLen( local.captions.right );
		local.captionClassNames = "c-figure__caption" & ( ArrayLen( local.captions.center ) ? " c-figure__caption--has-center" : "" );
		local.classNames        = "c-figure" & ( Len( Trim( attributes.class ) ) ? " " & encodeForHTMLAttribute( attributes.class ) : "" );
		local.dialogId          = ( Len( Trim( attributes.id ) ) ? attributes.id : "c-figure-" & LCase( Replace( CreateUUID(), "-", "", "all" ) ) ) & "-zoom";

		if ( attributes.zoom ) {
			_adminuiIncludeAsset( "/js/admin/specific/components/figure/" );

			if ( !Len( Trim( attributes.zoomLabel ) ) ) {
				attributes.zoomLabel = _adminuiTranslateResource( uri="admin.components.figure:zoom.label" );
			}
			if ( !Len( Trim( attributes.closeLabel ) ) ) {
				attributes.closeLabel = _adminuiTranslateResource( uri="admin.components.figure:close.label" );
			}
		}
	</cfscript>

	<cfif Len( Trim( attributes.src ) )>
		<cfoutput>
			<figure class="#local.classNames#"<cfif Len( Trim( attributes.id ) )> id="#encodeForHTMLAttribute( attributes.id )#"</cfif>>
				<cfif attributes.zoom>
					<button type="button" class="c-figure__zoom" data-figure-zoom="#encodeForHTMLAttribute( local.dialogId )#" aria-haspopup="dialog" aria-label="#encodeForHTMLAttribute( attributes.zoomLabel )#">
						<img class="c-figure__image" src="#encodeForHTMLAttribute( attributes.src )#" alt="#encodeForHTMLAttribute( attributes.alt )#" />
						<span class="c-figure__zoom-icon">
							<cf_adminui_icon name="zoom-in" strokeWidth="2" />
						</span>
					</button>
				<cfelse>
					<img class="c-figure__image" src="#encodeForHTMLAttribute( attributes.src )#" alt="#encodeForHTMLAttribute( attributes.alt )#" />
				</cfif>

				<cfif local.hasCaption>
					<figcaption class="#local.captionClassNames#">
						<cfloop list="left,center,right" index="local.position">
							<cfif ArrayLen( local.captions[ local.position ] )>
								<div class="c-figure__caption-#local.position#">#ArrayToList( local.captions[ local.position ], " " )#</div>
							</cfif>
						</cfloop>
					</figcaption>
				</cfif>
			</figure>

			<cfif attributes.zoom>
				<dialog class="c-figure__dialog" id="#encodeForHTMLAttribute( local.dialogId )#">
					<button type="button" class="c-figure__dialog-close" aria-label="#encodeForHTMLAttribute( attributes.closeLabel )#">
						<cf_adminui_icon name="x" strokeWidth="2" />
					</button>
					<img class="c-figure__dialog-image" src="#encodeForHTMLAttribute( attributes.src )#" alt="#encodeForHTMLAttribute( attributes.alt )#" />
				</dialog>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>
