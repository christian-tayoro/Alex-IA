
param openaiName string
param openaiDeploymentModel string

resource openaiResource 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' existing = {
  name: openaiName
}

resource accounts_GMAOpenAI_name_OpenAIGPT4 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  parent: openaiResource
  name: 'OpenAIGPT4-32k'
  sku: {
    name: 'Standard'
    capacity: 25
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: openaiDeploymentModel
      version: '0613'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    raiPolicyName: 'Microsoft.Default'
  }
}
