<!---
	Helper functions for adminui custom tags.

	Custom tags do not inherit Preside/ColdBox view helpers. Although caller may
	expose getSetting/translateResource (via FrameworkSupertype), those functions
	rely on variables.controller which is not available when invoked from a tag.
	Use request.cbController directly instead.
--->
<cffunction name="_adminuiGetSetting" access="public" returntype="any" output="false">
	<cfargument name="name"         type="string" required="true" />
	<cfargument name="defaultValue" type="any"    required="false" default="" />

	<cfscript>
		var value = _getController()?.getSetting( name=arguments.name, defaultValue=arguments.defaultValue );

		return local.value ?: arguments.defaultValue;
	</cfscript>
</cffunction>

<cffunction name="_adminuiTranslateResource" access="public" returntype="string" output="false">
	<cfargument name="uri"          type="string"  required="true" />
	<cfargument name="defaultValue" type="string"  required="false" default="" />
	<cfargument name="data"         type="array"   required="false" default="#[]#" />

	<cfscript>
		var value = _getController()?.getWireBox().getInstance( "i18n" ).translateResource( argumentCollection=arguments );

		return local.value ?: arguments.defaultValue;
	</cfscript>
</cffunction>

<cffunction name="_adminuiGetRequestNonce" access="public" returntype="string" output="false">
	<cfscript>
		var value = _getController()?.getRequestContext().getRequestNonce();

		return local.value ?: "";
	</cfscript>
</cffunction>

<cffunction name="_adminuiResolveEmptyStateIllustration" access="public" returntype="struct" output="false">
	<cfargument name="name" type="string" required="true" />

	<cfscript>
		var value = _getController()?.getWireBox().getInstance( "adminThemeEmptyStateIllustrationService" ).resolveIllustration( arguments.name );

		return local.value ?: { found=false, url="", filePath="" };
	</cfscript>
</cffunction>

<cffunction name="_adminuiRenderEmptyStateIllustration" access="public" returntype="string" output="false">
	<cfargument name="illustration" type="struct" required="true" />

	<cfscript>
		if ( Len( Trim( arguments.illustration.url ?: "" ) ) ) {
			return '<img class="c-empty-state__image" src="' & encodeForHTMLAttribute( arguments.illustration.url ) & '" alt="" aria-hidden="true" />';
		}

		var svgPath = arguments.illustration.filePath ?: "";

		if ( !Len( svgPath ) || !FileExists( svgPath ) ) {
			return "";
		}

		var svgContent = FileRead( svgPath );

		if ( findNoCase( "class=", svgContent ) ) {
			svgContent = REReplaceNoCase( svgContent, 'class="([^"]*)"', 'class="c-empty-state__image \1"', "one" );
		} else {
			svgContent = REReplaceNoCase( svgContent, "<svg([^>]*)>", '<svg class="c-empty-state__image" \1>', "one" );
		}

		if ( !findNoCase( "aria-hidden=", svgContent ) ) {
			svgContent = REReplaceNoCase( svgContent, "<svg\b", '<svg aria-hidden="true"', "one" );
		}

		return svgContent;
	</cfscript>
</cffunction>

<cffunction name="_getController" access="public" returntype="any" output="false">
	<cfscript>
		if ( StructKeyExists( application, "cbBootstrap" ) && IsDefined( 'application.cbBootstrap.getController' ) ) {
			return application.cbBootstrap.getController();
		}
	</cfscript>
</cffunction>
