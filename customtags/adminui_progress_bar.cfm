<cfparam name="attributes.progress" type="numeric" default="0" />
<cfparam name="attributes.label"    type="string"  default="" />
<cfparam name="attributes.value"    type="string"  default="" />
<cfparam name="attributes.skin"     type="string"  default="primary" />

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.baseClass  = "c-progress-bar";
		local.classNames = local.baseClass;

		if ( Len( attributes.skin ) ) {
			local.classNames &= " #local.baseClass#--skin-#encodeForHTMLAttribute( attributes.skin )#";
		}

		local.percent = Max( 0, Min( attributes.progress, 100 ) );
	</cfscript>

	<cfoutput>
		<div class="#local.classNames#">
			<div class="#local.baseClass#__track">
				<div class="#local.baseClass#__fill" role="progressbar" style="width:#local.percent#%;" aria-valuenow="#local.percent#" aria-valuemin="0" aria-valuemax="100"></div>
			</div>

			<cfif Len( attributes.label ) || Len( attributes.value )>
				<div class="#local.baseClass#__footer">
					<cfif Len( attributes.label )>
						<span class="#local.baseClass#__label">#encodeForHTML( attributes.label )#</span>
					</cfif>
					<cfif Len( attributes.value )>
						<span class="#local.baseClass#__value">#encodeForHTML( attributes.value )#</span>
					</cfif>
				</div>
			</cfif>
		</div>
	</cfoutput>
	<cfexit method="exitTag">
</cfif>
