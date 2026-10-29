/**
 * Drives the c-vimeo component (<cf_adminui_vimeo>): loads the Vimeo Player SDK on
 * demand, cues each player to its chunk's start time and pauses it at the end time.
 *
 * A player with an id also speaks the same events as cf_adminui_video: it bubbles
 * video:timeupdate and seeks when it receives video:seek. Players without an id,
 * such as the chunk modal, keep the start and end behaviour only.
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
			var sync     = !!el.id;
			var paused   = true;

			var broadcast = function( data ){
				el.dispatchEvent( new CustomEvent( "video:timeupdate", {
					bubbles: true,
					detail: {
						currentTime: data.seconds || 0,
						duration: data.duration || 0,
						paused: paused
					}
				} ) );
			};

			loadSdk().then( function(){
				var player = new window.Vimeo.Player( iframe );

				if ( sync ) {
					el.addEventListener( "video:seek", function( e ){
						var time       = parseFloat( e.detail && e.detail.time );
						var shouldPlay = !!( e.detail && e.detail.play );

						if ( isNaN( time ) ) {
							return;
						}

						// play() has to run in this click, before the seek promise, or the browser blocks it
						if ( shouldPlay ) {
							player.play().catch( function(){} );
						}

						player.setCurrentTime( Math.max( 0, time ) ).then( function(){
							if ( shouldPlay ) {
								player.play().catch( function(){} );
							}
						} ).catch( function(){} );
					} );
				}

				player.ready().then( function(){
					if ( start > 0 ) {
						player.setCurrentTime( start ).catch( function(){} );
					}
					if ( end > 0 || sync ) {
						player.on( "timeupdate", function( data ){
							if ( end > 0 && data.seconds >= end ) {
								player.pause().catch( function(){} );
							}
							if ( sync ) {
								broadcast( data );
							}
						} );
					}
					if ( sync ) {
						player.on( "play", function(){
							paused = false;
						} );
						player.on( "pause", function(){
							paused = true;
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
