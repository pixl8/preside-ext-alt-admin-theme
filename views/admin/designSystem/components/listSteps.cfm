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
							The <strong>List Steps</strong> component displays a sequential list of setup or onboarding steps, showing progress and guiding users through a defined process. <br />
							Each step includes a title, description, and action — either a link to complete the step or a check icon when marked as completed.
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
									<th>Applies to</th>
									<th>Description</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>
										<code>steps</code>
									</td>
									<td>Array</td>
									<td>
										<code>[]</code>
									</td>
									<td>All</td>
									<td>
										A list of step objects. Each step should contain the following keys:<br>
										<ul>
											<li>
												<code>title</code> — The name or label of the step.
											</li>
											<li>
												<code>description</code> — A short explanation of what the step involves.
											</li>
											<li>
												<code>isCompleted</code> — Boolean indicating whether the step is done.
											</li>
											<li>
												<code>link</code> — URL the user should follow to complete the step.
											</li>
										</ul>
									</td>
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
							  view="/admin/_components/listSteps"
							, args={
									steps = [
										{
											title       = "Configure your AI provider",
											description = "Connect your LLM provider to power your assistant’s responses.",
											isCompleted = true,
											link        = "/"
										},
										{
											title       = "Connect your data sources",
											description = "Add the content and systems your assistant should use to answer questions.",
											isCompleted = false,
											link        = "/"
										},
										{
											title       = "Configure your agent",
											description = "Define its tone, role, and behaviour to match your brand.",
											isCompleted = false,
											link        = "/"
										},
										{
											title       = "Embed your web assistant",
											description = "Install it on your website and start chatting with it live.",
											isCompleted = false,
											link        = "/"
										},
										{
											title       = "Check the documentation",
											description = "Dive deeper into configuration, integrations, and advanced features.",
											isCompleted = false,
											link        = "/"
										}
									]
								}
						)#
					</div>
				</article>
			</div>
		</section>
	</div>
</cfoutput>