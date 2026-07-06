<cfscript>
	// admin.layout.environmentBanner handler always renders this view path. When the
	// v2 layout is active, delegate to the v2 partial (s-environment-banner markup, styled
	// by the altadmintheme-v2 bundle); otherwise fall back to the core banner markup.
	useV2 = getSetting( name="adminTheme.layout", defaultValue="v1" ) == "v2";

	iconClass = args.iconClass ?: "";
	cssClass  = args.cssClass  ?: "alert-danger";
	message   = args.message   ?: "";
</cfscript>

<cfif useV2>
	<cfoutput>#renderView( view="/admin/layout/structure/environmentBanner", args=args )#</cfoutput>
<cfelse>
	<cfoutput>
		<cfif Len( Trim( message ) )>
			<div class="environment-banner text-center alert #cssClass#">
				<cfif Len( Trim( iconClass ) )>
					<i class="fa fa-fw #iconClass#"></i>
				</cfif>
				#translateResource( uri=message, defaultValue=message )#
			</div>
		</cfif>
	</cfoutput>
</cfif>
