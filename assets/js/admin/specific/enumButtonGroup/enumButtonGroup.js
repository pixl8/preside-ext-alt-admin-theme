( function( $ ) {

	$( document ).ready( function() {
		$( ".enum-button-group-control" ).each( function(){
			var $control      = $( this )
			  , $buttons      = $( "button", $control )
			  , activeClass   = $control.data( "activeClass"   )
			  , inactiveClass = $control.data( "inactiveClass" )
			  , hiddenField   = $control.data( "hiddenField"   )
			  , $hiddenField  = $( "input[name=" + hiddenField + "]" );

			$buttons.on( "click", function() {
				var $active   = $( this )
				  , $inactive = $active.siblings()
				  , value     = $active.data( "value" );

				$active.addClass( activeClass ).removeClass( inactiveClass );
				$inactive.addClass( inactiveClass ).removeClass( activeClass );
				$hiddenField.val( value ).change();
			} );
		});
	});

} )( presideJQuery );