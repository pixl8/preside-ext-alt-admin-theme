<cfscript>
	cardExtraClass    = args.cardExtraClass    ?: "";
	cardHeaderOptions = args.cardHeaderOptions ?: "";
	cardBody          = args.cardBody          ?: "";
	cardFooter        = args.cardFooter        ?: "";

	cardHeaderLabel   = renderView(
		  view="admin/layout/dataCard/_cardHeaderLabel"
		, args={
			  icon  = args.cardHeaderIcon  ?: ""
			, label = args.cardHeaderLabel ?: ""
		  }
	);

	cardHeaderOptions = renderView(
		  view = "admin/layout/dataCard/_cardHeaderOptions"
		, args = {
			options = args.cardHeaderOptions ?: []
		  }
	);

	cardBody          = renderView(
		  view = "admin/layout/dataCard/_cardBody"
		, args = {
			body = args.cardBody ?: ""
		  }
	);
</cfscript>

<cfoutput>
	<div class="card-listing-item">

		<div class="card #cardExtraClass#">

			<cfif not isEmptyString( cardHeaderLabel ) or not isEmptyString( cardHeaderOptions )>

				<div class="card-header">

					<cfif not isEmptyString( cardHeaderLabel )>
						<h6 class="card-header-label">#cardHeaderLabel#</h6>
					</cfif>

					<cfif not isEmptyString( cardHeaderOptions )>
						<div class="card-header-options">
							#cardHeaderOptions#
						</div>
					</cfif>

				</div>

			</cfif>

			<cfif not isEmptyString( cardBody )>
				<div class="card-body">
					#cardBody#
				</div>
			</cfif>

			<cfif not isEmptyString( cardFooter )>
				<div class="card-footer">
					#cardFooter#
				</div>
			</cfif>

		</div>

	</div>
</cfoutput>