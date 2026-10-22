/**
 * Drives the c-video component (<cf_adminui_video>) so other components can sync to it:
 *
 * - dispatches "video:timeupdate" on the component as playback moves, with
 *   { currentTime, duration, paused } in the event detail
 * - seeks when it receives "video:seek" with { time, play } in the detail
 * - clicking any element with data-video-player="{component id}" and data-video-seek="{seconds}"
 *   seeks that player and plays, e.g. table rows or links, with no page script
 *
 * Also cues the player to its data-start time once the metadata has loaded.
 */
( function() {
  'use strict';

  const SETTINGS = {
    container:   '.c-video',
    player:      '.c-video__player',
    initAttr:    'data-video-init',
    seekTrigger: '[data-video-player][data-video-seek]',
  };

  const broadcast = function( container, player ) {
    container.dispatchEvent( new CustomEvent( 'video:timeupdate', {
      bubbles: true,
      detail:  { currentTime: player.currentTime, duration: player.duration || 0, paused: player.paused }
    } ) );
  };

  const init = function( container ) {
    const player = container.querySelector( SETTINGS.player );

    if ( !player || container.hasAttribute( SETTINGS.initAttr ) ) {
      return;
    }

    container.setAttribute( SETTINGS.initAttr, '1' );

    const start = parseFloat( container.getAttribute( 'data-start' ) ) || 0;

    if ( start > 0 ) {
      const cue = function() { player.currentTime = start; };

      if ( player.readyState >= 1 ) {
        cue();
      } else {
        player.addEventListener( 'loadedmetadata', cue, { once: true } );
      }
    }

    [ 'timeupdate', 'seeked', 'play', 'pause' ].forEach( function( name ) {
      player.addEventListener( name, function() { broadcast( container, player ); } );
    } );

    container.addEventListener( 'video:seek', function( e ) {
      const time = parseFloat( e.detail && e.detail.time );

      if ( isNaN( time ) ) {
        return;
      }

      player.currentTime = Math.max( 0, time );

      if ( e.detail.play ) {
        player.play().catch( function() {} );
      }
    } );
  };

  const onSeekTriggerClick = function( e ) {
    const trigger = e.target.closest ? e.target.closest( SETTINGS.seekTrigger ) : null;

    if ( !trigger ) {
      return;
    }

    const container = document.getElementById( trigger.getAttribute( 'data-video-player' ) );
    const time      = parseFloat( trigger.getAttribute( 'data-video-seek' ) );

    if ( container && !isNaN( time ) ) {
      container.dispatchEvent( new CustomEvent( 'video:seek', { detail: { time: time, play: true } } ) );
    }
  };

  const initAll = function() {
    document.querySelectorAll( SETTINGS.container ).forEach( init );
  };

  document.addEventListener( 'click', onSeekTriggerClick );

  if ( document.readyState === 'loading' ) {
    document.addEventListener( 'DOMContentLoaded', initAll );
  } else {
    initAll();
  }
} )();
