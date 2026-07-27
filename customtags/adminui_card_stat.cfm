<cfparam name="attributes.style"          type="string" default="bordered" />
<cfparam name="attributes.title"          type="string" default="" />
<cfparam name="attributes.value"          type="string" default="0" />
<cfparam name="attributes.trendValue"     type="string" default="" />
<cfparam name="attributes.trendLabel"     type="string" default="" />
<cfparam name="attributes.trendDirection" type="string" default="neutral" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.iconName      = "arrow-narrow-right";
		local.trendModifier = "neutral";

		switch( attributes.trendDirection ) {
			case "increase":
				local.iconName      = "trending-up";
				local.trendModifier = "increase";
				break;
			case "decrease":
				local.iconName      = "trending-down";
				local.trendModifier = "decrease";
				break;
			default:
				local.iconName      = "arrow-narrow-right";
				local.trendModifier = "neutral";
				break;
		}
	</cfscript>

	<cfoutput>
		<div class="c-card-stat c-card-stat--style-#encodeForHTMLAttribute(attributes.style)#">

			<cfif Len(attributes.title)>
				<div class="c-card-stat__header">
					<span class="c-card-stat__header-title">#encodeForHTML(attributes.title)#</span>
				</div>
			</cfif>

			<div class="c-card-stat__body">
				<div class="c-card-stat__value">#encodeForHTML(attributes.value)#</div>
			</div>

			<cfif Len(attributes.trendValue) || Len(attributes.trendLabel)>
				<div class="c-card-stat__footer">
					<div class="c-card-stat__trend">

						<cfif Len(attributes.trendValue)>
							<div class="c-card-stat__trend-badge c-card-stat__trend-badge--#local.trendModifier#">
								<cf_adminui_icon class="c-card-stat__trend-badge-icon" name="#local.iconName#" />
								<span class="c-card-stat__trend-badge-value">#encodeForHTML(attributes.trendValue)#</span>
							</div>
						</cfif>

						<cfif Len(attributes.trendLabel)>
							<div class="c-card-stat__trend-label">#encodeForHTML(attributes.trendLabel)#</div>
						</cfif>

					</div>
				</div>
			</cfif>

		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>