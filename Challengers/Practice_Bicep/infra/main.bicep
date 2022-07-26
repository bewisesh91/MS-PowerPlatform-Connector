@description('Dev Info')
param devName string = 'seunghyun'
param devEmail string = 'bewise.seunghyun@gmail.com'

@description('Location Info')
param location string = resourceGroup().location

@description('Variables')
var ID = resourceGroup().id
var uniqueName = uniqueString(ID)

var storageAccountName = 'stacc${uniqueName}'
var storageAccountSkuName = 'Standard_LRS'

var appServiceName = 'appsvcplan-${uniqueName}'
var appServiceSkuName = 'Y1'

var apiManagementName = 'apim-${uniqueName}'
var apiManagmentSkuName = 'Basic'

var azureFunctionName = 'azurefunc-${uniqueName}'

var logAnalyticsName = 'wrkspc-${uniqueName}'
var logAnalyticsSkuName = 'PerGB2018'

var applicationInsightsName = 'appinsights-${uniqueName}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  kind: 'Storage'
  sku: {
    name: storageAccountSkuName
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServiceName
  location: location
  sku: {
    name: appServiceSkuName
    tier: 'Dynamic'
  }
}

resource apiManagement 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: apiManagementName
  location: location
  sku: {
    name: apiManagmentSkuName
    capacity: 1
  }
  properties: {
    publisherEmail: devEmail
    publisherName: devName
  }
}

resource azureFunction 'Microsoft.Web/sites@2021-03-01' = {
  name: azureFunctionName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: logAnalyticsName
  location: location
  properties: {
    retentionInDays: 30
    sku: {
      name: logAnalyticsSkuName
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
  }
}
