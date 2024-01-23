param servicePlanName string = ''

resource azbicepasp1 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: servicePlanName
  location: resourceGroup().location
  sku: {
    name: 'S1'
    capacity: 1
  }
}
