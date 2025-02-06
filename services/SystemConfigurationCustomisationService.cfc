/**
 * @presideService true
 * @singleton      true
 */
component {

	public any function init() {
		return this;
	}

	public any function runCustomisation(
		  required string category
		, required string action
		,          struct args          = {}
		,          string defaultAction = ""
		,          any    defaultResult
	) {
		var event = "";

		if ( !$helpers.isEmptyString( arguments.category ) ) {
			event = getCustomisationEventForCategory( arguments.category, arguments.action );
		}

		if ( $helpers.isEmptyString( event ) && $getColdbox().handlerExists( arguments.defaultAction ) ) {
			event = arguments.defaultAction;
		}

		if ( !$helpers.isEmptyString( event ) ) {
			return $getColdbox().runEvent(
				  event          = event
				, private        = true
				, prePostExempt  = true
				, eventArguments = { args=arguments.args }
			);
		} else if ( StructKeyExists( arguments, "defaultResult" ) ) {
			return arguments.defaultResult;
		}
	}


	public string function getCustomisationEventForCategory(
		  required string category
		, required string action
	) {
		var event = "admin.sysConfigManager.#arguments.category#.#arguments.action#";

		if ( !$getColdbox().handlerExists( event ) ) {
			event = "admin.sysConfigManager.#arguments.action#";
		}

		if ( !$getColdbox().handlerExists( event ) ) {
			event = "";
		}

		return event;
	}

}