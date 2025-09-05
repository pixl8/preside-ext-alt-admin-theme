( function( $ ) {

	$( document ).ready( function() {
		const $sidebarMenu            = $( ".page-content-sidebar nav ul" )
		    , $expandableMenus        = $( ".has-submenu", $sidebarMenu )
		    , $sideBar                = $sidebarMenu.closest( ".page-content-sidebar" )
		    , isAdminSidebarCollapsed = cookieFn.getCookie( "isAdminSidebarCollapsed" ) || false;

		$expandableMenus.on( "click", function( e ){
			e.preventDefault();
			$( this ).toggleClass( "submenu-open" );
		} ).each( function(){
			if ( $( this ).next().find( "li.active" ).length ) {
				$( this ).addClass( "submenu-open" );
			}
		} );

		$( ".js-toggle-admin-sidebar" ).on( "click", function( e ) {
			e.preventDefault();
			$sideBar.removeClass( "no-transition" )
			$sideBar.toggleClass( "is-collapsed" );

			cookieFn.setCookie( "isAdminSidebarCollapsed", $sideBar.hasClass( "is-collapsed" ) );
		} );

		if( JSON.parse( isAdminSidebarCollapsed ) ) {
			$sideBar.addClass( "is-collapsed" );
		} else {
			$sideBar.removeClass( "is-collapsed" );
		}
	});

	const cookieFn = {
		// https://javascript.info/cookie#appendix-cookie-functions

		getCookie: function( name ) {
			// returns the cookie with the given name,
			// or undefined if not found
			let matches = document.cookie.match( new RegExp( "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)" ) );
			return matches ? decodeURIComponent( matches[1] ) : undefined;
		},

		setCookie: function( name, value, attributes = {} ) {

			attributes = {
				path: '/',
				...attributes
			};

			if ( attributes.expires instanceof Date ) {
				attributes.expires = attributes.expires.toUTCString();
			}

			let updatedCookie = encodeURIComponent( name ) + "=" + encodeURIComponent( value );

			for( let attributeKey in attributes ) {
				updatedCookie += "; " + attributeKey;
				let attributeValue = attributes[attributeKey];
				if ( attributeValue !== true ) {
					updatedCookie += "=" + attributeValue;
				}
			}

			document.cookie = updatedCookie;
		},

		deleteCookie: function( name ) {
			setCookie( name, "", {
				"max-age" : -1
			} );
		}
	}

} )( presideJQuery );