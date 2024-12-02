<cfscript>
	showResultsCount   = args.showResultsCount   ?: true;
	showPagination     = args.showPagination     ?: true;
	showResultsPerPage = args.showResultsPerPage ?: true;

	totalResults         = args.totalResults         ?: 0;
	totalPages           = args.totalPages           ?: 0;
	currentPage          = args.currentPage          ?: 1;

	recordRows = ArrayLen( args.cardItems ?: [] );
	maxRows    = args.maxRows    ?: getSetting( name="adminTheme.defaults.dataCardGrid.resultsPerPage", defaultValue=12 );
	offsetRows = args.offsetRows ?: 0;
	startRow   = args.startRow   ?: 1;
	endRow     = currentPage == totalPages ? totalResults : ( startRow + maxRows - 1 + offsetRows );

	hasPreviousPage = currentPage > 1;
	hasNextPage     = currentPage < totalPages;

	resultsPerPageOptions = getSetting( name="adminTheme.defaults.dataCardGrid.resultsPerPageOptions", defaultValue=[ 6, 12, 24, 48 ] );

	objectName = args.objectName ?: "";
	search     = args.search     ?: "";

	paginationLink       = args.paginationLink       ?: event.buildAdminLink( objectName=objectName, queryString="q=#search#&len=#maxRows#&offset=#offsetRows#" );
	resultsPerPageAction = args.resultsPerPageAction ?: event.buildAdminLink( objectName=objectName );
</cfscript>

<cfoutput>

	<div id="pagination" class="card-listing-footer">

		<cfif showResultsCount>

			<div class="card-listing-footer-results-count">
				#translateResource( uri="admin.dataCardGrid:pagination.info.label", data=[ startRow, endRow, totalResults ] )#
			</div>

		</cfif>

		<cfif showPagination>

			<div class="card-listing-footer-pagination">
				<nav aria-label="Page navigation">
					<ul class="pagination">
						<li#( hasPreviousPage ? '' : ' class="disabled"' )#>
							<a href="#( hasPreviousPage ? ( paginationLink & "&page=#( currentPage - 1 )#" ) : "" )#" aria-label="Previous" x-target="cards pagination" x-headers="{ 'X-Requested-With': 'XMLHttpRequest' }">
								<span aria-hidden="true">#translateResource( uri="admin.dataCardGrid:pagination.previous.label" )#</span>
							</a>
						</li>

						<cfloop index="i" from="1" to="#totalPages#">
							<li#( i == currentPage ? ' class="active"' : '' )#><a href="#( paginationLink & "&page=#i#" )#" x-target.push="cards pagination" x-headers="{ 'X-Requested-With': 'XMLHttpRequest' }">#i#</a></li>
						</cfloop>

						<li#( hasNextPage ? '' : ' class="disabled"' )#>
							<a href="#( hasNextPage ? ( paginationLink & "&page=#( currentPage + 1 )#" ) : "" )#" aria-label="Next" x-target="cards pagination" x-headers="{ 'X-Requested-With': 'XMLHttpRequest' }">
								<span aria-hidden="true">#translateResource( uri="admin.dataCardGrid:pagination.next.label" )#</span>
							</a>
						</li>
					</ul>
				</nav>
			</div>

		</cfif>

		<cfif showResultsPerPage>

			<form action="#resultsPerPageAction#" x-target.push="cards pagination"  x-headers="{ 'X-Requested-With': 'XMLHttpRequest' }">

				<input type="hidden" name="id" value="#objectName#" />
				<input type="hidden" name="q"  value="#search#" />

				<div class="card-listing-footer-results-per-page">
					#translateResource( uri="admin.dataCardGrid:pagination.length.label" )#

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