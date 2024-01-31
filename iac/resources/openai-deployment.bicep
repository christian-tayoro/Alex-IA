
param openaiName string

resource openaiResource 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' existing = {
  name: openaiName
}

resource accounts_GMAOpenAI_name_OpenAIGPT4 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  parent: openaiResource
  name: 'OpenAIGPT4-32k'
  sku: {
    name: 'Standard'
    capacity: 40
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4-32k'
      version: '0613'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    raiPolicyName: 'Microsoft.Default'
  }
}
