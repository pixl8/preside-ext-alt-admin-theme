component {
	property name="sqlRunner" inject="sqlRunner";

	private boolean function isEnabled() {
		return isFeatureEnabled( "twoFactorAuthentication" );
	}

	private void function runAsync() {
		var dsn = getPresideObject( "security_user" ).getDsn();

		sqlRunner.runSql(
			  dsn = dsn
			, sql = "
				UPDATE
					psys_security_user
				SET
					two_step_auth_key = NULL, two_step_auth_key_created = NULL, two_step_auth_key_in_use = 0
				WHERE
					( two_step_auth_enabled IS NULL OR two_step_auth_enabled = 0 ) AND two_step_auth_key_in_use = 1
			"
		);
	}
}