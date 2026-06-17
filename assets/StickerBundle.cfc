component {

	public void function configure( bundle ) {
		bundle.addAssets(
			  directory   = "/js/"
			, match       = function( path ){ return ReFindNoCase( "_[0-9a-f]{8}\..*?\.min.js$", arguments.path ); }
			, idGenerator = function( path ) {
				return ListDeleteAt( path, ListLen( path, "/" ), "/" ) & "/";
			}
		);
		bundle.addAssets(
			  directory   = "/css/"
			, match       = function( path ){ return ReFindNoCase( "_[0-9a-f]{8}\..*?\.min.css$", arguments.path ); }
			, idGenerator = function( path ) {
				return ListDeleteAt( path, ListLen( path, "/" ), "/" ) & "/";
			}
		);

		bundle.asset( "/css/admin/altadmintheme/" ).after( "/css/admin/core/" );
		bundle.asset( "/css/admin/altadmintheme/" ).after( "/css/admin/frontend/" );
		bundle.asset( "/css/admin/altadmintheme-modern/" ).after( "/css/admin/altadmintheme/" );
		bundle.asset( "/css/admin/altadmintheme-modern-data-tables/" ).after( "/css/admin/altadmintheme-modern/" );

		bundle.addAsset( id="alpine"     , url="//cdn.jsdelivr.net/npm/alpinejs@3.14.1/dist/cdn.min.js"              , type="js" );
		bundle.addAsset( id="alpine-ajax", url="//cdn.jsdelivr.net/npm/@imacrayon/alpine-ajax@0.10.5/dist/cdn.min.js", type="js" );
		bundle.asset( "alpine-ajax" ).before( "alpine" );
	}
}