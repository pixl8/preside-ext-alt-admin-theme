<cfparam name="attributes.type" type="string" default="danger" />
<cfparam name="attributes.text" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.baseClass  = "c-alert";
		local.classNames = local.baseClass;

		if ( Len( attributes.type ) ) {
			local.classNames &= " #local.baseClass#--type-#encodeForHTMLAttribute( attributes.type )#";
		}

		local.iconMap = {
				"info"    : "info"
			, "success" : "circle-check"
			, "warning" : "triangle-alert"
			, "danger"  : "circle-alert"
		};

		local.iconName = local.iconMap[ attributes.type ] ?: "info";

		// Sanitize text: allow only <a> tags, strip all other HTML
		if ( Len( attributes.text ) ) {
			local.safeText = REReplaceNoCase( attributes.text, "<(?!/?a(?:\s[^>]*)?/?>)[^>]*>", "", "all" );
			local.safeText = REReplaceNoCase( local.safeText, "\son\w+\s*=\s*""[^""]*""", "", "all" );
			local.safeText = REReplaceNoCase( local.safeText, "href\s*=\s*""\s*javascript:", 'href="blocked:', "all" );
		}
	</cfscript>

	<cfoutput>
		<div class="#local.classNames#">
			<cf_adminui_icon class="#local.baseClass#__icon" name="#local.iconName#" strokeWidth="2" />
			<div class="#local.baseClass#__content">
				<cfif Len( attributes.text )>#local.safeText#</cfif>
	</cfoutput>
</cfif>

<cfif thisTag.executionMode is "end">
	<cfoutput>
			</div>
		</div>
	</cfoutput>
</cfif>