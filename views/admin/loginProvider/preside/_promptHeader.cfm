<!---@feature admin--->
<cfscript>
	postLoginUrl           = args.postLoginUrl ?: "";
	message                = rc.message ?: "";
	isRememberMeEnabled    = IsTrue( args.isRememberMeEnabled ?: "" );
	rememberMeExpiryInDays = Val( args.rememberMeExpiryInDays ?: 30 );
	loginProviderPosition  = Val( args.position ?: "" );

	if ( rememberMeExpiryInDays == 1 ) {
		rememberMeLabel = translateResource( uri="cms:login.remember.me.single.day.label" );
	} else {
		rememberMeLabel = translateResource( uri="cms:login.remember.me.label", data=[ rememberMeExpiryInDays ] );
	}
</cfscript>
<cfoutput>
	<div class="p-login__body-notification">
		<cfswitch expression="#message#">
			<cfcase value="LOGIN_FAILED">
				<cf_adminui_alert type="danger" text="#translateResource( 'cms:login.failed.error' )#" />
			</cfcase>
			<cfcase value="FIRST_TIME_USER_SETUP">
				<cf_adminui_alert type="success" text="#translateResource( 'cms:login.user.setup.confirmation' )#" />
			</cfcase>
			<cfcase value="PASSWORD_RESET">
				<cf_adminui_alert type="success" text="#translateResource( 'cms:login.password.reset.confirmation' )#" />
			</cfcase>
		</cfswitch>
	</div>

	<cfif !Len( Trim( message ) ) && loginProviderPosition gt 1>
		<hr class="p-login__body-divider" />
	</cfif>

	<div class="p-login__body-form">
		<cf_adminui_form method="post" action="#event.buildAdminLink( linkto="login.login" )#">
			<cf_adminui_form_fields>
				<cf_adminui_form_input
					name  = "postLoginUrl"
					type  = "hidden"
					value = "#postLoginUrl#"
				/>

				<cf_adminui_form_input
					name        = "loginId"
					type        = "text"
					icon        = "user"
					placeholder = "#translateResource( 'cms:login.username.placeholder' )#"
					value       = "#event.getValue( name='loginId', defaultValue='' )#"
					autofocus   = "true"
				/>

				<cf_adminui_form_input
					name             = "password"
					type             = "password"
					id               = "password"
					placeholder      = "#translateResource( 'cms:login.password.placeholder' )#"
					icon             = "#isFeatureEnabled( 'passwordVisibilityToggle' ) ? 'eye' : 'lock'#"
					toggleVisibility = "#isFeatureEnabled( 'passwordVisibilityToggle' )#"
				/>

				<cfif isRememberMeEnabled>
					<cf_adminui_form_input_checkbox
						name  = "rememberme"
						label = "#rememberMeLabel#"
						skin  = "white"
					/>
				</cfif>
			</cf_adminui_form_fields>

			<cf_adminui_form_actions>
				<cf_adminui_button
					text      = "#translateResource( 'cms:login.button' )#"
					icon      = "log-in"
					type      = "submit"
					display   = "block"
					textAlign = "center"
					skin      = "secondary"
				/>
			</cf_adminui_form_actions>
		</cf_adminui_form>
	</div>

	<div class="p-login__body-forgotten">
		<a class="p-login__body-forgotten-link" href="#event.buildAdminLink( linkTo='login.forgottenPassword' )#" class="pull-right">
			#translateResource( 'cms:login.forgotpw.link' )#
		</a>
	</div>
</cfoutput>
