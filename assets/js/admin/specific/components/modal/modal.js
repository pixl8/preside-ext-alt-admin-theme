/**
 * Drives the c-modal component (<cf_adminui_modal>) and builds the same modal from script.
 *
 * - An element with data-modal-open="{id}" opens the modal with that id. A [data-modal-close] inside a modal,
 *   a click on its backdrop and Escape close it.
 * - window.AdminUiModal.open( "id" ) opens a modal the tag rendered; open( { title, body, ... } ) builds one,
 *   opens it and removes it again once it closes. close( modal ) closes either kind.
 *
 * Modals open with show(), not showModal(), so they stay out of the browser's top layer: Preside's own Bootstrap
 * modals (the asset picker, confirmations) must still be able to open above them. Focus moves into the modal and
 * back to whatever opened it. A modal dispatches "modal:open" when it opens and the dialog's own "close" when it
 * closes.
 */
( function() {
  'use strict';

  const SETTINGS = {
    container:  '.c-modal',
    openAttr:   'data-modal-open',
    close:      '[data-modal-close]',
    builtAttr:  'data-modal-built',
    pageClass:  'has-c-modal',
    sizes:      [ 'sm', 'md', 'lg', 'xl', 'full' ],
    focusable:  'input:not([type="hidden"]):not([disabled]), select:not([disabled]), textarea:not([disabled]), button:not([disabled]), a[href], iframe',
    closeIcon:  '<svg class="c-modal__close-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>'
  };

  const openers = new WeakMap();
  let builtCount = 0;
  let pressedOn  = null;

  const esc = function( value ) {
    return String( value == null ? '' : value ).replace( /[&<>"']/g, function( c ) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ c ];
    } );
  };

  const openModals = function() {
    return Array.from( document.querySelectorAll( SETTINGS.container + '[open]' ) );
  };

  const resolve = function( modal ) {
    if ( typeof modal === 'string' ) {
      return document.getElementById( modal );
    }
    return modal && modal.closest ? modal.closest( SETTINGS.container ) : null;
  };

  // a string is markup; a node (or a list of them) is moved in as it is
  const fill = function( el, content ) {
    if ( content == null ) {
      return;
    }
    if ( typeof content === 'string' ) {
      el.innerHTML = content;
    } else if ( content.nodeType ) {
      el.appendChild( content );
    } else {
      Array.from( content ).forEach( function( node ) { el.appendChild( node ); } );
    }
  };

  const build = function( options ) {
    const modal   = document.createElement( 'dialog' );
    const size    = SETTINGS.sizes.indexOf( options.size ) >= 0 ? options.size : 'md';
    const id      = options.id || 'c-modal-' + ( ++builtCount );
    const heading = ( options.title ? '<h2 class="c-modal__title" id="' + esc( id ) + '-title">' + esc( options.title ) + '</h2>' : '' )
                  + ( options.description ? '<p class="c-modal__description">' + esc( options.description ) + '</p>' : '' );

    modal.id        = id;
    modal.className = 'c-modal c-modal--size-' + size
                    + ( options.fill  ? ' c-modal--fill'  : '' )
                    + ( options.flush ? ' c-modal--flush' : '' )
                    + ( options.className ? ' ' + options.className : '' );
    modal.setAttribute( SETTINGS.builtAttr, '' );
    modal.setAttribute( 'aria-modal', 'true' );
    if ( options.title ) {
      modal.setAttribute( 'aria-labelledby', id + '-title' );
    }

    modal.innerHTML = '<div class="c-modal__panel">'
      + '<div class="c-modal__header">'
      + ( heading ? '<div class="c-modal__heading">' + heading + '</div>' : '' )
      + '<button type="button" class="c-modal__close" data-modal-close aria-label="' + esc( options.closeLabel || 'Close' ) + '">' + SETTINGS.closeIcon + '</button>'
      + '</div>'
      + '<div class="c-modal__body"></div>'
      + ( options.footer ? '<div class="c-modal__footer"></div>' : '' )
      + '</div>';

    fill( modal.querySelector( '.c-modal__body' ), options.body );
    if ( options.footer ) {
      fill( modal.querySelector( '.c-modal__footer' ), options.footer );
    }
    if ( typeof options.onClose === 'function' ) {
      modal.addEventListener( 'close', options.onClose );
    }

    document.body.appendChild( modal );
    return modal;
  };

  const focusFirst = function( modal ) {
    const target = modal.querySelector( '[autofocus]' )
                || modal.querySelector( '.c-modal__body' ).querySelector( SETTINGS.focusable )
                || modal.querySelector( '.c-modal__close' );

    if ( target ) {
      target.focus();
    }
  };

  const show = function( modal ) {
    if ( !openers.has( modal ) ) {
      openers.set( modal, modal.open ? null : document.activeElement );
    }
    if ( !modal.open ) {
      modal.show();
    }
    document.documentElement.classList.add( SETTINGS.pageClass );
    focusFirst( modal );
    modal.dispatchEvent( new CustomEvent( 'modal:open', { bubbles: true } ) );

    return modal;
  };

  const open = function( target ) {
    const modal = typeof target === 'string' ? document.getElementById( target ) : build( target || {} );

    return modal ? show( modal ) : null;
  };

  // Runs as the modal closes, not on its "close" event: that comes a task later, after a modal opened straight
  // away (closing one, opening the next) has taken focus, which it would then hand back to the old opener.
  const finish = function( modal ) {
    if ( !openers.has( modal ) ) {
      return;
    }

    const opener = openers.get( modal );
    const active = document.activeElement;
    openers.delete( modal );

    if ( !openModals().length ) {
      document.documentElement.classList.remove( SETTINGS.pageClass );
    }
    // focus goes back only if it was in the modal, or went with it
    if ( opener && opener.isConnected && typeof opener.focus === 'function' && ( !active || active === document.body || modal.contains( active ) ) ) {
      opener.focus();
    }
    if ( modal.hasAttribute( SETTINGS.builtAttr ) ) {
      modal.remove();
    }
  };

  const close = function( target ) {
    const modal = resolve( target );

    if ( modal && modal.open ) {
      modal.close();
      finish( modal );
    }
  };

  // a modal closed some other way (a form with method="dialog", say). "close" doesn't bubble, so this listens
  // while it travels down; a modal opened again since has nothing to finish.
  const onClose = function( e ) {
    const modal = e.target;

    if ( modal.matches && modal.matches( SETTINGS.container ) && !modal.open ) {
      finish( modal );
    }
  };

  const onClick = function( e ) {
    const trigger = e.target.closest ? e.target.closest( '[' + SETTINGS.openAttr + ']' ) : null;

    if ( trigger ) {
      e.preventDefault();
      open( trigger.getAttribute( SETTINGS.openAttr ) );
      return;
    }

    const closer = e.target.closest ? e.target.closest( SETTINGS.close ) : null;
    if ( closer && resolve( closer ) ) {
      close( closer );
      return;
    }

    // the backdrop is the dialog itself; a press that started inside the panel (selecting text) doesn't count
    if ( e.target.matches && e.target.matches( SETTINGS.container ) && pressedOn === e.target ) {
      close( e.target );
    }
  };

  const onKeydown = function( e ) {
    // a Bootstrap modal open above ours takes Escape for itself
    if ( e.key !== 'Escape' || document.body.classList.contains( 'modal-open' ) ) {
      return;
    }

    const modals = openModals();
    if ( modals.length ) {
      e.preventDefault();
      close( modals[ modals.length - 1 ] );
    }
  };

  document.addEventListener( 'pointerdown', function( e ) { pressedOn = e.target; }, true );
  document.addEventListener( 'click', onClick );
  document.addEventListener( 'keydown', onKeydown );
  document.addEventListener( 'close', onClose, true );

  // a modal the tag rendered open
  const init = function() {
    openModals().forEach( show );
  };

  if ( document.readyState === 'loading' ) {
    document.addEventListener( 'DOMContentLoaded', init );
  } else {
    init();
  }

  window.AdminUiModal = { open: open, close: close };
} )();
