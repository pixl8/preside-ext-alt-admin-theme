<cfoutput>
	<div class="container">

		<cfif not event.isAjax()>
			#renderViewlet( event="admin.layout.DataCardGrid._search", args=args )#
		</cfif>

		#renderViewlet( event="admin.layout.DataCardGrid._list"  , args=args )#

		#renderViewlet( event="admin.layout.DataCardGrid._footer", args=args )#

	</div>
</cfoutput>