<cfoutput>
	<div class="p-design-system-entry">
		<section class="p-design-system-entry__section">
			<header class="p-design-system-entry__section-header">
				<h2 class="p-design-system-entry__section-header-title">
					01. Overview
				</h2>
			</header>
			<div class="p-design-system-entry__section-body">
				<article class="p-design-system-entry__article">
					<div class="p-design-system-entry__article-body">
						<p>
							The <strong>Image Popup</strong> component displays an image-focused modal dialog with a title, description, and optional action button. It’s ideal for presenting visual highlights, product previews, or promotional content that complements a call to action.
						</p>
						<p>
							The popup can be opened programmatically and includes a built-in close button for accessibility and ease of use.
						</p>
					</div>
				</article>
			</div>
		</section>
		<section class="p-design-system-entry__section">
			<header class="p-design-system-entry__section-header">
				<h2 class="p-design-system-entry__section-header-title">
					02. Parameters
				</h2>
			</header>
			<div class="p-design-system-entry__section-body">
				<article class="p-design-system-entry__article">
					<div class="p-design-system-entry__article-body">
						<table class="c-styleguide-table">
							<thead>
								<tr>
									<th>Parameter</th>
									<th>Type</th>
									<th>Default</th>
									<th>Required</th>
									<th>Description</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><code>id</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>Yes</td>
									<td>Unique identifier for the popup’s <code>&lt;dialog&gt;</code> element. Used to open or close the popup via JavaScript.</td>
								</tr>
								<tr>
									<td><code>closeLabel</code></td>
									<td>String</td>
									<td><code>"Close"</code></td>
									<td>No</td>
									<td>Accessible label (used in <code>aria-label</code>) for the close button.</td>
								</tr>
								<tr>
									<td><code>title</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Main heading text displayed inside the popup.</td>
								</tr>
								<tr>
									<td><code>description</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Short supporting text displayed below the title.</td>
								</tr>
								<tr>
									<td><code>image</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Path or URL of the main image shown at the top of the popup.</td>
								</tr>
								<tr>
									<td><code>imageAlt</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Alternative text for the popup image (for accessibility).</td>
								</tr>
								<tr>
									<td><code>buttonLabel</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Text label for the popup’s action button.</td>
								</tr>
								<tr>
									<td><code>buttonIcon</code></td>
									<td>String</td>
									<td><code>"plus"</code></td>
									<td>No</td>
									<td>Optional icon name (Font Awesome, without <code>fa-</code>) displayed in the action button.</td>
								</tr>
								<tr>
									<td><code>buttonLink</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>URL that the action button links to.</td>
								</tr>
								<tr>
									<td><code>buttonTarget</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Optional target attribute for the action button (e.g. <code>_blank</code>).</td>
								</tr>
							</tbody>
						</table>
					</div>
				</article>
			</div>
		</section>
		<section class="p-design-system-entry__section">
			<header class="p-design-system-entry__section-header">
				<h2 class="p-design-system-entry__section-title">03. Demo</h2>
			</header>
			<div class="p-design-system-entry__section-body">
				<article class="p-design-system-entry__article">
					<div class="p-design-system-entry__article-body">
						#renderView(
							  view="/admin/_components/imagePopup"
							, args={
								  id          = "design-system-demo"
								, closeLabel  = "Close popup"
								, title       = "Vimeo integration now available"
								, description = "Add Vimeo videos as data sources to expand your assistant’s knowledge. Perfect for showcasing tutorials, talks, or media-based content."
								, image       = "#event.buildLink( systemStaticAsset="/extension/preside-ext-alt-admin-theme/assets/images/design-system/components/image-popup/sample-01.jpg" )#"
								, imageAlt    = "A woman using headphones and microphone to record a podcast indoors."
								, buttonLabel = "Set up Vimeo"
								, buttonLink  = "##"
							}
						)#

						#renderView(
							  view = "/admin/_components/button"
							, args = {
								  id = "design-system-demo-open-button"
								, label = "Show the popup"
							}
						)#

						<script type="module" nonce="#event?.getRequestNonce()#">
							const popup      = document.querySelector("##design-system-demo");
							const showButton = document.querySelector("##design-system-demo-open-button");

							showButton.addEventListener("click", () => {
								popup.showModal();
							});
						</script>
					</div>
				</article>
			</div>
		</section>
	</div>
</cfoutput>