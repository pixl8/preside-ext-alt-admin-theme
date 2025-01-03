component {

	private string function default( event, rc, prc, args={} ) {
		var status = isTrue( args.data ?: "" ) ? "subscribed" : "unsubscribed";

		return translateResource( uri="preside-objects.admin_notification_topic:field.topic_email.listing.#status#.label" );
	}

}