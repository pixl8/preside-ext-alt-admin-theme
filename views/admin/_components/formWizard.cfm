<cfscript>
	event.include( "/css/admin/altadmintheme/components/form-wizard/" );
</cfscript>

<cfparam name="args.title"                  type="string" default="" />
<cfparam name="args.helpText"               type="string" default="" />
<cfparam name="args.helpUrl"                type="string" default="" />
<cfparam name="args.steps"                  type="array"  default=#[]# />
<cfparam name="args.currentStep"            type="string" default="1" />
<cfparam name="args.currentStepTitle"       type="string" default="" />
<cfparam name="args.currentStepDescription" type="string" default="" />
<cfparam name="args.formView"               type="string" default="" />
<cfparam name="args.formArgs"               type="struct" default=#{}# />

<cfoutput>
	<div class="c-form-wizard">
		<div class="c-form-wizard__container">
			<aside class="c-form-wizard__aside">
				<header class="c-form-wizard__aside-header">
					<cfif Len(args.title)>
						<h1 class="c-form-wizard__title">
							#args.title#
						</h1>
					</cfif>
					<cfif ArrayLen( args.steps ) gt 0>
						<div class="c-form-wizard__progress">
							<div class="c-form-wizard__progress-bar">
								<div class="c-form-wizard__progress-bar-fill" style="width:calc((#args.currentStep# / #ArrayLen( args.steps )#) * 100%);"></div>
							</div>
							<div class="c-form-wizard__progress-text">
								#args.currentStep#/#ArrayLen( args.steps )# Completed
							</div>
						</div>
					</cfif>
				</header>
				<cfif ArrayLen( args.steps ) gt 0>
					<div class="c-form-wizard__steps">
						<cfset i = 1>
						<cfloop array="#args.steps#" index="step">
							<div class="c-form-wizard__step<cfif args.currentStep eq i> is-active</cfif><cfif step.isCompleted> is-completed</cfif>">
								<div class="c-form-wizard__step-title">#step.title#</div>
								<div class="c-form-wizard__step-status">
									<cfif step.isCompleted>
										<i class="c-form-wizard__step-icon fa fa-check"></i>
									</cfif>
								</div>
							</div>
							<cfset i++>
						</cfloop>
					</div>
				</cfif>
				<cfif Len( args.helpText ) && Len( args.helpUrl )>
					<a class="c-form-wizard__help" href="#encodeForHtmlAttribute( args.helpUrl )#" target="_blank">#args.helpText#</a>
				</cfif>
			</aside>
			<main class="c-form-wizard__main">
				<cfif Len( args.currentStepTitle ) || Len( args.currentStepDescription )>
					<header class="c-form-wizard__main-header">
						<cfif Len( args.currentStepTitle )>
							<h2 class="c-form-wizard__current-step-title">#args.currentStepTitle#</h2>
						</cfif>
						<cfif Len( args.currentStepDescription )>
							<div class="c-form-wizard__current-step-description">#args.currentStepDescription#</div>
						</cfif>
					</header>
				</cfif>
				<cfif Len( args.formView )>
					<div class="c-form-wizard__main-body">
						#renderView( view=args.formView, args=args.formArgs )#
					</div>
				</cfif>
			</main>
		</div>
	</div>
</cfoutput>
