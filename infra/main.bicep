param name string
param location string = resourceGroup().location
param loc string = 'krc'

var rg = 'rg-${name}-${loc}'
var fncappname = 'fncapp-${name}-${loc}'

resource st 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'st${name}${loc}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource csplan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'csplan-${name}-${loc}'
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  properties: {
    reserved: true
  }
}

resource appsvc 'Microsoft.Web/sites@2021-03-01' = {
  name: fncappname
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: csplan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: st.id
        }
      ]
    }
  }
}

output rn string = rg

