component {

	private string function default( event, rc, prc, args={} ){
		var topicId = args.data ?: "";

		return translateResource( uri="notifications.#topicId#:title", defaultValue=topicId );
	}

}