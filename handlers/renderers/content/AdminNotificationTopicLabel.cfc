component {

	private string function default( event, rc, prc, args={} ) {
		var topic = args.data ?: "";

		return translateResource( uri="notifications.#topic#:title", defaultValue=topic );
	}

	private string function admin( event, rc, prc, args={} ) {
		var topic = args.data ?: "";
		var desc  = translateResource( uri="notifications.#topic#:description", defaultValue="" );

		if ( !isEmptyString( desc ) ) {
			desc = '<br /><em class="grey">#desc#</em>';
		}

		return default( argumentCollection=arguments ) & desc;
	}

}