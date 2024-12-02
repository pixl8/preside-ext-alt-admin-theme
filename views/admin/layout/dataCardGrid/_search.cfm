<cfscript>
	objectName   = args.objectName   ?: "";
	searchAction = args.searchAction ?: event.buildAdminLink( objectName=objectName );
	placeholder  = args.placeholder  ?: translateResource( "admin.dataCardGrid:search.placeholder" );
	value        = args.search       ?: "";
</cfscript>

<cfoutput>
	<form action="#searchAction#" x-target.push="cards pagination" x-headers="{ 'X-Requested-With': 'XMLHttpRequest' }">

		<input type="hidden" name="id" value="#objectName#" />

		<div class="card-search-box">

			<div class="row">

				<div class="col-md-12">

					<div class="card-search-box-bar">

						<label class="block clearfix" for="card-quick-search">

							<span class="block input-icon">
								<input type            = "text"
								       id              = "card-quick-search"
								       class           = "card-search-box-input form-control"
								       placeholder     = "#placeholder#"
								       value           = "#value#"
								       name            = "q"
								       autocomplete    = "off"
								       data-global-key = "s"
								       @input.debounce = "$el.form.requestSubmit()"
								       @search         = "$el.form.requestSubmit()"
								       @focus          = "$el.select()"
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