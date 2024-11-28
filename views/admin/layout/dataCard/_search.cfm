<cfscript>
	placeholder = args.placeholder ?: translateResource( "admin.dataCard:search.placeholder" );
	value       = args.search      ?: "";
</cfscript>

<cfoutput>

<form x-target="cards pagination" action="#event.buildAdminLink( linkTo="datamanager.site_theme.cardListing" )#">

	<div class="card-search-box">

		<div class="row">

			<div class="col-md-12">

				<div class="card-search-box-bar">

					<label class="block clearfix" for="card-quick-search">

						<span class="block input-icon">
							<input type              = "text"
							       id                = "card-quick-search"
							       class             = "card-search-box-input form-control"
							       placeholder       = "#placeholder#"
							       value             = "#value#"
							       name              = "q"
							       autocomplete      = "off"
							       data-global-key   = "s"
							       @input.debounce   = "$el.form.requestSubmit()"
							       @search           = "$el.form.requestSubmit()"
							       @focus            = "$event.target.select()"
							>

							<i class="fa fa-search"></i>
						</span>

					</label>

				</div>

			</div>

		</div>

	</div>

</form>

</cfoutput>