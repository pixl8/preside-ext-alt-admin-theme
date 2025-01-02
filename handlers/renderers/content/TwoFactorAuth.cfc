component {

	property name="loginService" inject="LoginService";

	private string function default( event, rc, prc, args={} ){
		if ( loginService.isTwoFactorAuthenticationEnabled() ) {
			var status = isTrue( args.data ?: "" ) ? "enabled" : "disabled";

			return translateResource( uri="preside-objects.security_user:infocard.two_step_auth_key_in_use.#status#" );
		}

		return "";
	}

}