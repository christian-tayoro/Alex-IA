param accounts_GMAOpenAI_name string = 'GMAOpenAI'

resource accounts_GMAOpenAI_name_resource 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: accounts_GMAOpenAI_name
  location: 'canadaeast'
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: 'gmaopenai'
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource accounts_GMAOpenAI_name_OpenAIGPT4 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  parent: accounts_GMAOpenAI_name_resource
  name: 'OpenAIGPT4'
  sku: {
    name: 'Standard'
    capacity: 40
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4'
      version: '0613'
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    currentCapacity: 40
    raiPolicyName: 'Microsoft.Default'
  }
}

resource accounts_GMAOpenAI_name_Microsoft_Default 'Microsoft.CognitiveServices/accounts/raiPolicies@2023-10-01-preview' = {
  parent: accounts_GMAOpenAI_name_resource
  name: 'Microsoft.Default'
  properties: {
    mode: 'Blocking'
    contentFilters: [
      {
        allowedContentLevel: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        allowedContentLevel: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        allowedContentLevel: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        allowedContentLevel: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        allowedContentLevel: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        allowedContentLevel: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
      {
        allowedContentLevel: 'Medium'
        blocking: true
        enabled: true
        source: 'Prompt'
      }
      {
        allowedContentLevel: 'Medium'
        blocking: true
        enabled: true
        source: 'Completion'
      }
    ]
  }
}