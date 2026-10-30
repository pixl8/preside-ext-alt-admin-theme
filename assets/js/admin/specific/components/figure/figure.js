/**
 * Drives the zoom of the c-figure component (<cf_adminui_figure zoom="true">): the zoom
 * button opens the figure's image dialog, which closes on its close button, Escape or a
 * click on the backdrop.
 */
( function() {
  'use strict';

  const SETTINGS = {
    zoom:   '[data-figure-zoom]',
    dialog: '.c-figure__dialog',
    close:  '.c-figure__dialog-close',
  };

  const onClick = function( e ) {
    if ( !e.target.closest ) {
      return;
    }

    const zoom = e.target.closest( SETTINGS.zoom );

    if ( zoom ) {
      const dialog = document.getElementById( zoom.getAttribute( 'data-figure-zoom' ) );

      if ( dialog && typeof dialog.showModal === 'function' && !dialog.open ) {
        dialog.showModal();
      }
      return;
    }

    const dialog = e.target.closest( SETTINGS.dialog );

    // the dialog itself is only the target when the backdrop around the image is clicked
    if ( dialog && ( e.target === dialog || e.target.closest( SETTINGS.close ) ) ) {
      dialog.close();
    }
  };

  document.addEventListener( 'click', onClick );
} )();
