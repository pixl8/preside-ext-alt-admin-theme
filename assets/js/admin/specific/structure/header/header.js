(function( $ ) {
	$( document ).on( 'click', function( e ) {
		var $trigger = $( e.target ).closest( '.s-header__mobile-navigation-trigger' );

		if ( $trigger.length ) {
			var $nav   = $( '#' + $trigger.attr( 'aria-controls' ) );
			var isOpen = $trigger.attr( 'aria-expanded' ) === 'true';

			$trigger.attr( 'aria-expanded', String( !isOpen ) );
			$nav.slideToggle();
			return;
		}

		var $openNav = $( '.s-mobile-navigation:visible' );
		if ( $openNav.length && !$openNav.is( e.target ) && $openNav.has( e.target ).length === 0 ) {
			$openNav.slideUp();
			$( '.s-header__mobile-navigation-trigger' ).attr( 'aria-expanded', 'false' );
		}
	} );
}( presideJQuery ));
