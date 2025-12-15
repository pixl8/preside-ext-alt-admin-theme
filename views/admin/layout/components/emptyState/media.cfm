<cfparam name="args.title"        type="string" default="" />
<cfparam name="args.description"  type="string" default="" />
<cfparam name="args.videoUrl"     type="string" default="" />
<cfparam name="args.videoNote"    type="string" default="" />
<cfparam name="args.buttonLabel"  type="string" default="" />
<cfparam name="args.buttonLink"   type="string" default="" />
<cfparam name="args.buttonIcon"   type="string" default="plus" />
<cfparam name="args.buttonTarget" type="string" default="" />

<cfoutput>
	<div class="c-empty-state-media">
		<div class="c-empty-state-media__container">
			<div class="c-empty-state-media__wrapper-one">
				<cfif Len( args.title )>
					<div class="c-empty-state-media__title">
						#encodeForHTML( args.title )#
					</div>
				</cfif>
				<cfif Len( args.description )>
					<div class="c-empty-state-media__description">
						#encodeForHTML( args.description )#
					</div>
				</cfif>
				<cfif Len( args.buttonLabel ) && Len( args.buttonLink )>
					<div class="c-empty-state-media__button">
						#renderViewlet(
								event = "admin.layout.components.button"
							, args  = {
									label  = args.buttonLabel
								, href   = args.buttonLink
								, target = args.buttonTarget
								, icon   = args.buttonIcon
							}
						)#
					</div>
				</cfif>
			</div>
			<div class="c-empty-state-media__wrapper-two">
				<cfif Len( args.videoUrl )>
					<div class="c-empty-state-media__video-wrapper">
						<iframe class="c-empty-state-media__video" allow="autoplay; fullscreen" allowfullscreen frameborder="0" src="#encodeForHtmlAttribute( args.videoUrl )#"></iframe>
					</div>
					<cfif Len( args.videoNote )>
						<div class="c-empty-state-media__video-note">
							#encodeForHTML( args.videoNote )#
						</div>
					</cfif>
				</cfif>
			</div>
		</div>
	</div>
</cfoutput>