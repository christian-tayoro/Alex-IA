param accounts_GMAOpenAI_name string
param location string

resource accounts_GMAOpenAI_name_resource 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: accounts_GMAOpenAI_name
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: toLower(accounts_GMAOpenAI_name)
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}
