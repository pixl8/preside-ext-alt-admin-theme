/**
 * Clickable rows for the c-table component (<cf_adminui_table clickableRows="true">): rows
 * are focusable, Enter and Space click them, and every row click dispatches "table:rowclick"
 * on the component with { index (0-based), row } in the detail. Links and controls inside a
 * row keep their own behaviour.
 */
( function() {
  'use strict';

  const SETTINGS = {
    container: '.c-table--clickable-rows',
    row:       '.c-table__row',
    controls:  'a, button, input, select, textarea, label',
  };

  const onClick = function( e ) {
    const row       = e.target.closest ? e.target.closest( SETTINGS.row ) : null;
    const container = row ? row.closest( SETTINGS.container ) : null;

    if ( !container || e.target.closest( SETTINGS.controls ) ) {
      return;
    }

    const rows = Array.from( container.querySelectorAll( SETTINGS.row ) );

    container.dispatchEvent( new CustomEvent( 'table:rowclick', {
      bubbles: true,
      detail:  { index: rows.indexOf( row ), row: row }
    } ) );
  };

  const onKeydown = function( e ) {
    if ( e.key !== 'Enter' && e.key !== ' ' ) {
      return;
    }

    const row = e.target.matches && e.target.matches( SETTINGS.container + ' ' + SETTINGS.row ) ? e.target : null;

    if ( row ) {
      e.preventDefault();
      row.click();
    }
  };

  document.addEventListener( 'click', onClick );
  document.addEventListener( 'keydown', onKeydown );
} )();
