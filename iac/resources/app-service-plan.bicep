param servicePlanName string = ''
param location string = resourceGroup().location

resource azbicepasp1 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: servicePlanName
  location: location
  sku: {
    name: 'S1'
    capacity: 1
  }
}
