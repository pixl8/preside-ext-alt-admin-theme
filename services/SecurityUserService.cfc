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

}