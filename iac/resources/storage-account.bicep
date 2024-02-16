param projectName string
param location string
param stSKU string = 'Standard_LRS'

// This function ensures that the name is stored in lowercase.
var storageAccountName = toLower(projectName)

resource st 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: stSKU
  }
  kind: 'StorageV2'
   properties: {
     accessTier: 'Hot'
   }
}

output storageAccountId string = st.id
output storageAccountName string = st.name
output storageAccountCnxStr string = 'DefaultEndpointsProtocol=https;AccountName=${st.name};AccountKey=${st.listKeys().keys[0].value}};EndpointSuffix=core.windows.net'
