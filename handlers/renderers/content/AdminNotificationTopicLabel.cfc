component  {

	private string function default( event, rc, prc, args={} ){
		var topicId = args.data ?: "";

		return translateresource( uri="notifications.#topicId#:title", defaultValue=topicId );
	}

}