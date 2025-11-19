<cfoutput>
  <div class="c-empty-state">
    <cfif len(args.icon)>
      <i class="c-empty-state__icon fa fa-#args.icon#"></i>
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
        <a href="#args.buttonLink#" class="btn btn-primary">
          <cfif len(args.buttonIcon)>
            <i class="fa fa-#args.buttonIcon#"></i>
          </cfif>
          #args.buttonLabel#
        </a>
      </div>
    </cfif>
  </div>
</cfoutput>
