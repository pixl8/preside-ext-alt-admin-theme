<!---@feature admin--->

<cfscript>
	event.include( "/css/admin/altadmintheme-v2/pages/login/" );

	loginProviders        = prc.loginProviders    ?: [];
	renderedProviders     = prc.renderedProviders ?: {};
	renderedProviderCount = 0;

	loginLogo        = getSetting( name="adminTheme.v2.loginLogo", defaultValue="" );
	loginDescription = translateResource( uri="cms:login.description", defaultValue="" );
</cfscript>

<cfoutput>
	<div class="p-login">
		<div class="p-login__header">
			<div class="p-login__header-logo">
				<img class="p-login__header-logo-image" src="#encodeForHTMLAttribute( loginLogo )#" alt="#encodeForHTMLAttribute( translateResource( 'cms:cms.title' ) )#" />
			</div>
			<cfif Len( Trim( loginDescription ) )>
				<div class="p-login__header-description">
					#loginDescription#
				</div>
			</cfif>
		</div>
		<div class="p-login__body">
			<cfif renderedProviders.count()>
				<cfloop array="#loginProviders#" index="i" item="provider">
					<cfif StructKeyExists( renderedProviders, provider )>
						<cfif renderedProviderCount gt 0>
							<hr>
						</cfif>
						#renderedProviders[ provider ]#
						<cfset renderedProviderCount++/>
					</cfif>
				</cfloop>
			<cfelse>
				<cf_adminui_alert type="danger" text="#translateResource( uri='cms:login.no.providers' )#" />
			</cfif>
		</div>
		<div class="p-login__footer">
			<div class="p-login__footer-forgotten">
				<a class="p-login__footer-forgotten-link" href="#event.buildAdminLink( linkTo='login.forgottenPassword' )#" class="pull-right">
					#translateResource( 'cms:login.forgotpw.link' )#
				</a>
			</div>
		</div>
	</div>
</cfoutput>
