<cfparam name="attributes.style"       type="string" default="" />
<cfparam name="attributes.title"       type="string" default="" />
<cfparam name="attributes.titleIcon"   type="string" default="" />
<cfparam name="attributes.description" type="string" default="" />
<cfparam name="attributes.actions"     type="array"  default="#[]#" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="c-card #(Len(attributes.style) ? 'c-card--style-#encodeForHTMLAttribute( attributes.style )#' : '')#">

			<cfif Len(attributes.title) || Len(attributes.titleIcon) || Len(attributes.description) || ArrayLen(attributes.actions)>
				<div class="c-card__header">
					<div class="c-card__header-wrapper-one">
						<cfif Len(attributes.title) && Len(attributes.description)>
							<div class="c-card__header-icon-title">
						</cfif>
								<cfif Len(attributes.titleIcon)>
									<cf_adminui_icon class="c-card__header-icon" name="#attributes.titleIcon#" strokeWidth="2" />
								</cfif>
								<cfif Len(attributes.title)>
									<span class="c-card__header-title">#encodeForHTML(attributes.title)#</span>
								</cfif>
							<cfif Len(attributes.title) && Len(attributes.description)>
								</div>
							</cfif>
							<cfif Len(attributes.description)>
								<span class="c-card__header-description">#encodeForHTML(attributes.description)#</span>
							</cfif>
					</div>
					<cfif ArrayLen(attributes.actions)>
						<div class="c-card__header-wrapper-two">
							<div class="c-card__header-actions">
								<cf_adminui_button_group>
									<cfloop array="#attributes.actions#" index="local.action">
										<cf_adminui_button
											type           = "#( local.action.type           ?: 'a' )#"
											style          = "icon"
											skin           = "#( local.action.skin           ?: 'bordered-neutral-20' )#"
											icon           = "#( local.action.icon           ?: '' )#"
											text           = "#( local.action.label          ?: '' )#"
											href           = "#( local.action.href           ?: '' )#"
											target         = "#( local.action.target         ?: '' )#"
											confirmTitle   = "#( local.action.confirmTitle   ?: '' )#"
											confirmMessage = "#( local.action.confirmMessage ?: '' )#"
										/>
									</cfloop>
								</cf_adminui_button_group>
							</div>
						</div>
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
