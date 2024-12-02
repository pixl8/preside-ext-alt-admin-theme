<cfscript>
	showAddNewRecordCard = args.showAddNewRecordCard ?: false;
	addNewRecordCardBody = args.addNewRecordCardBody ?: "";
	cardItems            = args.cardItems            ?: [];
</cfscript>

<cfoutput>
	<div id="cards" class="card-listing">

		<cfif showAddNewRecordCard>

			<div class="card-listing-item">
				<div class="card mod-new-record">
					<div class="card-body">
						<cfif !isEmptyString( addNewRecordCardBody )>
							#addNewRecordCardBody#
						<cfelse>
							#renderView( view="admin/layout/dataCardGrid/_cardAddNew", args=args )#
						</cfif>
					</div>
				</div>
			</div>

		</cfif>

		<cfloop array="#cardItems#" item="cardItem">

			#renderView( view="admin/layout/dataCardGrid/_card", args=cardItem )#

		</cfloop>

	</div>
</cfoutput>