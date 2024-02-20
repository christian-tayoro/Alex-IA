param env string = 'dev'
param prefix string = 'canctr-'
param appName string = 'alexia'
param location string = resourceGroup().location
param objectid string = ''
param secretName string = 'connectionstring'
param oaiDeploymentModel string = 'gpt-4-32k'
@secure()
param secretValue string
param strAccKey string = 'qqMMyPExpWDDBFZ/vRyL/xsHSNISzRxyalIDcgvv5pGYJ0JwMY1i9fjLgYrRxg/0x1s4wDvyxb8L+AStzt+GxA=='


module keyvault 'resources/keyvault.bicep' = {
  name: 'deployKeyvault'
  params: {
    location: location
    keyVaultName: '${prefix}${env}${appName}-kv'
    objectId: objectid
    secretName: secretName
    secretValue: secretValue
  }
}

module cosmosDbAcc 'resources/cosmos-db-account.bicep' = {
  name: 'deployCosmosDbAccount'
  params: {
    accountName: '${prefix}${env}${appName}-dbacc'
    primaryRegion: location
    location: location
  }
  dependsOn: [
    keyvault
  ]
}

module cosmosDatabase 'resources/cosmos-db.bicep' = {
  name: 'deployCosmosDatabase'
  params: {
    cosmosDbAccName: '${prefix}${env}${appName}-dbacc'
    databaseName: 'alexia-db'
  }
  dependsOn: [
    cosmosDbAcc
  ]
}

module appserviceplan 'resources/app-service-plan.bicep' = {
  name: 'deployServicePlan'
  params: {
    servicePlanName: '${prefix}${env}${appName}-srvplan'
    location: location
  }
  dependsOn: [
    cosmosDatabase
  ]
}

module appservicefront 'resources/app-service.bicep' = {
  name: 'deployAppServiceFront'
  params: {
    appServiceName: '${prefix}${env}${appName}'
    servicePlanName: '${prefix}${env}${appName}-srvplan'
    location: location
  }
  dependsOn: [appserviceplan]
}

module appserviceback 'resources/app-service.bicep' = {
  name: 'deployAppServiceBackend'
  params: {
    appServiceName: '${prefix}${env}${appName}-api'
    servicePlanName: '${prefix}${env}${appName}-srvplan'
    location: location
  }
  dependsOn: [appserviceplan]
}

module appservicebacksettings 'resources/webapp-settings.bicep' = {
  name: 'deployAppServiceBackendSettings'
  params: {
    webAppName: '${prefix}${env}${appName}-api'
    csDBAccountURI: 'https://${prefix}${env}${appName}-dbacc.documents.azure.com:443/'
    csDBContainerName: 'cv'
    csDBName: 'alexia-db'
    csDBPrimaryKey: cosmosDbAcc.outputs.cosmosDbAccountPK
    strAccName: '${appName}acc'
    strAccKey: strAccKey
  }
  dependsOn: [appserviceback]
} 

module openai 'resources/openai-gpt4.bicep' = {
  name: 'deployOpenAIGpt4'
  params: {
    accounts_GMAOpenAI_name: '${prefix}${env}${appName}-openai'
    location: 'canadaeast'
  }
}

module openaiDeployment 'resources/openai-deployment.bicep' = {
  dependsOn: [openai]
  name: 'deployOpenAIDeployment'
  params: {
    openaiName: '${prefix}${env}${appName}-openai'
    openaiDeploymentModel: oaiDeploymentModel
  }
}
