param env string = 'dev'
param prefix string = 'cancentral-'
param appName string = 'alexia'

module appserviceplan 'resources/app-service-plan.bicep' = {
  name: 'deployServicePlan'
  params: {
    servicePlanName: '${prefix}${env}${appName}-srvplan'
  }
}
