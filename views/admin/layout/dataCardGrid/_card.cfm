<cfscript>
	cardLink          = args.cardLink          ?: "";
	cardExtraClass    = args.cardExtraClass    ?: "";
	cardHeaderOptions = args.cardHeaderOptions ?: "";
	cardBody          = args.cardBody          ?: "";
	cardFooter        = args.cardFooter        ?: "";

	cardHeaderLabel   = renderView(
		  view="admin/layout/dataCardGrid/_cardHeaderLabel"
		, args={
			  icon  = args.cardHeaderIcon  ?: ""
			, label = args.cardHeaderLabel ?: ""
			, link  = cardLink
		  }
	);

	cardHeaderOptions = renderView(
		  view = "admin/layout/dataCardGrid/_cardHeaderOptions"
		, args = {
			options = args.cardHeaderOptions ?: []
		  }
	);

	cardBody          = renderView(
		  view = "admin/layout/dataCardGrid/_cardBody"
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
				<div class="card-body<cfif Len( cardLink )> card-body-with-link</cfif>">
					<cfif Len( cardLink )><a href="#cardLink#" class="card-body-link"></cfif>
						#cardBody#
					<cfif Len( cardLink )></a></cfif>
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