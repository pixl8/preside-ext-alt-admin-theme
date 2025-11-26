<cfparam name="args.variant"    type="string"   default="primary">
<cfparam name="args.id"         type="string"   default="">
<cfparam name="args.label"      type="string"   default="">
<cfparam name="args.icon"       type="string"   default="">
<cfparam name="args.href"       type="string"   default="">
<cfparam name="args.target"     type="string"   default="">
<cfparam name="args.type"       type="string"   default="button">
<cfparam name="args.disabled"   type="boolean"  default="false">
<cfparam name="args.ariaLabel"  type="string"   default="">

<cfset hasIcon = len(args.icon)>
<cfset hasLabel = len(args.label)>
<cfset ariaLabel = len(args.ariaLabel) ? args.ariaLabel : args.label>

<cfoutput>
  <cfif len(trim(args.href))>
    <a
      class="btn btn-#args.variant#"
      <cfif len(args.id)>
        id="#encodeForHtmlAttribute(args.id)#"
      </cfif>
      href="#encodeForHtmlAttribute(args.href)#"
      <cfif len(args.target)>
        target="#encodeForHtmlAttribute(args.target)#"
        <cfif args.target EQ "_blank">
          rel="noopener noreferrer"
        </cfif>
      </cfif>
    >
      <cfif hasIcon>
        <i class="fa fa-#encodeForHtml(args.icon)#" aria-hidden="true"></i>
      </cfif>
      <cfif hasLabel>
        #encodeForHtml(args.label)#
      </cfif>
    </a>
  <cfelse>
    <button
      class="btn btn-#args.variant#"
      <cfif len(args.id)>
        id="#encodeForHtmlAttribute(args.id)#"
      </cfif>
      type="#encodeForHtmlAttribute(args.type)#"
      <cfif args.disabled>disabled</cfif>
    >
      <cfif hasIcon>
        <i class="fa fa-#encodeForHtml(args.icon)#" aria-hidden="true"></i>
      </cfif>
      <cfif hasLabel>
        #encodeForHtml(args.label)#
      </cfif>
    </button>
  </cfif>
</cfoutput>
