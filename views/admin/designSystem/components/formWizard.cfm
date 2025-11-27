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
							The <strong>Form Wizard</strong> component provides a guided, multi-step layout for completing complex forms or configuration flows. It helps users track progress, understand their current position, and access help resources while moving through structured steps.
						</p>
						<p>
							Each step can display its own form view, with progress and completion indicators updated dynamically.
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
									<td><code>title</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Main heading displayed at the top of the wizard sidebar.</td>
								</tr>
								<tr>
									<td><code>helpText</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Text label for the help link shown at the bottom of the sidebar.</td>
								</tr>
								<tr>
									<td><code>helpUrl</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>URL for the help link. Only displayed when both <code>helpText</code> and <code>helpUrl</code> are provided.</td>
								</tr>
								<tr>
									<td><code>steps</code></td>
									<td>Array</td>
									<td><code>[]</code></td>
									<td>No</td>
									<td>
										List of step objects defining the wizard flow. Each step can include:<br>
										<ul>
											<li><code>title</code> — Label for the step displayed in the sidebar.</li>
											<li><code>isCompleted</code> — Boolean indicating whether the step is completed.</li>
										</ul>
									</td>
								</tr>
								<tr>
									<td><code>currentStep</code></td>
									<td>String</td>
									<td><code>"1"</code></td>
									<td>No</td>
									<td>Index of the currently active step (used for progress calculation and highlighting).</td>
								</tr>
								<tr>
									<td><code>currentStepTitle</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Title displayed at the top of the main content area for the current step.</td>
								</tr>
								<tr>
									<td><code>currentStepDescription</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Short descriptive text shown under the current step title.</td>
								</tr>
								<tr>
									<td><code>formView</code></td>
									<td>String</td>
									<td><code>""</code></td>
									<td>No</td>
									<td>Path to the form view file to render within the wizard’s main content area.</td>
								</tr>
								<tr>
									<td><code>formArgs</code></td>
									<td>Struct</td>
									<td><code>{}</code></td>
									<td>No</td>
									<td>Optional arguments passed into the rendered form view.</td>
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
								view = "/admin/_components/formWizard"
							, args = {
										title = "Agent Setup Wizard"
									, helpText = "Need help?"
									, helpUrl = "##"
									, steps = [
											{ title="Agent Configuration", isCompleted=true }
										, { title="Model Setup", isCompleted=false }
										, { title="Behaviour Settings", isCompleted=false }
									]
									, currentStep = "1"
									, currentStepTitle = "Define your agents’s identity"
									, currentStepDescription = "Give it a clear internal name and specify where it’s used."
							}
						)#
					</div>
				</article>
			</div>
		</section>
	</div>
</cfoutput>