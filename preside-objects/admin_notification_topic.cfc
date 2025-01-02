component {

	property name="topic_label"        formula="${prefix}topic"                                                                 renderer="AdminNotificationTopicLabel";
	property name="topic_subscription" formula="if ( char_length( admin_notification_subscription_subquery.topic ) > 0, 1, 0 )" renderer="AdminNotificationTopicSubscription";
	property name="topic_email"        formula="admin_notification_subscription_subquery.get_email_notifications"               renderer="AdminNotificationTopicEmail";

}