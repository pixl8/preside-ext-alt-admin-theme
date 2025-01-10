/**
 * @presideService true
 * @singleton      true
 */
component {

	property name="presideObjectService" inject="PresideObjectService";
	property name="notificationService"  inject="NotificationService";

	public any function init() {
		return this;
	}

	public query function getUser(
		  required string userId
		,          array  selectFields = []
	) {
		return presideObjectService.selectData(
			  objectName   = "security_user"
			, id           = arguments.userId
			, selectFields = arguments.selectFields
		);
	}

	public boolean function saveActivation(
		  required string  userId
		, required boolean active
	) {
		return presideObjectService.updateData(
			  objectName   = "security_user"
			, filter       = "id = :id and active = :active"
			, filterParams = {
				  id     = arguments.userId
				, active = !arguments.active
			  }
			, data         = {
				active = arguments.active
			  }
		) > 0;
	}

	public query function getGroup(
		  required string groupId
		,          array  selectFields = []
	) {
		return presideObjectService.selectData(
			  objectName   = "security_group"
			, id           = arguments.groupId
			, selectFields = arguments.selectFields
		);
	}

	public numeric function getGroupCount( required string userId=$getAdminLoggedInUserId() ) {
		var securityGroup = getUser( userId=userId, selectFields=[ "count( distinct groups.id ) as total" ] );

		return securityGroup.total ?: 0;
	}

	public boolean function saveGroup(
		  required string  groupId
		, required string  userId
		, required boolean assign
	) {
		var prop       = presideObjectService.getObjectProperty( "security_user", "groups" );
		var relatedVia = prop.relatedVia ?: "";

		if ( !$helpers.isEmptyString( relatedVia ) ) {
			try {
				if ( arguments.assign ) {
					presideObjectService.insertData(
						  objectName = relatedVia
						, data       = { security_group=arguments.groupId, security_user=arguments.userId }
					);

					return true;
				} else {
					return presideObjectService.deleteData(
						  objectName = relatedVia
						, filter     = { security_group=arguments.groupId, security_user=arguments.userId }
					) > 0;
				}
			} catch ( any e ) {}
		}

		return false;
	}

	public query function getSubscription(
		  required string topic
		,          string userId       = $getAdminLoggedInUserId()
		,          array  selectFields = []
	) {
		var filterParams = {};

		var subQuery = presideObjectService.selectData(
			  objectName      = "admin_notification_subscription"
			, selectFields        = [ "id", "topic", "security_user", "get_email_notifications" ]
			, filter              = { security_user=arguments.userId }
			, getSqlAndParamsOnly = true
		);

		for( var param in subQuery.params ) { filterParams[ param.name ] = param; }

		return presideObjectService.selectData(
			  objectName   = "admin_notification_topic"
			, selectFields = arguments.selectFields
			, filter       = { topic=arguments.topic }
			, filterParams = filterParams
			, extraJoins   = [
				  {
					  type           = "left"
					, subQuery       = subQuery.sql
					, subQueryAlias  = "admin_notification_subscription_subquery"
					, subQueryColumn = "topic"
					, joinToTable    = "admin_notification_topic"
					, joinToColumn   = "topic"
				  }
			  ]
			, useCache    = false
		);

		return presideObjectService.selectData(
			  objectName   = "admin_notification_topic"
			, id           = arguments.subscriptionId
			, selectFields = arguments.selectFields
		);
	}

	public numeric function getSubscriptionCount( required string userId ) {
		return presideObjectService.selectData(
			  objectName      = "admin_notification_subscription"
			, filter          = { security_user=arguments.userId }
			, recordCountOnly = true
		);
	}

	public boolean function setAllNotifications(
		  required string  userId
		, required boolean all
	) {
		return presideObjectService.updateData(
			  objectName   = "security_user"
			, filter       = "id = :id and subscribed_to_all_notifications = :subscribed_to_all_notifications"
			, filterParams = {
				  id     = arguments.userId
				, subscribed_to_all_notifications = !arguments.all
			  }
			, data         = {
				subscribed_to_all_notifications = arguments.all
			  }
		) > 0;
	}

	public boolean function saveSubscription(
		  required string  topic
		,          string  userId       = $getAdminLoggedInUserId()
		,          boolean notification = true
		,          boolean email        = false
	) {
		var status = false;

		if ( arguments.notification ) {
			var subscription = getSubscription( topic=arguments.topic, userId=arguments.userId, selectFields=[ "topic_subscription_id" ] );

			if ( $helpers.isEmptyString( subscription.topic_subscription_id ?: "" ) ) {
				status = Len( presideObjectService.insertData(
					  objectName   = "admin_notification_subscription"
					, data         = {
						  security_user           = arguments.userId
						, topic                   = arguments.topic
						, get_email_notifications = arguments.email
					  }
				) ) > 0;
			} else {
				status = presideObjectService.updateData(
					  objectName   = "admin_notification_subscription"
					, filter       = {
						  topic         = arguments.topic
						, security_user = arguments.userId
					  }
					, data         = {
						get_email_notifications = arguments.email
					  }
				) > 0;
			}
		} else {
			status = presideObjectService.deleteData(
				  objectName   = "admin_notification_subscription"
				, filter       = {
					  topic         = arguments.topic
					, security_user = arguments.userId
				  }
			) > 0 ;
		}

		var subscribableTopics = notificationService.listTopics( userId=arguments.userId );
		var subscribedTopics   = presideObjectService.selectData(
			  objectName      = "admin_notification_subscription"
			, filter          = { security_user=arguments.userId, topic=subscribableTopics }
			, recordCountOnly = true
		);

		setAllNotifications( userId=arguments.userId, all=( ArrayLen( subscribableTopics ) == subscribedTopics ) );

		return status;
	}

}