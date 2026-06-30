/**
 * @presideService true
 * @singleton      true
 */
component {

	property name="appMapping"       inject="coldbox:setting:appMapping";
	property name="activeExtensions" inject="coldbox:setting:activeExtensions";

	public function init() {
		return this;
	}

	public function postInit() {
		_buildIllustrationIndex();
	}

	private string function _getIllustrationSubPath() {
		return "assets/illustrations/empty-states";
	}

	public struct function resolveIllustration( required string name ) {
		var safeName          = _sanitizeName( arguments.name );
		var illustrationIndex = _getIllustrationIndex();

		if ( !Len( safeName ) ) {
			return _notFoundResult();
		}


		return illustrationIndex[ safeName ] ?: _notFoundResult();
	}

	public void function clearCache() {
		StructDelete( variables, "_illustrationIndex" );
	}

	private struct function _getIllustrationIndex() {
		if ( !StructKeyExists( variables, "_illustrationIndex" ) ) {
			_buildIllustrationIndex();
		}

		return variables._illustrationIndex;
	}

	private function _buildIllustrationIndex() {
		var index           = {};
		var illustrationDir = "";
		var subPath         = _getIllustrationSubPath();

		illustrationDir = ListAppend( ExpandPath( "/#appMapping#" ), subPath, _getDirDelimiter() );
		_indexIllustrationsInDirectory(
			  directory    = illustrationDir
			, urlPrefix    = ""
			, index        = index
			, skipExisting = false
		);

		for ( var extension in activeExtensions ) {
			illustrationDir = ListAppend( ExpandPath( extension.directory ), subPath, _getDirDelimiter() );
			_indexIllustrationsInDirectory(
				  directory    = illustrationDir
				, urlPrefix    = "/preside/system/assets/extension/#extension.id#/#subPath#"
				, index        = index
				, skipExisting = true
			);
		}

		variables._illustrationIndex = index;
	}

	private void function _indexIllustrationsInDirectory(
		  required string directory
		, required string urlPrefix
		, required struct index
		, required boolean skipExisting
	) {
		if ( !DirectoryExists( arguments.directory ) ) {
			return;
		}

		for ( var fileName in DirectoryList( arguments.directory, false, "name", "*.svg" ) ) {
			var illustrationName = ListFirst( fileName, "." );

			if ( arguments.skipExisting && StructKeyExists( arguments.index, illustrationName ) ) {
				continue;
			}

			arguments.index[ illustrationName ] = {
				  found    = true
				, url      = Len( arguments.urlPrefix ) ? arguments.urlPrefix & "/" & fileName : ""
				, filePath = ListAppend( arguments.directory, fileName, _getDirDelimiter() )
			};
		}
	}

	private string function _sanitizeName( required string name ) {
		return REReplace( arguments.name, "[^a-zA-Z0-9\-_]", "", "all" );
	}

	private struct function _notFoundResult() {
		return { found=false, url="", filePath="" };
	}

	private string function _getDirDelimiter() {
		if ( !StructKeyExists( variables, "_dirDelimiter" ) ) {
			variables._dirDelimiter = CreateObject( "java", "java.lang.System" ).getProperty( "file.separator" );
		}

		return variables._dirDelimiter;
	}

}
