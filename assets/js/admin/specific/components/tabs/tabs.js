/**
 * Drives the c-tabs component (<cf_adminui_tabs>): switches panels on click and supports the
 * ARIA tabs keyboard pattern (arrow keys, Home, End). Dispatches "tabs:change" on the
 * component with the newly selected tab and panel ids.
 */
( function() {
  'use strict';

  const SETTINGS = {
    container:   '.c-tabs',
    tab:         '.c-tabs__tab',
    activeClass: 'is-active',
  };

  // only the container's own tabs, so nested tab sets stay independent
  const getTabs = function( container ) {
    return Array.from( container.querySelectorAll( ':scope > .c-tabs__list > ' + SETTINGS.tab ) );
  };

  const activate = function( tab, moveFocus ) {
    const container = tab.closest( SETTINGS.container );

    if ( !container || tab.classList.contains( SETTINGS.activeClass ) ) {
      if ( moveFocus ) {
        tab.focus();
      }
      return;
    }

    getTabs( container ).forEach( function( item ) {
      const isActive = item === tab;
      const panel    = document.getElementById( item.getAttribute( 'aria-controls' ) );

      item.classList.toggle( SETTINGS.activeClass, isActive );
      item.setAttribute( 'aria-selected', isActive ? 'true' : 'false' );
      item.tabIndex = isActive ? 0 : -1;

      if ( panel ) {
        panel.hidden = !isActive;
      }
    } );

    if ( moveFocus ) {
      tab.focus();
    }

    container.dispatchEvent( new CustomEvent( 'tabs:change', {
      bubbles: true,
      detail:  { tab: tab.id, panel: tab.getAttribute( 'aria-controls' ) }
    } ) );
  };

  const onClick = function( e ) {
    const tab = e.target.closest ? e.target.closest( SETTINGS.tab ) : null;

    if ( tab ) {
      activate( tab, false );
    }
  };

  const onKeydown = function( e ) {
    const tab = e.target.closest ? e.target.closest( SETTINGS.tab ) : null;

    if ( !tab ) {
      return;
    }

    const tabs  = getTabs( tab.closest( SETTINGS.container ) );
    const index = tabs.indexOf( tab );
    let next    = null;

    switch ( e.key ) {
      case 'ArrowRight': next = tabs[ ( index + 1 ) % tabs.length ]; break;
      case 'ArrowLeft':  next = tabs[ ( index - 1 + tabs.length ) % tabs.length ]; break;
      case 'Home':       next = tabs[ 0 ]; break;
      case 'End':        next = tabs[ tabs.length - 1 ]; break;
    }

    if ( next ) {
      e.preventDefault();
      activate( next, true );
    }
  };

  document.addEventListener( 'click', onClick );
  document.addEventListener( 'keydown', onKeydown );
} )();
