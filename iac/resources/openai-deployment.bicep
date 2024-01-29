
param openaiName string
param oaiDeploymentName string
param oaiDeploymentSku string = 'Standard'

resource openaiResource 'Microsoft.CognitiveServices/accounts@2022-03-01' existing = {
  name: openaiName
}

resource open_ai_deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  name: oaiDeploymentName
  sku: {
    capacity: 1
    name: oaiDeploymentSku
  }
  parent: openaiResource
  properties: {
   model: {
    format: 'OpenAI'
    name: 'gpt-4'
    version: '6013'
   }
   raiPolicyName: 'Microsoft.Default'
   versionUpgradeOption: 'OnceCurrentVersionExpired'
  }
}
