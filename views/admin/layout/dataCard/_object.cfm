<cfscript>
	if ( !event.isAjax() ) {
		event
			.include( assetId="/css/admin/altadmintheme/dataCard/" )
			.include( assetId="alpine"     , group="top" )
			.include( assetId="alpine-ajax", group="top" )
		;
	}
</cfscript>

<cfoutput>
	<div class="container">

		<cfif not event.isAjax()>
			#renderViewlet( event="admin.layout.dataCard._search", args=args )#
		</cfif>

		#renderViewlet( event="admin.layout.dataCard._list"  , args=args )#

		#renderViewlet( event="admin.layout.dataCard._footer", args=args )#

	</div>
</cfoutput>