param appServiceName string = ''
param location string = resourceGroup().location
param servicePlanName string = ''

resource azbicepsas1 'Microsoft.Web/sites@2018-11-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', servicePlanName)
  }
}
