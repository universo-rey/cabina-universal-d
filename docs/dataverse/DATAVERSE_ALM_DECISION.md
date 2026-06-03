# Dataverse ALM Decision

ALM model: unmanaged DEV first, explicit promotion later.

DEV can be provisioned only after the exact environment is identified and the
precheck confirms it is not PROD-like or Default. TEST and PROD workflows are
manual templates with environment protection and are not executed in this
frontier.

Microsoft guidance used: Power Platform CLI solution commands, deployment
settings for connection references/environment variables, Dataverse change
tracking/auditing and GitHub Actions for Power Platform.
