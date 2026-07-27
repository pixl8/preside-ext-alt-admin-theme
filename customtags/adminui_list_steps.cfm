<cfparam name="attributes.steps" type="array" default="#[]#" />

<cfif thisTag.executionMode is "start">

	<cfoutput>
		<div class="c-list-steps">
			<div class="c-list-steps__list">
				<cfset i = 1>
				<cfloop array="#attributes.steps#" index="step">
					<div class="c-list-steps__item">
						<div class="c-list-steps__item-index">
							#i#
						</div>
						<div class="c-list-steps__item-content">
							<cfif structKeyExists( step, "title" ) && Len( step.title )>
								<div class="c-list-steps__item-title">
									#encodeForHTML( step.title )#
								</div>
							</cfif>
							<cfif structKeyExists( step, "description" ) && Len( step.description )>
								<div class="c-list-steps__item-description">
									#encodeForHTML( step.description )#
								</div>
							</cfif>
						</div>
						<div class="c-list-steps__item-actions">
							<cfif structKeyExists( step, "isCompleted" ) && step.isCompleted>
								<div class="c-list-steps__item-action c-list-steps__item-action--completed">
									<i class="c-list-steps__item-action-icon fa fa-check"></i>
								</div>
							<cfelseif structKeyExists( step, "link" ) && Len( step.link )>
								<a class="c-list-steps__item-action" href="#encodeForHtmlAttribute( step.link )#">
									<i class="c-list-steps__item-action-icon fa fa-chevron-right"></i>
								</a>
							</cfif>
						</div>
					</div>
					<cfset i++>
				</cfloop>
			</div>
		</div>
	</cfoutput>
</cfif>
