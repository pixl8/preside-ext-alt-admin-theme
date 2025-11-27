<cfscript>
	event.include( "/css/admin/altadmintheme/components/image-popup/" );
</cfscript>

<cfparam name="args.id"           type="string" default="" />
<cfparam name="args.closeLabel"   type="string" default="Close" />
<cfparam name="args.title"        type="string" default="" />
<cfparam name="args.description"  type="string" default="" />
<cfparam name="args.image"        type="string" default="" />
<cfparam name="args.imageAlt"     type="string" default="" />
<cfparam name="args.buttonLabel"  type="string" default="" />
<cfparam name="args.buttonIcon"   type="string" default="plus" />
<cfparam name="args.buttonLink"   type="string" default="" />
<cfparam name="args.buttonTarget" type="string" default="" />

<cfoutput>
	<cfif !Len( Trim( args.id ) )>
		<cfthrow
			type    = "MissingArgument"
			message = "Missing required argument: id"
			detail  = "The 'id' parameter is required for this view."
		>
	</cfif>
	<dialog class="c-image-popup" id="#encodeForHtmlAttribute( args.id )#">
		<div class="c-image-popup__wrapper">
			<button class="c-image-popup__close" aria-label="#encodeForHtmlAttribute( args.closeLabel )#">
				#renderView(
					  view = "/admin/_components/icon"
					, args = {
						  icon      = "x"
						, className = "c-image-popup__close-icon"
					}
				)#
			</button>
			<cfif Len( args.image )>
				<img class="c-image-popup__image" src="#encodeForHtmlAttribute( args.image )#" alt="#encodeForHtmlAttribute( args.imageAlt )#" />
			</cfif>
			<div class="c-image-popup__main">
				<cfif Len( args.title )>
					<div class="c-image-popup__title">
						#args.title#
					</div>
				</cfif>
				<cfif Len( args.description )>
					<div class="c-image-popup__description">
						#args.description#
					</div>
				</cfif>
				<cfif Len( args.buttonLabel ) && Len( args.buttonLink )>
					<div class="c-image-popup__button">
						#renderView(
							  view = "/admin/_components/button"
							, args = {
								  label  = "#args.buttonLabel#"
								, href   = "#args.buttonLink#"
								, target = "#args.buttonTarget#"
								, icon   = "#args.buttonIcon#"
							}
						)#
					</div>
				</cfif>
			</div>
		</div>
	</dialog>
	<script type="module" nonce="#event?.getRequestNonce()#">
		const popup = document.querySelector( "###args.id#" );
		const closeButton = document.querySelector( "###args.id# .c-image-popup__close" );

		closeButton.addEventListener( "click", () => {
			popup.close();
		} );
	</script>
</cfoutput>
