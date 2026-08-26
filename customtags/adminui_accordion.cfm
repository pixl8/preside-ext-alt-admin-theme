<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.title" type="string"  default="" />
<cfparam name="attributes.icon"  type="string"  default="" />
<cfparam name="attributes.open"  type="boolean" default="false" />

<cfif thisTag.executionMode is "start">
	<cfset _adminuiIncludeAsset( "/js/admin/specific/components/accordion/" ) />

	<cfoutput>
		<details class="c-accordion#( attributes.open ? ' is-open' : '' )#"#( attributes.open ? ' open' : '' )#>
			<summary class="c-accordion__header">
				<cfif Len( attributes.icon )>
					<cf_adminui_icon class="c-accordion__header-icon" name="#attributes.icon#" strokeWidth="2" />
				</cfif>
				<span class="c-accordion__header-title">#EncodeForHtml( attributes.title )#</span>
				<cf_adminui_icon class="c-accordion__header-chevron" name="chevron-down" strokeWidth="2" />
			</summary>
			<div class="c-accordion__body">
	</cfoutput>
<cfelse>
	<cfoutput>
			</div>
		</details>
	</cfoutput>
</cfif>
