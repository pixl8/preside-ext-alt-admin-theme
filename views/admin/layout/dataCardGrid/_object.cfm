<cfscript>
	showSearch = IsTrue( args.showSearch ?: true ) && not event.isAjax();
</cfscript>
<cfoutput>
	<div class="container">

		<cfif showSearch >
			#renderViewlet( event="admin.layout.DataCardGrid._search", args=args )#
		</cfif>

		#renderViewlet( event="admin.layout.DataCardGrid._list"  , args=args )#

		#renderViewlet( event="admin.layout.DataCardGrid._footer", args=args )#

	</div>
</cfoutput>