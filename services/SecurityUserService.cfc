/**
 * @presideService true
 * @singleton      true
 */
component {

	property name="presideObjectService" inject="PresideObjectService";

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

	public boolean function activateUser( required string userId ) {
		return presideObjectService.updateData(
			  objectName   = "security_user"
			, filter       = "id = :id and active = :active"
			, filterParams = {
				  id     = arguments.userId
				, active = false
			  }
			, data         = {
				active = true
			  }
		) > 0;
	}

	public boolean function deactivateUser( required string userId ) {
		return presideObjectService.updateData(
			  objectName   = "security_user"
			, filter       = "id = :id and active = :active"
			, filterParams = {
				  id     = arguments.userId
				, active = true
			  }
			, data         = {
				active = false
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

	public boolean function addGroup(
		  required string groupId
		, required string userId
	) {
		var prop       = presideObjectService.getObjectProperty( "security_user", "groups" );
		var relatedVia = prop.relatedVia ?: "";

		if ( !$helpers.isEmptyString( relatedVia ) ) {
			try {
				presideObjectService.insertData(
					  objectName = relatedVia
					, data       = { security_group=arguments.groupId, security_user=arguments.userId }
				);

				return true;
			} catch ( any e ) {}
		}

		return false;
	}

	public boolean function deleteGroup(
		  required string groupId
		, required string userId
	) {
		var prop       = presideObjectService.getObjectProperty( "security_user", "groups" );
		var relatedVia = prop.relatedVia ?: "";

		if ( !$helpers.isEmptyString( relatedVia ) ) {
			return presideObjectService.deleteData(
				  objectName = relatedVia
				, filter     = { security_group=arguments.groupId, security_user=arguments.userId }
			) > 0;
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

	public numeric function getSubscriptionCount( required string userId=$getAdminLoggedInUserId() ) {
		return presideObjectService.selectData(
			  objectName      = "admin_notification_subscription"
			, filter          = { security_user=arguments.userId }
			, recordCountOnly = true
		);
	}

	public boolean function saveSubscription(
		  required string  topic
		,          string  userId       = $getAdminLoggedInUserId()
		,          boolean notification = true
		,          boolean email        = false
	) {
		if ( arguments.notification ) {
			var subscription = getSubscription( topic=arguments.topic, userId=arguments.userId, selectFields=[ "topic_subscription_id" ] );

			if ( $helpers.isEmptyString( subscription.topic_subscription_id ?: "" ) ) {
				return Len( presideObjectService.insertData(
					  objectName   = "admin_notification_subscription"
					, data         = {
						  security_user           = arguments.userId
						, topic                   = arguments.topic
						, get_email_notifications = arguments.email
					  }
				) ) > 0;
			} else {
				return presideObjectService.updateData(
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
			return presideObjectService.deleteData(
				  objectName   = "admin_notification_subscription"
				, filter       = {
					  topic         = arguments.topic
					, security_user = arguments.userId
				  }
			) > 0 ;
		}
	}

}