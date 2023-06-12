( function( $ ) {

	$( document ).ready( function() {
		var $sidebarMenu     = $( ".page-content-sidebar nav ul" )
		  , $expandableMenus = $( ".has-submenu", $sidebarMenu );

		$expandableMenus.on( "click", function( e ){
			e.preventDefault();
			$( this ).toggleClass( "submenu-open" );
		} ).each( function(){
			if ( $( this ).next().find( "li.active" ).length ) {
				$( this ).addClass( "submenu-open" );
			}
		} );
	});

} )( presideJQuery );