<cfoutput>
	#renderView(
		view = "/admin/_pages/onboardingChecklist",
		args = {
			  title = "Let's get started."
			, description = "Follow these simple steps to set up your RI assistant — connect your data, configure its personality, and embed it on your site."
			, steps = [
					{
							title:       "Configure your AI provider"
						, description: "Connect your LLM provider to power your assistant’s responses."
						, isCompleted: true
						, link:        "/"
					}
					, {
							title       = "Connect your data sources"
						, description = "Add the content and systems your assistant should use to answer questions."
						, isCompleted = false
						, link        = "/"
					}
					, {
							title       = "Configure your agent"
						, description = "Define its tone, role, and behaviour to match your brand."
						, isCompleted = false
						, link        = "/"
					}
					, {
							title       = "Embed your web assistant"
						, description = "Install it on your website and start chatting with it live."
						, isCompleted = false
						, link        = "/"
					}
					, {
							title       = "Check the documentation"
						, description = "Dive deeper into configuration, integrations, and advanced features."
						, isCompleted = false
						, link        = "/"
					}
			]
			, skipLinkText: "Skip and continue to your dashboard"
			, skipLinkUrl: "##"
			, noticeText: "Tip: You can return here any time from the configuration and setup menu"
		}
	)#
</cfoutput>