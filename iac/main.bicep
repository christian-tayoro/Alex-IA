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

module appservicefront 'resources/app-service.bicep' = {
  name: 'deployAppServiceFront'
  params: {
    appServiceName: '${prefix}${env}-${appName}'
    servicePlanName: '${prefix}${env}-${appName}-srvplan'
    location: location
  }
  dependsOn: [appserviceplan]
}

module appserviceback 'resources/app-service.bicep' = {
  name: 'deployAppServiceBackend'
  params: {
    appServiceName: '${prefix}${env}-${appName}-api'
    servicePlanName: '${prefix}${env}${appName}-srvplan'
    location: location
  }
  dependsOn: [appserviceplan]
}
