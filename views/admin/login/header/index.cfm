<!---@feature admin--->

<cfscript>
	event.include( "/css/admin/altadmintheme-modern/pages/login/" );

	loginProviders        = prc.loginProviders    ?: [];
	renderedProviders     = prc.renderedProviders ?: {};
	renderedProviderCount = 0;
</cfscript>

<cfoutput>
	<div class="p-login">
		<div class="p-login__header">
			<div class="p-login__header-logo" role="img" aria-label="#encodeForHTMLAttribute( translateResource( 'cms:cms.title' ) )#"></div>
			<div class="p-login__header-description">
				#translateResource( "cms:login.description" )#
			</div>
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
	</div>
</cfoutput>
