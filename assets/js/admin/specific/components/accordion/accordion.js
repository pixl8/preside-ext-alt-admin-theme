( function() {
  'use strict';

  const SETTINGS = {
    container:   '.c-accordion',
    activeClass: 'is-open',
  };

  const syncOpenState = function( e ) {
    const el = e.target;

    if ( !el || typeof el.matches !== 'function' || !el.matches( SETTINGS.container ) ) {
      return;
    }

    el.classList.toggle( SETTINGS.activeClass, el.open );
  };

  document.addEventListener( 'toggle', syncOpenState, true );
} )();
