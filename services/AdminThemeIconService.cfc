/**
 * @presideService true
 * @singleton      true
 */
component {

	property name="iconBasePath" inject="coldbox:setting:adminTheme.iconBasePath";
	property name="icons"        inject="coldbox:setting:adminTheme.icons";

	public function init() {
		return this;
	}

	public string function renderIcon(
		  required string name
		,          string class       = "c-icon"
		,          string strokeWidth = ""
		,          string ariaHidden  = ""
	) {
		var cacheKey    = _renderCacheKey( argumentCollection=arguments );
		var renderCache = _getRenderCache();

		if ( StructKeyExists( renderCache, cacheKey ) ) {
			return renderCache[ cacheKey ];
		}

		var icon       = resolveIcon( arguments.name );
		var svgContent = _readSvg( icon );
		var rendered   = "";

		if ( Len( svgContent ) ) {
			rendered = _applySvgAttributes(
				  svg         = svgContent
				, class       = arguments.class
				, strokeWidth = arguments.strokeWidth
				, ariaHidden  = arguments.ariaHidden
			);
		}

		renderCache[ cacheKey ] = rendered;

		return rendered;
	}

	public struct function resolveIcon( required string name ) {
		var requestedName = Trim( arguments.name );
		var resolveCache  = _getResolveCache();

		if ( StructKeyExists( resolveCache, requestedName ) ) {
			return resolveCache[ requestedName ];
		}

		var result = _resolveIcon( requestedName );
		resolveCache[ requestedName ] = result;

		return result;
	}

	public void function clearCache() {
		StructDelete( variables, "_resolveCache" );
		StructDelete( variables, "_svgContentCache" );
		StructDelete( variables, "_renderCache" );
	}

	private string function _readSvg( required struct icon ) {
		if ( !( arguments.icon.found ?: false ) ) {
			return "";
		}

		var cacheKey = arguments.icon.filePath ?: "";
		var svgCache = _getSvgContentCache();

		if ( Len( cacheKey ) && StructKeyExists( svgCache, cacheKey ) ) {
			return svgCache[ cacheKey ];
		}

		var filePath = arguments.icon.filePath ?: "";

		if ( !Len( filePath ) || !FileExists( filePath ) ) {
			return "";
		}

		var svgContent = FileRead( filePath );

		if ( Len( cacheKey ) ) {
			svgCache[ cacheKey ] = svgContent;
		}

		return svgContent;
	}

	private string function _applySvgAttributes(
		  required string svg
		,          string class       = "c-icon"
		,          string strokeWidth = ""
		,          string ariaHidden  = ""
	) {
		var svgContent    = arguments.svg;
		var safeClassName = Trim( EncodeForHTMLAttribute( arguments.class ) );

		if ( FindNoCase( "class=", svgContent ) ) {
			svgContent = REReplaceNoCase(
				  svgContent
				, 'class="([^"]*)"'
				, 'class="#safeClassName# \1"'
				, "one"
			);
		} else {
			svgContent = REReplaceNoCase(
				  svgContent
				, '^(<svg\b)([^>]*)(>)'
				, '\1\2 class="#safeClassName#"\3'
				, "one"
			);
		}

		if ( Len( Trim( arguments.ariaHidden ) ) ) {
			svgContent = REReplaceNoCase(
				  svgContent
				, '^(<svg\b)([^>]*)(>)'
				, '\1\2 aria-hidden="#EncodeForHTMLAttribute( Trim( arguments.ariaHidden ) )#"\3'
				, "one"
			);
		}

		if ( Len( Trim( arguments.strokeWidth ) ) ) {
			svgContent = REReplaceNoCase(
				  svgContent
				, '\bstroke-width="[^"]*"'
				, 'stroke-width="#EncodeForHTMLAttribute( arguments.strokeWidth )#"'
				, "one"
			);
		}

		return svgContent;
	}

	private string function _renderCacheKey(
		  required string name
		,          string class       = "c-icon"
		,          string strokeWidth = ""
		,          string ariaHidden  = ""
	) {
		return Trim( arguments.name )
			& chr( 1 ) & Trim( arguments.class )
			& chr( 1 ) & Trim( arguments.strokeWidth )
			& chr( 1 ) & Trim( arguments.ariaHidden );
	}

	private struct function _resolveIcon( required string requestedName ) {
		if ( !Len( arguments.requestedName ) ) {
			return _notFoundResult();
		}

		var mapping  = _getIconMapping( arguments.requestedName );
		var filePath = Trim( mapping.path ?: "" );
		var iconName = "";

		if ( Len( filePath ) ) {
			iconName = ListFirst( ListLast( Replace( filePath, "\", "/", "all" ), "/" ), "." );
		} else {
			if ( !REFindNoCase( "^[a-zA-Z0-9\-_]+$", arguments.requestedName ) ) {
				return _notFoundResult();
			}

			iconName = arguments.requestedName;
			filePath = ( iconBasePath ?: "" ) & "/" & iconName & ".svg";
		}

		if ( !Len( filePath ) ) {
			return _notFoundResult();
		}

		filePath = ExpandPath( filePath );

		if ( !FileExists( filePath ) ) {
			return _notFoundResult();
		}

		return {
			  found    = true
			, name     = iconName
			, filePath = filePath
		};
	}

	private struct function _getIconMapping( required string name ) {
		var iconMap = icons ?: {};
		var mapping = iconMap[ arguments.name ] ?: {};

		if ( IsSimpleValue( mapping ) && Len( Trim( mapping ) ) ) {
			return { path = Trim( mapping ) };
		}

		if ( IsStruct( mapping ) && Len( Trim( mapping.path ?: "" ) ) ) {
			return mapping;
		}

		return {};
	}

	private struct function _getResolveCache() {
		if ( !StructKeyExists( variables, "_resolveCache" ) ) {
			variables._resolveCache = {};
		}

		return variables._resolveCache;
	}

	private struct function _getSvgContentCache() {
		if ( !StructKeyExists( variables, "_svgContentCache" ) ) {
			variables._svgContentCache = {};
		}

		return variables._svgContentCache;
	}

	private struct function _getRenderCache() {
		if ( !StructKeyExists( variables, "_renderCache" ) ) {
			variables._renderCache = {};
		}

		return variables._renderCache;
	}

	private struct function _notFoundResult() {
		return { found=false, name="", filePath="" };
	}

}
