( function( $ ){

	var navbar = document.getElementById( "navbar" );
	if ( !navbar ) {
		return;
	}

	// Core's preside.dropdown.overflow.js flips a nested flyout left only when it
	// would leave the window. The navbar is narrower than the window whenever
	// something reserves space beside the page (a docked side panel, say), and a
	// flyout past its edge then opens underneath that. Same flip, against the
	// navbar's edge: a recalculated left when core has fixed the flyout, else CSS.
	function keepWithinNavbar( $item ) {
		var $flyout = $item.children( ".dropdown-menu" );
		if ( !$flyout.is( ":visible" ) ) {
			return;
		}

		var edge = navbar.getBoundingClientRect().right;
		if ( $flyout[ 0 ].getBoundingClientRect().right <= edge ) {
			return;
		}

		if ( $flyout.css( "position" ) === "fixed" ) {
			$flyout.css( "left", ( $item[ 0 ].getBoundingClientRect().left - $flyout.outerWidth() ) + "px" );
		} else {
			$flyout.css( { left: "auto", right: "100%" } );
		}
	}

	// On the document, not the navbar, and only once the DOM is ready: that keeps
	// this after core's handler, so our frame runs after the one core schedules.
	// Core's mouseleave clears what we set here too.
	$( function(){
		$( document ).on( "mouseenter", "#navbar .dropdown-menu .dropdown-hover", function(){
			var $item = $( this );

			window.requestAnimationFrame( function(){
				keepWithinNavbar( $item );
			} );
		} );
	} );

} )( presideJQuery );
