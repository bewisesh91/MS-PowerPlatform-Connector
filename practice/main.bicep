// Bicep 파일 안에서 Azure 리소스들을 정의

param location string = 'westus3'
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}'
var appServicePlanName = 'toy-product-launch-plan'

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

// storage 리소스 정의
// resource 키워드는 리소스 정의 선언을 의미
// 다음으로 리소스 기호 이름을 지정, 이 예제에서 리소스의 기호 이름은 storageAccount 
// Microsoft.Storage/storageAccounts@2021-08-01은 리소스의 종류 및 API 버전
//  Microsoft.Storage/storageAccounts는 Bicep에게 Azure 스토리지 계정을 선언한다는 것을 의미
// 2021-08-01은 Bicep이 리소스를 만들 때 사용할 Azure Storage API의 버전
// 그런 다음 해당 위치, SKU(가격 책정 계층) 및 종류와 같은 리소스의 기타 세부 정보를 설정
// 또한 각 리소스 종류마다 다른 속성을 정의할 수 있습니다. API 버전마다 다른 속성을 도입 가능
// 이 예제에서는 스토리지 계정의 액세스 계층을 Hot으로 설정
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverFarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

