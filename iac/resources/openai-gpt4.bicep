param name string
param oaiDeploymentName string = 'openaiDeployment'
param oaiDeploymentSku string = 'Standard'
param location string
param sku string

resource open_ai 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: name
  location: location
  kind: 'OpenAI'
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: toLower(name)
  }
}

resource open_ai_deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  name: oaiDeploymentName
  sku: {
    capacity: 1
    name: oaiDeploymentSku
  }
  parent: open_ai
  properties: {
   model: {
    format: 'OpenAI'
    name: 'gpt-4'
    version: '6013'
   }
   raiPolicyName: 'Microsoft.Default'
   versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
}
