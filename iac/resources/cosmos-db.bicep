@description('The name for the database')
param cosmosDbAccName string = 'myDatabase'

@description('The name for the database')
param databaseName string = 'myDatabase'

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  name: '${cosmosDbAccName}/${databaseName}'
  properties: {
    resource: {
      id: databaseName
    }
  }
}

output dbname string = database.name
