<cfparam name="attributes.xs"     type="string" default="12" />
<cfparam name="attributes.sm"     type="string" default="" />
<cfparam name="attributes.md"     type="string" default="" />
<cfparam name="attributes.lg"     type="string" default="" />
<cfparam name="attributes.xl"     type="string" default="" />
<cfparam name="attributes.xxl"    type="string" default="" />
<cfparam name="attributes.align"  type="string" default="" />
<cfparam name="attributes.sticky" type="string" default="" /><!--- breakpoint from which the column sticks: xs (always), sm, md, lg, xl, xxl --->

<cfif thisTag.executionMode is "start">
	<cfscript>
		local.classes = ["c-grid__col", "c-grid__col--size-#encodeForHTMLAttribute( attributes.xs )#"];

		if ( Len(Trim(attributes.sm)) ) {
			local.classes.append("c-grid__col--size-sm-#encodeForHTMLAttribute( attributes.sm )#");
		}

		if ( Len(Trim(attributes.md)) ) {
			local.classes.append("c-grid__col--size-md-#encodeForHTMLAttribute( attributes.md )#");
		}

		if ( Len(Trim(attributes.lg)) ) {
			local.classes.append("c-grid__col--size-lg-#encodeForHTMLAttribute( attributes.lg )#");
		}

		if ( Len(Trim(attributes.xl)) ) {
			local.classes.append("c-grid__col--size-xl-#encodeForHTMLAttribute( attributes.xl )#");
		}

		if ( Len(Trim(attributes.xxl)) ) {
			local.classes.append("c-grid__col--size-2xl-#encodeForHTMLAttribute( attributes.xxl )#");
		}

		if ( Len(Trim(attributes.align)) ) {
			local.classes.append("c-grid__col--align-#encodeForHTMLAttribute( attributes.align )#");
		}

		// xs is the base size, so sticky="xs" sticks at every width, as xs sizes do
		local.stickyClasses = {
			  xs  = "c-grid__col--sticky"
			, sm  = "c-grid__col--sticky-sm"
			, md  = "c-grid__col--sticky-md"
			, lg  = "c-grid__col--sticky-lg"
			, xl  = "c-grid__col--sticky-xl"
			, xxl = "c-grid__col--sticky-2xl"
		};

		if ( StructKeyExists( local.stickyClasses, attributes.sticky ) ) {
			ArrayAppend( local.classes, local.stickyClasses[ attributes.sticky ] );
		}

		local.classString = ArrayToList(local.classes, " ");
	</cfscript>

	<cfoutput>
		<div class="#local.classString#">
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>