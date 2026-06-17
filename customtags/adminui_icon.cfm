<cfinclude template="_adminuiHelpers.cfm" />

<cfparam name="attributes.name"        type="string"  default="" />
<cfparam name="attributes.class"       type="string"  default="c-icon" />
<cfparam name="attributes.strokeWidth" type="numeric" default="1.5" />
<cfparam name="attributes.ariaHidden"  type="string"  default="true" />

<cfif thisTag.executionMode is "start">
	<cfset local.iconName = attributes.name>

	<!--- Convert legacy FontAwesome icon names to Lucide equivalents --->
	<cfif left( local.iconName, 3 ) is "fa-">
		<cfset local.faMap = {
			  "fa-android": "bot"
			, "fa-bolt": "zap"
			, "fa-book": "book-open-check"
			, "fa-chart-line": "chart-line"
			, "fa-clock-o": "clock"
			, "fa-clone": "copy"
			, "fa-star": "star"
			, "fa-cloud-upload": "cloud-upload"
			, "fa-cogs": "settings"
			, "fa-comment": "message-square"
			, "fa-ellipsis-v": "ellipsis-vertical"
			, "fa-check-circle": "circle-check"
			, "fa-times-circle": "circle-x"
			, "fa-exclamation-circle": "circle-alert"
			, "fa-eye": "eye"
			, "fa-file-pdf": "file-text"
			, "fa-globe": "globe"
			, "fa-history": "history"
			, "fa-hourglass-half": "hourglass"
			, "fa-info-circle": "info"
			, "fa-lightbulb-o": "lightbulb"
			, "fa-map-signs": "signpost"
			, "fa-pencil": "pencil"
			, "fa-plus": "plus"
			, "fa-google-drive": "hard-drive"
			, "fa-vimeo": "video"
			, "fa-lock": "lock"
			, "fa-sign-in": "log-in"
			, "fa-sign-out": "log-out"
			, "fa-sliders": "sliders-horizontal"
			, "fa-shield": "shield-check"
			, "fa-sitemap": "list-tree"
			, "fa-user-shield": "shield-user"
			, "fa-refresh": "refresh-cw"
			, "fa-refresh-cw": "refresh-cw"
			, "fa-tachometer": "gauge"
			, "fa-trash": "trash"
			, "fa-trash-o": "trash"
			, "fa-trash red": "trash"
			, "fa-user-tie": "user"
			, "fa-user-times": "user-x"
			, "fa-user": "user"
			, "fa-check": "check"
			, "fa-times": "x"
			, "fa-clock": "clock"
			, "fa-spinner": "loader-circle"
			, "fa-pause": "pause"
			, "fa-exclamation-triangle": "triangle-alert"
		}>
		<cfset local.iconName = local.faMap[ local.iconName ] ?: local.iconName>
	</cfif>

	<cfif NOT reFindNoCase('^[a-zA-Z0-9\-_]+$', local.iconName)>
		<cfoutput></cfoutput>
		<cfexit method="exitTag">
	</cfif>

	<cfset local.iconBasePath = _adminuiGetSetting( name="adminTheme.iconBasePath", defaultValue="/application/extensions/preside-ext-alt-admin-theme/assets/icons/adminui" )>
	<cfset local.path = expandPath( local.iconBasePath & "/" & local.iconName & ".svg" )>

	<cfif !fileExists( local.path )>
		<cfoutput></cfoutput>
		<cfexit method="exitTag">
	</cfif>

	<cfset local.svg           = fileRead( local.path )>
	<cfset local.safeClassName = trim(encodeForHTMLAttribute(attributes.class))>

	<!--- Replace / inject class attribute --->
	<cfif findNoCase( "class=", local.svg )>
		<cfset local.svg = reReplaceNoCase(
				local.svg
			, 'class="([^"]*)"'
			, 'class="#local.safeClassName# \1"'
			, "one"
		)>
	<cfelse>
		<cfset local.svg = reReplaceNoCase(
				local.svg
			, '^(<svg\b)([^>]*)(>)'
			, '\1\2 class="#local.safeClassName#"\3'
			, "one"
		)>
	</cfif>

	<!--- Inject aria-hidden attribute if provided --->
	<cfif Len( Trim( attributes.ariaHidden ) )>
		<cfset local.svg = reReplaceNoCase(
				local.svg
			, '^(<svg\b)([^>]*)(>)'
			, '\1\2 aria-hidden="#encodeForHTMLAttribute( trim( attributes.ariaHidden ) )#"\3'
			, "one"
		)>
	</cfif>

	<!--- Override stroke-width attribute --->
	<cfset local.svg = reReplaceNoCase( local.svg, '\bstroke-width="[^"]*"', 'stroke-width="#encodeForHTMLAttribute( attributes.strokeWidth )#"', "one" )>

	<cfoutput>#local.svg#</cfoutput>
</cfif>