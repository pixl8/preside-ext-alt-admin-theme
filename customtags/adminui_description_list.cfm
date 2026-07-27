<cfparam name="attributes.items" type="array" default="#[]#" />

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<dl class="c-description-list">
			<cfloop array="#attributes.items#" index="item">
				<cfif structKeyExists( item, "label" ) AND structKeyExists( item, "value" )>
					<div class="c-description-list__item">
						<dt class="c-description-list__item-label">
							#encodeForHTML( item.label )#
						</dt>
						<dd class="c-description-list__item-value">
							#item.value#
						</dd>
					</div>
				</cfif>
			</cfloop>
		</dl>
	</cfoutput>
</cfif>