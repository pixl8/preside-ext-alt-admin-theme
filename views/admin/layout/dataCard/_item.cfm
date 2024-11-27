<cfscript>
	cardExtraClass    = args.cardExtraClass    ?: "";
	cardHeaderLabel   = args.cardHeaderLabel   ?: "";
	cardHeaderOptions = args.cardHeaderOptions ?: "";
	cardBody          = args.cardBody          ?: "";
	cardFooter        = args.cardFooter        ?: "";
</cfscript>

<cfoutput>

	<div class="card-listing-item">

		<div class="card #cardExtraClass#">

			<cfif !isEmptyString( cardHeaderLabel ) and !isEmptyString( cardHeaderOptions )>

				<div class="card-header">

					<cfif !isEmptyString( cardHeaderLabel )>
						<h6 class="card-header-label">#cardHeaderLabel#</h6>
					</cfif>

					<cfif !isEmptyString( cardHeaderOptions )>
						<div class="card-header-options">
							#cardHeaderOptions#
						</div>
					</cfif>

				</div>

			</cfif>

			<cfif !isEmptyString( cardBody )>
				<div class="card-body">
					#cardBody#
				</div>
			</cfif>

			<cfif !isEmptyString( cardFooter )>
				<div class="card-footer">
					#cardFooter#
				</div>
			</cfif>

		</div>

	</div>

</cfoutput>