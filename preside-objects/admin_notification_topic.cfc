/**
 * @dataManagerEnabled true
 */
component {

	property name="topic_label"           formula="${prefix}topic"                                                              autoFilter=false excludeDataExport=true renderer="AdminNotificationTopicLabel";
	property name="topic_email"           formula="admin_notification_subscription_subquery.get_email_notifications"            autoFilter=false excludeDataExport=true renderer="AdminNotificationTopicEmail";
	property name="topic_subscription"    formula="if ( char_length( admin_notification_subscription_subquery.id ) > 0, 1, 0 )" autoFilter=false excludeDataExport=true renderer="AdminNotificationTopicSubscription";
	property name="topic_subscription_id" formula="admin_notification_subscription_subquery.id"                                 autoFilter=false excludeDataExport=true;

}