<cfscript>
	showResultsCount   = args.showResultsCount   ?: true;
	showPagination     = args.showPagination     ?: true;
	showResultsPerPage = args.showResultsPerPage ?: true;

	totalResults       = args.totalResults       ?: 0;
	totalPages         = args.totalPages         ?: 0;
	currentPage        = args.currentPage        ?: 1;
	paginationLink     = args.paginationLink     ?: "";
	resultsPerPageLink = args.resultsPerPageLink ?: "";

	recordRows = ArrayLen( args.cardItems ?: [] );
	maxRows    = args.maxRows    ?: getSetting( name="siteTheme.defaults.dataCard.resultsPerPage", defaultValue=12 );
	offsetRows = args.offsetRows ?: 0;
	startRow   = args.startRow   ?: 1;
	endRow     = currentPage == totalPages ? totalResults : ( startRow + maxRows - 1 + offsetRows );

	hasPreviousPage = currentPage > 1;
	hasNextPage     = currentPage < totalPages;

	resultsPerPageOptions = getSetting( name="siteTheme.defaults.dataCard.resultsPerPageOptions", defaultValue=[ 6, 12, 24, 48 ] );

	search = args.search ?: "";
</cfscript>

<cfoutput>

	<div id="pagination" class="card-listing-footer">

		<cfif showResultsCount>

			<div class="card-listing-footer-results-count">
				#translateResource( uri="admin.dataCard:pagination.info.label", data=[ startRow, endRow, totalResults ] )#
			</div>

		</cfif>

		<cfif showPagination>

			<div class="card-listing-footer-pagination">
				<nav aria-label="Page navigation">
					<ul class="pagination">
						<li#( hasPreviousPage ? '' : ' class="disabled"' )#>
							<a href="#( hasPreviousPage ? ( paginationLink & "&page=#( currentPage - 1 )#" ) : "" )#" aria-label="Previous">
								<span aria-hidden="true">#translateResource( uri="admin.dataCard:pagination.previous.label" )#</span>
							</a>
						</li>

						<cfloop index="i" from="1" to="#totalPages#">
							<li#( i == currentPage ? ' class="active"' : '' )#><a x-target="cards pagination" href="#( paginationLink & "&page=#i#" )#">#i#</a></li>
						</cfloop>

						<li#( hasNextPage ? '' : ' class="disabled"' )#>
							<a href="#( hasNextPage ? ( paginationLink & "&page=#( currentPage + 1 )#" ) : "" )#" aria-label="Next">
								<span aria-hidden="true">#translateResource( uri="admin.dataCard:pagination.next.label" )#</span>
							</a>
						</li>
					</ul>
				</nav>
			</div>

		</cfif>

		<cfif showResultsPerPage>

			<form x-target="cards pagination" action="#resultsPerPageLink#">
				<input type="hidden" name="q" value="#search#" />

				<div class="card-listing-footer-results-per-page">
					#translateResource( uri="admin.dataCard:pagination.length.label" )#
					<select name="len" size="1" @change="$el.form.requestSubmit()">
						<cfloop index="i" item="option" array="#resultsPerPageOptions#">
							<option#( option == maxRows ? ' selected' : '' )# value="#option#">#option#</option>
						</cfloop>
					</select>
				</div>

			</form>

		</cfif>

	</div>

</cfoutput>