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



// Goal : Implement Resources

// * 애저 API 관리자


// * 애저 펑션
// * 애저 저장소 어카운트
// * 애저 앱 서비스 플랜
// * 애저 애플리케이션 인사이트
// * 애저 로그 아날리틱스 워크스페이스


