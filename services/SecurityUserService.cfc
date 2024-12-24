/**
 * @presideService true
 * @singleton      true
 */
component {

	property name="actions"                   inject="coldbox:setting:submissions.actions";
	property name="rulesEngineFilterService"  inject="RulesEngineFilterService";
	property name="formsService"              inject="FormsService";
	property name="submissionActivityService" inject="SubmissionActivityService";

	public any function init() {
		return this;
	}

	public query function getUser(
		  required string id
		,          array  selectFields = []
	) {
		return $getPresideObject( "security_user" ).selectData(
			  id           = arguments.id
			, selectFields = arguments.selectFields
		);
	}

	public boolean function activateUser( required string id ) {
		return $getPresideObject( "security_user" ).updateData(
			  filter       = "id = :id and active = :active"
			, filterParams = {
				  id     = arguments.id
				, active = false
			  }
			, data         = {
				active = true
			  }
		) > 0;
	}

	public boolean function deactivateUser( required string id ) {
		return $getPresideObject( "security_user" ).updateData(
			  filter       = "id = :id and active = :active"
			, filterParams = {
				  id     = arguments.id
				, active = true
			  }
			, data         = {
				active = false
			  }
		) > 0;
	}

}