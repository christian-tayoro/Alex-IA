param env string = 'dev'
param prefix string = 'cancentral-'
param appName string = 'alexia'
param location string = resourceGroup().location


module appserviceplan 'resources/app-service-plan.bicep' = {
  name: 'deployServicePlan'
  params: {
    servicePlanName: '${prefix}${env}-${appName}-srvplan'
    location: location
  }
}
