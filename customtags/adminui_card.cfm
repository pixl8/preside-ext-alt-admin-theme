<cfparam name="attributes.style"     type="string" default="" />
<cfparam name="attributes.title"     type="string" default="" />
<cfparam name="attributes.titleIcon" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="c-card #(Len(attributes.style) ? 'c-card--style-#encodeForHTMLAttribute( attributes.style )#' : '')#">

			<cfif Len(attributes.title) || Len(attributes.titleIcon)>
				<div class="c-card__header">
					<cfif Len(attributes.titleIcon)>
						<cf_adminui_icon class="c-card__header-icon" name="#attributes.titleIcon#" strokeWidth="2" />
					</cfif>
					<cfif Len(attributes.title)>
						<span class="c-card__header-title">#encodeForHTML(attributes.title)#</span>
					</cfif>
				</div>
			</cfif>

			<div class="c-card__body">
	</cfoutput>
</cfif>

<cfif thisTag.executionMode is "end">
	<cfoutput>
			</div>
		</div>
	</cfoutput>
</cfif>