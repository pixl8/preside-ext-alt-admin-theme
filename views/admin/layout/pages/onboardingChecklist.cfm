<cfscript>
	event.include( "/css/admin/altadmintheme-v2/pages/onboarding-checklist/" );
</cfscript>

<cfparam name= "args.title"        default = "" />
<cfparam name= "args.description"  default = "" />
<cfparam name= "args.steps"        default = "#[]#" />
<cfparam name= "args.skipLinkText" default = "" />
<cfparam name= "args.skipLinkUrl"  default = "" />
<cfparam name= "args.noticeText"   default = "" />

<cfoutput>
	<div class="p-onboarding-checklist">
		<cfif Len( args.title ) || Len( args.description )>
			<div class="p-onboarding-checklist__header">
				<cfif Len( args.title )>
					<h1 class="p-onboarding-checklist__header-title">
						#encodeForHTML( args.title )#
					</h1>
				</cfif>
				<cfif Len( args.description )>
					<div class="p-onboarding-checklist__header-description">
						<p>
							#encodeForHTML( args.description )#
						</p>
					</div>
				</cfif>
			</div>
		</cfif>
		<cfif !ArrayIsEmpty( args.steps )>
			<div class="p-onboarding-checklist__body">
				<div class="p-onboarding-checklist__list">
					#renderViewlet(
						  event = "admin.layout.components.listSteps"
						, args  = {
								steps = args.steps
							}
					)#
				</div>
			</div>
		</cfif>
		<div class="p-onboarding-checklist__footer">
			<cfif Len( args.skipLinkUrl ) && Len( args.skipLinkText )>
				<div class="p-onboarding-checklist__skip">
					<a href="#encodeForHtmlAttribute( args.skipLinkUrl )#" class="p-onboarding-checklist__skip-link">#encodeForHTML( args.skipLinkText )#</a>
				</div>
			</cfif>
			<cfif Len( args.noticeText )>
				<div class="p-onboarding-checklist__notice">
					#encodeForHTML( args.noticeText )#
				</div>
			</cfif>
		</div>
	</div>
</cfoutput>