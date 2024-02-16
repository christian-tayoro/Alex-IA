param env string = 'dev'
param prefix string = 'canctr-'
param appName string = 'alexia'
param location string = resourceGroup().location

module storageAcc 'resources/storage-account.bicep' = {
  name: 'deployStorageAccount'
  params: {
    location: location
    projectName: '${appName}acc'
  }
}
