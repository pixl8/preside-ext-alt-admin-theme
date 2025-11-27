<cfoutput>
	<div class="c-empty-state-media">
		<div class="c-empty-state-media__container">
			<div class="c-empty-state-media__wrapper-one">
				<cfif Len( args.title )>
					<div class="c-empty-state-media__title">
						#args.title#
					</div>
				</cfif>
				<cfif Len( args.description )>
					<div class="c-empty-state-media__description">
						#args.description#
					</div>
				</cfif>
				<cfif Len( args.buttonLabel ) && Len( args.buttonLink )>
					<div class="c-empty-state-media__button">
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
			<div class="c-empty-state-media__wrapper-two">
				<cfif Len( args.videoUrl )>
					<div class="c-empty-state-media__video-wrapper">
						<iframe class="c-empty-state-media__video" allow="autoplay; fullscreen" allowfullscreen frameborder="0" src="#encodeForHtmlAttribute( args.videoUrl )#"></iframe>
					</div>
					<cfif Len( args.videoNote )>
						<div class="c-empty-state-media__video-note">
							#args.videoNote#
						</div>
					</cfif>
				</cfif>
			</div>
		</div>
	</div>
</cfoutput>