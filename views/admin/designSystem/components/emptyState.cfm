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
              The <strong>Empty State</strong> component is used to display a friendly message when a section of the app has no data to show. It helps guide users on what to do next, such as creating a new item or connecting data
            </p>
            <p>
              Two layouts are available:
            </p>
            <ul>
              <li>
                Default — a compact centered layout with an icon, title, description, and optional action button.
              </li>
              <li>
                Media — a split layout designed for richer onboarding moments, pairing text and actions with an embedded video.
              </li>
            </ul>
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
                  <td><code>layout</code></td>
                  <td>String</td>
                  <td><code>"default"</code></td>
                  <td>All</td>
                  <td>Defines which layout to render (<code>default</code> or <code>media</code>).</td>
                </tr>
                <tr>
                  <td><code>title</code></td>
                  <td>String</td>
                  <td><code>""</code></td>
                  <td>All</td>
                  <td>Main heading shown at the top of the empty state.</td>
                </tr>
                <tr>
                  <td><code>description</code></td>
                  <td>String</td>
                  <td><code>""</code></td>
                  <td>All</td>
                  <td>Short explanatory text under the title.</td>
                </tr>
                <tr>
                  <td><code>icon</code></td>
                  <td>String</td>
                  <td><code>""</code></td>
                  <td>Default</td>
                  <td>Font Awesome icon name (without the <code>fa-</code> prefix).</td>
                </tr>
                <tr>
                  <td><code>videoUrl</code></td>
                  <td>String</td>
                  <td><code>""</code></td>
                  <td>Media</td>
                  <td>Embeddable video URL (e.g. Vimeo) displayed in the media layout.</td>
                </tr>
                <tr>
                  <td><code>videoNote</code></td>
                  <td>String</td>
                  <td><code>""</code></td>
                  <td>Media</td>
                  <td>Optional short note shown below the video.</td>
                </tr>
                <tr>
                  <td><code>buttonLabel</code></td>
                  <td>String</td>
                  <td><code>""</code></td>
                  <td>All</td>
                  <td>Text label for the primary action button.</td>
                </tr>
                <tr>
                  <td><code>buttonLink</code></td>
                  <td>String</td>
                  <td><code>""</code></td>
                  <td>All</td>
                  <td>URL for the primary action button.</td>
                </tr>
                <tr>
                  <td><code>buttonIcon</code></td>
                  <td>String</td>
                  <td><code>"plus"</code></td>
                  <td>All</td>
                  <td>Optional icon for the action button (Font Awesome, no <code>fa-</code> prefix).</td>
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
          <header class="p-design-system-entry__article-header">
            <h3 class="p-design-system-entry__article-title">Layout: Default</h3>
          </header>
          <div class="p-design-system-entry__article-body">
            #renderView(
              view="/admin/_components/emptyState",
              args={
                icon="key",
                title="No agents created yet.",
                description="Create an agent to define how your assistant behaves — from its tone to its access and skills.",
                buttonLabel="Create agent",
                buttonLink="##",
              }
            )#
          </div>
        </article>
        <article class="p-design-system-entry__article">
          <header class="p-design-system-entry__article-header">
            <h3 class="p-design-system-entry__article-title">Layout: Media</h3>
          </header>
          <div class="p-design-system-entry__article-body">
            #renderView(
              view="/admin/_components/emptyState",
              args={
                layout="media",
                title="No agents created yet.",
                description="Create an agent to define how your assistant behaves — from its tone to its access and skills.",
                buttonLabel="Create agent",
                buttonLink="##",
                videoUrl="https://player.vimeo.com/video/662689422",
                videoNote="&rarr; Watch our 5 minute guide on agents",
              }
            )#
          </div>
        </article>
      </div>
    </section>
	</div>
</cfoutput>