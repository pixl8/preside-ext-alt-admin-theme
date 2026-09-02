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

<cffunction name="_adminuiRenderIcon" access="public" returntype="string" output="false">
	<cfargument name="name"        type="string" required="true" />
	<cfargument name="class"       type="string" required="false" default="c-icon" />
	<cfargument name="strokeWidth" type="any"    required="false" default="" />
	<cfargument name="ariaHidden"  type="string" required="false" default="" />

	<cfscript>
		var value = _getController()?.getWireBox().getInstance( "adminThemeIconService" ).renderIcon( argumentCollection=arguments );

		return local.value ?: "";
	</cfscript>
</cffunction>

<cffunction name="_adminuiPaginationControl" access="public" returntype="string" output="false">
	<cfargument name="direction" type="string" required="true" /><!--- prev | next --->
	<cfargument name="href"      type="string" required="false" default="" />
	<cfargument name="text"      type="string" required="false" default="" />

	<cfscript>
		var icon     = arguments.direction == "prev" ? "chevron-left" : "chevron-right";
		var baseCls  = "c-pagination__control c-pagination__control--" & arguments.direction;
		var iconHtml = _adminuiRenderIcon( name=icon, class="c-pagination__control-icon", strokeWidth=2 );
		var textHtml = Len( arguments.text ) ? '<span class="c-pagination__control-text">' & encodeForHTML( arguments.text ) & '</span>' : "";
		var inner    = arguments.direction == "prev" ? iconHtml & textHtml : textHtml & iconHtml;

		if ( Len( Trim( arguments.href ) ) ) {
			return '<a class="' & baseCls & '" href="' & encodeForHTMLAttribute( arguments.href ) & '">' & inner & '</a>';
		}

		return '<span class="' & baseCls & ' is-disabled" aria-disabled="true">' & inner & '</span>';
	</cfscript>
</cffunction>

<cffunction name="_adminuiPaginationPages" access="public" returntype="array" output="false">
	<cfargument name="page"      type="numeric" required="true" />
	<cfargument name="pageCount" type="numeric" required="true" />
	<cfargument name="maxLinks"  type="numeric" required="false" default="7" />

	<cfscript>
		var pages = [];
		var total = Int( arguments.pageCount );
		var cur   = Max( 1, Min( Int( arguments.page ), Max( total, 1 ) ) );
		var cap   = Max( 5, Int( arguments.maxLinks ) );

		if ( total <= cap ) {
			for ( var i=1; i<=total; i++ ) { ArrayAppend( pages, i ); }
			return pages;
		}

		var side  = Int( ( cap - 3 ) / 2 );
		var left  = Max( 2, cur - side );
		var right = Min( total - 1, cur + side );

		ArrayAppend( pages, 1 );
		if ( left > 2 ) { ArrayAppend( pages, "..." ); }
		for ( var i=left; i<=right; i++ ) { ArrayAppend( pages, i ); }
		if ( right < ( total - 1 ) ) { ArrayAppend( pages, "..." ); }
		ArrayAppend( pages, total );

		return pages;
	</cfscript>
</cffunction>

<cffunction name="_adminuiIncludeAsset" access="public" returntype="void" output="false">
	<cfargument name="assetId" type="string" required="true" />

	<cfscript>
		_getController()?.getRequestContext()?.include( assetId=arguments.assetId, throwOnMissing=false );
	</cfscript>
</cffunction>

<cffunction name="_getController" access="public" returntype="any" output="false">
	<cfscript>
		if ( StructKeyExists( application, "cbBootstrap" ) && IsDefined( 'application.cbBootstrap.getController' ) ) {
			return application.cbBootstrap.getController();
		}
	</cfscript>
</cffunction>
