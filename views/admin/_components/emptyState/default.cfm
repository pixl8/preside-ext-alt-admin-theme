<cfoutput>
  <div class="c-empty-state">
    <cfif len(args.icon)>
      <i class="c-empty-state__icon fa fa-#encodeForHtml(args.icon)#"></i>
    </cfif>
    <cfif len(args.title)>
      <div class="c-empty-state__title">
        #args.title#
      </div>
    </cfif>
    <cfif len(args.description)>
      <div class="c-empty-state__description">
        #args.description#
      </div>
    </cfif>
    <cfif len(args.buttonLabel) && len(args.buttonLink)>
      <div class="c-empty-state__button">
        #renderView(
          view = "/admin/_components/button",
          args = {
            label = "#args.buttonLabel#",
            href = "#args.buttonLink#",
            target = "#args.buttonTarget#",
            icon = "#args.buttonIcon#",
          }
        )#
      </div>
    </cfif>
  </div>
</cfoutput>
