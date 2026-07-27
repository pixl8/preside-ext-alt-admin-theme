<cfscript>
	displayPageHeader         = IsTrue( prc.displayPageHeader ?: true );
	title                     = prc.pageTitle             ?: "";
	subTitle                  = prc.pageSubTitle          ?: "";
	topRightButtonActions     = prc.topRightButtonActions ?: [];
	prc.topRightButtonActions = [];

	hasActions = ArrayLen( topRightButtonActions );
	hasTitle   = Len( Trim( title ) );
	hasContent = hasTitle || Len( Trim( subTitle ) ) || hasActions;
</cfscript>

<cfif displayPageHeader && hasContent>
	<cfoutput>
		<header class="s-main__header">
			<div class="s-main__header-title-subtitle">
				<h1 class="s-main__header-title">#title#</h1>
				<cfif Len( Trim( subTitle ) )>
					<div class="s-main__header-subtitle">#subTitle#</div>
				</cfif>
			</div>
			<cfif hasActions>
				<div class="s-main__header-actions">
					#renderView( view="/admin/layout/structure/main/header/actions", args={ actions=topRightButtonActions } )#
				</div>
			</cfif>
		</header>
	</cfoutput>
</cfif>
