component {
	private function button( event, rc, prc, args={} ) {
		return renderView( view="/admin/layout/components/button", args=args );
	}

	private function emptyState( event, rc, prc, args={} ) {
		var layout       = args.layout ?: "default";
		var validLayouts = [ "default", "media" ];

		if ( !ArrayFindNoCase( validLayouts, layout ) ) {
			throw( type="admin.theme.bad.layout", message="The layout [#layout#] is not a valid layout for the empty state component. Valid layouts are #SerializeJson( validLayouts )#" );
		}

		return renderView( view="/admin/layout/components/emptyState/#layout#", args=args );
	}

	private function icon( event, rc, prc, args={} ) {
		return renderView( view="/admin/layout/components/icon", args=args );
	}

	private function imagePopup( event, rc, prc, args={} ) {
		return renderView( view="/admin/layout/components/imagePopup", args=args );
	}
}