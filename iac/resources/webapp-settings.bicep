param webAppName string
param csDBPrimaryKey string
param csDBAccountURI string
param csDBContainerName string
param csDBName string
param strAccName string
param strAccKey string

resource webAppSettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${webAppName}/appsettings'
  properties: {
    ASPNETCORE_ENVIRONMENT: 'Production'
    AzureAd__CosmosDBAccountUri: csDBAccountURI
    AzureAd__CosmosDBAccountPrimaryKey: csDBPrimaryKey
    AzureAd__CosmosDbContainerName: csDBContainerName
    AzureAd__CosmosDbName: csDBName
    AzureAd__StorageAccountName: strAccName
    AzureAd__StrAccKey: strAccKey
  }
}
