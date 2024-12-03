( function( $ ){

	var $topNav = $( "#topLevelNav" );

	if ( $topNav.length ) {
		var activeItemId = $topNav.data( "activeItem" );

		if ( typeof activeItemId !== "undefined" && activeItemId.length ) {
			var item = $topNav.find( "[data-item-id=" + activeItemId + "]:first" );

			if ( item.length ) {
				item.addClass( "active" ).parents( "li" ).addClass( "active" ).each( function(){
					$( this ).find( "a:first" ).addClass( "active" );
				} );
			}
		}
	}

} )( presideJQuery );