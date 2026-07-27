<cfscript>
	crumbs  = event.getAdminBreadCrumbs();
	nCrumbs = ArrayLen( crumbs );
</cfscript>

<cfoutput>
	<nav class="s-breadcrumbs" aria-label="breadcrumb">
		<ol class="s-breadcrumbs__items">
			<cfloop from="1" to="#nCrumbs#" index="i">
				<li class="s-breadcrumbs__item"<cfif i eq nCrumbs> aria-current="page"</cfif>>
					<cfif i eq nCrumbs>
						<span class="s-breadcrumbs__item-label">#crumbs[i].title#</span>
					<cfelse>
						<a class="s-breadcrumbs__item-link" href="#crumbs[i].link#"<cfif i eq nCrumbs-1> data-global-key="u"</cfif>>#crumbs[i].title#</a>
					</cfif>
				</li>
				<cfif i lt nCrumbs>
					<li class="s-breadcrumbs__item" aria-hidden="true">
						<cf_adminui_icon class="s-breadcrumbs__item-divider" name="chevron-right" strokeWidth="2"/>
					</li>
				</cfif>
			</cfloop>
		</ol>
	</nav>
</cfoutput>