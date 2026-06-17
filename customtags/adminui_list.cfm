<cfparam name="attributes.items" type="array"  default="#[]#" />
<cfparam name="attributes.style" type="string" default="icon" />
<cfparam name="attributes.icon"  type="string" default="circle" />

<cfif thisTag.executionMode is "start">
	<cfif ArrayLen(attributes.items)>
		<cfset local.listClass = "c-list c-list--style-#encodeForHTMLAttribute( attributes.style )#">

		<cfoutput>
			<ul class="#local.listClass#">
				<cfloop array="#attributes.items#" index="item">
					<li class="c-list__item">
						<cfif attributes.style is "icon">
							<cf_adminui_icon name="#attributes.icon#" class="c-list__item-icon c-list__item-icon--icon-#encodeForHTMLAttribute( attributes.icon )#" />
						</cfif>

						#encodeForHTML( item )#
					</li>
				</cfloop>
			</ul>
		</cfoutput>
	</cfif>
</cfif>