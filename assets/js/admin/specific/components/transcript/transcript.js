/**
 * Drives the c-transcript component (<cf_adminui_transcript>):
 *
 * - follows "video:timeupdate" from the player named in data-player, marking the line
 *   being spoken as active and keeping it in view inside a scrolling container
 * - when collapsible, opens the group holding the active line and closes the one it left
 * - clicking a line (or its time button) dispatches "transcript:seek" with { time } on the
 *   component and, when linked to a player, sends it a "video:seek" to that time
 */
( function() {
  'use strict';

  const SETTINGS = {
    container:        '.c-transcript',
    group:            '.c-transcript__group',
    item:             '.c-transcript__item',
    activeClass:      'is-active',
    collapsibleClass: 'c-transcript--collapsible',
  };

  // nearest ancestor that scrolls; the page itself is never scrolled for the user
  const getScrollParent = function( el ) {
    for ( let node = el.parentElement; node && node !== document.body; node = node.parentElement ) {
      const overflowY = getComputedStyle( node ).overflowY;

      if ( ( overflowY === 'auto' || overflowY === 'scroll' ) && node.scrollHeight > node.clientHeight ) {
        return node;
      }
    }

    return null;
  };

  const keepInView = function( item ) {
    const parent = getScrollParent( item );

    if ( !parent ) {
      return;
    }

    const itemRect   = item.getBoundingClientRect();
    const parentRect = parent.getBoundingClientRect();

    if ( itemRect.top < parentRect.top || itemRect.bottom > parentRect.bottom ) {
      parent.scrollTo( {
        top:      parent.scrollTop + ( itemRect.top - parentRect.top ) - ( parent.clientHeight / 3 ),
        behavior: 'smooth'
      } );
    }
  };

  // groups the user opened by hand stay open; only the group playback leaves is closed
  const followGroup = function( previousItem, activeItem ) {
    const previousGroup = previousItem ? previousItem.closest( SETTINGS.group ) : null;
    const activeGroup   = activeItem.closest( SETTINGS.group );

    if ( previousGroup === activeGroup ) {
      return;
    }

    if ( previousGroup ) {
      previousGroup.open = false;
    }

    if ( activeGroup ) {
      activeGroup.open = true;
    }
  };

  const setActive = function( container, time ) {
    let active = null;

    container.querySelectorAll( SETTINGS.item ).forEach( function( item ) {
      if ( parseFloat( item.getAttribute( 'data-start' ) ) <= time ) {
        active = item;
      }
    } );

    const current = container.querySelector( SETTINGS.item + '.' + SETTINGS.activeClass );

    if ( current === active ) {
      return;
    }

    if ( current ) {
      current.classList.remove( SETTINGS.activeClass );
      current.removeAttribute( 'aria-current' );
    }

    if ( active ) {
      active.classList.add( SETTINGS.activeClass );
      active.setAttribute( 'aria-current', 'true' );

      if ( container.classList.contains( SETTINGS.collapsibleClass ) ) {
        followGroup( current, active );
      }

      keepInView( active );
    }
  };

  const onTimeUpdate = function( e ) {
    const playerId = e.target && e.target.id;

    if ( !playerId ) {
      return;
    }

    document.querySelectorAll( SETTINGS.container ).forEach( function( container ) {
      if ( container.getAttribute( 'data-player' ) === playerId ) {
        setActive( container, e.detail.currentTime );
      }
    } );
  };

  const onClick = function( e ) {
    const item      = e.target.closest ? e.target.closest( SETTINGS.item ) : null;
    const container = item ? item.closest( SETTINGS.container ) : null;

    if ( !container ) {
      return;
    }

    // a drag to select text ends in a click too; leave selections alone
    const selection = window.getSelection ? window.getSelection() : null;
    if ( selection && !selection.isCollapsed && item.contains( selection.anchorNode ) ) {
      return;
    }

    const time   = parseFloat( item.getAttribute( 'data-start' ) );
    const player = document.getElementById( container.getAttribute( 'data-player' ) || '' );

    container.dispatchEvent( new CustomEvent( 'transcript:seek', { bubbles: true, detail: { time: time } } ) );

    if ( player ) {
      player.dispatchEvent( new CustomEvent( 'video:seek', { detail: { time: time, play: true } } ) );
    }
  };

  document.addEventListener( 'video:timeupdate', onTimeUpdate );
  document.addEventListener( 'click', onClick );
} )();
