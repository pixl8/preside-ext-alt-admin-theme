<cfscript>
	event.include( "/css/admin/altadmintheme/components/list-steps/" );
</cfscript>

<cfparam name="args.steps" default="#[]#">

<cfoutput>
	<div class="c-list-steps">
		<div class="c-list-steps__list">
			<cfset i = 1>
			<cfloop array="#args.steps#" index="step">
				<div class="c-list-steps__item">
					<div class="c-list-steps__item-index">
						#i#
					</div>
					<div class="c-list-steps__item-content">
						<div class="c-list-steps__item-title">
							#step.title#
						</div>
						<div class="c-list-steps__item-description">
							#step.description#
						</div>
					</div>
					<div class="c-list-steps__item-actions">
						<cfif step.isCompleted>
							<div class="c-list-steps__item-action c-list-steps__item-action--completed">
								<i class="c-list-steps__item-action-icon fa fa-check"></i>
							</div>
						<cfelse>
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
