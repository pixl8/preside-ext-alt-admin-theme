component {
	private function button( event, rc, prc, args={} ) {
		return renderView( view="/admin/layout/components/button", args=args );
	}

	private function emptyState( event, rc, prc, args={} ) {
		var layout = args.layout ?: "default";

		return renderView( view="/admin/layout/components/emptyState/#layout#", args=args );
	}
}