( function( $ ){

	var navEls = document.querySelectorAll( "[data-menu-app-priority-nav]" );

	for ( var n = 0; n < navEls.length; n++ ) {
		setupPriorityNav( navEls[ n ] );
	}

	function setupPriorityNav( navEl ) {
		var listEl = navEl.querySelector( ".c-menu-app__items" );
		var moreEl = navEl.querySelector( ".js-menu-app-more" );
		if ( !listEl || !moreEl ) {
			return;
		}

		var moreMenuEl = moreEl.querySelector( ".c-menu-app__more-menu" );
		if ( !moreMenuEl ) {
			return;
		}

		var managed = [];
		var kids    = listEl.children;
		for ( var i = 0; i < kids.length; i++ ) {
			if ( kids[ i ] !== moreEl && kids[ i ].classList.contains( "c-menu-app__item" ) ) {
				managed.push( kids[ i ] );
			}
		}
		if ( !managed.length ) {
			return;
		}

		var widths       = [];
		var moreWidth    = 0;
		var visibleCount = managed.length;
		var needsMeasure = true;
		var scheduled    = false;
		var availWidth   = null;

		function activeIndex() {
			for ( var i = 0; i < managed.length; i++ ) {
				if ( managed[ i ].classList.contains( "is-active" ) || managed[ i ].querySelector( ".is-active" ) ) {
					return i;
				}
			}
			return -1;
		}

		function isVisible() {
			return navEl.offsetParent !== null && navEl.clientWidth > 0;
		}

		function outerWidth( el ) {
			var style = window.getComputedStyle( el );
			return el.getBoundingClientRect().width
				+ ( parseFloat( style.marginLeft )  || 0 )
				+ ( parseFloat( style.marginRight ) || 0 );
		}

		function getAvailableWidth() {
			if ( availWidth !== null ) {
				return availWidth;
			}
			var style = window.getComputedStyle( navEl );
			return navEl.clientWidth
				- ( parseFloat( style.paddingLeft )  || 0 )
				- ( parseFloat( style.paddingRight ) || 0 );
		}

		function place( el, parent, before ) {
			if ( el.parentNode === parent && el.nextSibling === before ) {
				return false;
			}
			parent.insertBefore( el, before );
			return true;
		}

		function setVisibleCount( count ) {
			for ( var i = managed.length - 1; i >= 0; i-- ) {
				var inMenu = i >= count;
				var next   = managed[ i + 1 ];
				var parent = inMenu ? moreMenuEl : listEl;
				var before;

				if ( inMenu ) {
					before = ( next && next.parentNode === moreMenuEl ) ? next : null;
				} else {
					before = ( next && ( i + 1 ) < count ) ? next : moreEl;
				}

				place( managed[ i ], parent, before );
			}

			moreEl.classList.toggle( "is-hidden", count >= managed.length );
			moreEl.classList.toggle( "is-active", activeIndex() >= count && activeIndex() !== -1 );

			visibleCount = count;
		}

		function measure() {
			setVisibleCount( managed.length );

			navEl.classList.add( "is-measuring" );
			moreEl.classList.remove( "is-hidden" );

			widths = managed.map( outerWidth );
			moreWidth = outerWidth( moreEl );

			moreEl.classList.add( "is-hidden" );
			navEl.classList.remove( "is-measuring" );

			needsMeasure = false;
		}

		function computeVisibleCount() {
			var available = getAvailableWidth();
			var total     = 0;
			var i;

			for ( i = 0; i < widths.length; i++ ) {
				total += widths[ i ];
			}

			if ( total <= available ) {
				return managed.length;
			}

			var budget = available - moreWidth;
			var used   = 0;
			var count  = 0;

			for ( i = 0; i < widths.length; i++ ) {
				used += widths[ i ];
				if ( used > budget ) {
					break;
				}
				count++;
			}

			return count;
		}

		function apply() {
			if ( !isVisible() ) {
				needsMeasure = true;
				if ( visibleCount !== managed.length ) {
					setVisibleCount( managed.length );
				}
				return;
			}

			if ( needsMeasure ) {
				measure();
			}

			var target = computeVisibleCount();
			if ( target !== visibleCount ) {
				setVisibleCount( target );
			}
		}

		function schedule() {
			if ( scheduled ) {
				return;
			}
			scheduled = true;
			window.requestAnimationFrame( function(){
				scheduled = false;
				apply();
			} );
		}

		function remeasure() {
			needsMeasure = true;
			schedule();
		}

		apply();

		if ( window.ResizeObserver ) {
			new ResizeObserver( function( entries ){
				var width = entries[ entries.length - 1 ].contentRect.width;
				if ( width === availWidth ) {
					return;
				}
				availWidth = width;
				schedule();
			} ).observe( navEl );
		} else {
			$( window ).on( "resize", function(){
				availWidth = null;
				schedule();
			} );
		}

		if ( window.document.fonts && window.document.fonts.ready ) {
			window.document.fonts.ready.then( remeasure );
		} else {
			$( window ).on( "load", remeasure );
		}
	}

} )( presideJQuery );
