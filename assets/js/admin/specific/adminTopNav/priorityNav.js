( function( $ ){

	var $nav = $( "#topLevelNav" );
	if ( !$nav.length ) {
		return;
	}

	var navEl = $nav.get( 0 );
	var $list = $nav.find( "> ul.ace-nav" );
	var $more = $list.children( "li.js-priority-nav-more" );
	if ( !$list.length || !$more.length ) {
		return;
	}

	var listEl      = $list.get( 0 );
	var moreEl      = $more.get( 0 );
	var $moreToggle = $more.children( "a" );
	var moreMenuEl  = $more.children( "ul.dropdown-menu" ).get( 0 );
	if ( !moreMenuEl ) {
		return;
	}

	var managed = $list.children( "li" ).not( moreEl ).toArray();
	if ( !managed.length ) {
		return;
	}

	var anchors  = managed.map( function( li ){ return $( li ).children( "a" ).get( 0 ) || null; } );
	var subMenus = managed.map( function( li ){ return $( li ).children( "ul.dropdown-menu" ).get( 0 ) || null; } );
	var carets   = managed.map( function( li, i ){
		return anchors[ i ] ? $( anchors[ i ] ).children( ".fa-caret-down, .fa-caret-right" ).get( 0 ) || null : null;
	} );

	var activeIndex = -1;
	for ( var a = 0; a < managed.length; a++ ) {
		if ( $( managed[ a ] ).hasClass( "active" ) || managed[ a ].querySelector( ".active" ) ) {
			activeIndex = a;
			break;
		}
	}

	var widths       = [];
	var moreWidth    = 0;
	var visibleCount = managed.length;
	var needsMeasure = true;
	var scheduled    = false;
	var availWidth   = null;

	function isInlineLayout() {
		return window.getComputedStyle( navEl ).getPropertyValue( "--top-nav-layout" ).trim() === "inline";
	}

	// Not jQuery's .outerWidth( true ): that rounds to the integer offsetWidth, and
	// the error accumulates across items in computeVisibleCount().
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

	// Re-inserting a node already in position drops :hover and any focus inside it.
	function place( el, parent, before ) {
		if ( el.parentNode === parent && el.nextSibling === before ) {
			return false;
		}
		parent.insertBefore( el, before );
		return true;
	}

	// Converts a top level item to the contract core uses for nested dropdown rows,
	// so the flyout comes from `.dropdown-hover` rather than any styling of our own.
	function setCollapsed( i, collapsed ) {
		var li     = managed[ i ];
		var anchor = anchors[ i ];
		var caret  = carets[ i ];
		var sub    = subMenus[ i ];

		if ( !sub ) {
			return;
		}

		li.classList.toggle( "dropdown", collapsed );
		li.classList.toggle( "dropdown-hover", collapsed );

		// `.dropdown-menu-left` out-specifies core's nested `left: 99%`.
		sub.classList.toggle( "dropdown-menu-left", !collapsed );

		if ( caret ) {
			caret.classList.toggle( "fa-caret-down", !collapsed );
			caret.classList.toggle( "fa-caret-right", collapsed );
			caret.classList.toggle( "dropdown-menu-caret", collapsed );
		}

		// Nested rows open on hover; leaving the click toggle in place would let
		// bootstrap close the whole "More" menu.
		if ( anchor ) {
			if ( collapsed && anchor.hasAttribute( "data-toggle" ) ) {
				anchor.setAttribute( "data-collapsed-toggle", anchor.getAttribute( "data-toggle" ) );
				anchor.removeAttribute( "data-toggle" );
			} else if ( !collapsed && anchor.hasAttribute( "data-collapsed-toggle" ) ) {
				anchor.setAttribute( "data-toggle", anchor.getAttribute( "data-collapsed-toggle" ) );
				anchor.removeAttribute( "data-collapsed-toggle" );
			}
		}
	}

	// Backwards, so each item's target sibling is already in position.
	function setVisibleCount( n ) {
		for ( var i = managed.length - 1; i >= 0; i-- ) {
			var inMenu = i >= n;
			var next   = managed[ i + 1 ];
			var parent = inMenu ? moreMenuEl : listEl;
			var before;

			if ( inMenu ) {
				before = ( next && next.parentNode === moreMenuEl ) ? next : null;
			} else {
				before = ( next && ( i + 1 ) < n ) ? next : moreEl;
			}

			if ( place( managed[ i ], parent, before ) ) {
				setCollapsed( i, inMenu );
			}
		}

		$more.toggleClass( "hide", n >= managed.length );
		$moreToggle.toggleClass( "active", activeIndex >= n );

		visibleCount = n;
	}

	function measure() {
		setVisibleCount( managed.length );

		$more.removeClass( "hide" );
		moreWidth = outerWidth( moreEl );
		$more.addClass( "hide" );

		widths       = managed.map( outerWidth );
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

	// By row, not by height: core pins .ace-nav to a fixed height, so a wrapped
	// second row does not make the list any taller.
	function isWrapping() {
		var kids = listEl.children;
		var base = null;

		for ( var i = 0; i < kids.length; i++ ) {
			if ( kids[ i ].offsetParent === null ) {
				continue;
			}
			if ( base === null ) {
				base = kids[ i ].offsetTop;
			} else if ( kids[ i ].offsetTop > base + 1 ) {
				return true;
			}
		}

		return false;
	}

	function apply() {
		if ( !isInlineLayout() ) {
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

		while ( visibleCount > 0 && isWrapping() ) {
			setVisibleCount( visibleCount - 1 );
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

	// The nav is the toolbar's only flexible child, so its width tracks every change
	// in the room available to it - viewport, site picker, controls added at runtime.
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

} )( presideJQuery );
