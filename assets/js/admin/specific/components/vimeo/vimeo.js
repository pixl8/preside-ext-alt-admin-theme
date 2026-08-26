/**
 * Drives the c-vimeo component (<cf_adminui_vimeo>): loads the Vimeo Player SDK on
 * demand, cues each player to its chunk's start time and pauses it at the end time.
 *
 * Init happens on page load, when a bootbox modal is shown, and whenever content is
 * swapped in place (the "presideContentReloaded" event, e.g. modal pagination).
 */
( function( $ ){

	var SDK_URL    = "https://player.vimeo.com/api/player.js";
	var sdkPromise = null;

	var loadSdk = function(){
		if ( window.Vimeo && window.Vimeo.Player ) {
			return Promise.resolve();
		}
		if ( sdkPromise === null ) {
			sdkPromise = new Promise( function( resolve, reject ){
				var script     = document.createElement( "script" );
				script.src     = SDK_URL;
				script.onload  = function(){ resolve(); };
				script.onerror = function(){ reject(); };
				document.head.appendChild( script );
			} );
		}
		return sdkPromise;
	};

	$.fn.vimeoSegmentPlayer = function(){
		return this.each( function(){
			var el = this;

			if ( el.getAttribute( "data-vimeo-init" ) ) { return; }

			var iframe = el.querySelector( ".c-vimeo__player" );
			if ( !iframe ) { return; }

			el.setAttribute( "data-vimeo-init", "1" );

			var start    = parseFloat( el.getAttribute( "data-start" ) ) || 0;
			var end      = parseFloat( el.getAttribute( "data-end" ) ) || 0;
			var autoplay = el.getAttribute( "data-autoplay" ) === "true";

			loadSdk().then( function(){
				var player = new window.Vimeo.Player( iframe );

				player.ready().then( function(){
					if ( start > 0 ) {
						player.setCurrentTime( start ).catch( function(){} );
					}
					if ( end > 0 ) {
						player.on( "timeupdate", function( data ){
							if ( data.seconds >= end ) {
								player.pause().catch( function(){} );
							}
						} );
					}
					if ( autoplay ) {
						player.play().catch( function(){} );
					}
				} ).catch( function(){} );
			} ).catch( function(){} );
		} );
	};

	var initAll = function( root ){
		$( root || document ).find( ".c-vimeo" ).vimeoSegmentPlayer();
	};

	$( function(){ initAll(); } );

	$( "body" ).on( "onShowPresideBootboxModal", function( e, $modal ){
		$modal.on( "shown.bs.modal", function(){ initAll( $modal ); } );
	} );

	$( "body" ).on( "presideContentReloaded", function( e, node ){ initAll( node ); } );

} )( presideJQuery );
