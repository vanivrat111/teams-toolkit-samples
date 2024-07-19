provider microsoftGraph

@maxLength(20)
@minLength(4)
@description('Used to generate names for all resources in this file')
param resourceBaseName string

param webAppSKU string

@maxLength(42)
param botDisplayName string

param identityName string = resourceBaseName
param serverfarmsName string = resourceBaseName
param webAppName string = resourceBaseName
param location string = resourceGroup().location

// AAD apps
param accessAsUserPermissionId string

resource ssoApp 'Microsoft.Graph/applications@v1.0' = {
  displayName: 'botsso${resourceBaseName}'
  uniqueName: 'botsso${resourceBaseName}'
  signInAudience: 'AzureADMyOrg'
  requiredResourceAccess: [
    {
      resourceAppId: '00000003-0000-0000-c000-000000000000'
      resourceAccess: [
        {
          id: 'e1fe6dd8-ba31-4d61-89e7-88639da4683d'
          type: 'Scope'
        }
      ]
    }
  ]
  api: {
    oauth2PermissionScopes: [
      {
        adminConsentDescription: 'Allows Teams to call the app\'s web APIs as the current user.'
        adminConsentDisplayName: 'Teams can access app\'s web APIs'
        id: accessAsUserPermissionId
        isEnabled: true
        type: 'User'
        userConsentDescription: 'Enable Teams to call this app\'s web APIs with the same rights that you have'
        userConsentDisplayName: 'Teams can access app\'s web APIs and make requests on your behalf'
        value: 'access_as_user'
      }
    ]
    preAuthorizedApplications: [
      {
        appId: '1fec8e78-bce4-4aaf-ab1b-5451cc387264'
        delegatedPermissionIds: [accessAsUserPermissionId]
      }
      {
        appId: '5e3ce6c0-2b1f-4285-8d4b-75ee78787346'
        delegatedPermissionIds: [accessAsUserPermissionId]
      }
    ]
  }
  identifierUris: [
    'api://botid-${identity.properties.clientId}'
  ]
  web: {
    redirectUris: [
      'https://${webApp.properties.defaultHostName}/auth-end.html'
    ]
  }
}

resource federatedCredential 'Microsoft.Graph/applications/federatedIdentityCredentials@v1.0' = {
  name: '${ssoApp.uniqueName}/myfi'
  audiences: ['api://AzureADTokenExchange']
  issuer: 'https://login.microsoftonline.com/${tenant().tenantId}/v2.0'
  subject: identity.properties.principalId
}

// Compute resources for your Web App
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  location: location
  name: identityName
}

resource serverfarm 'Microsoft.Web/serverfarms@2021-02-01' = {
  kind: 'app'
  location: location
  name: serverfarmsName
  sku: {
    name: webAppSKU
  }
}

// Web App that hosts your bot
resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  kind: 'app'
  location: location
  name: webAppName
  properties: {
    serverFarmId: serverfarm.id
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18' // Set NodeJS version to 18.x for your site
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'RUNNING_ON_AZURE'
          value: '1'
        }
      ]
      ftpsState: 'FtpsOnly'
    }
  }
}

resource webAppSettings 'Microsoft.Web/sites/config@2021-02-01' = {
  name: '${webAppName}/appsettings'
  properties: {
    WEBSITE_NODE_DEFAULT_VERSION: '~18'
    WEBSITE_RUN_FROM_PACKAGE: '1'
    BOT_ID: identity.properties.clientId
    BOT_TENANT_ID: identity.properties.tenantId
    BOT_TYPE: 'UserAssignedMsi'
    BOT_DOMAIN: webApp.properties.defaultHostName
    AAD_APP_CLIENT_ID: ssoApp.appId
    RUNNING_ON_AZURE: '1'
  }
}

// Register your web service as a bot with the Bot Framework
module azureBotRegistration './botRegistration/azurebot.bicep' = {
  name: 'Azure-Bot-registration'
  params: {
    resourceBaseName: resourceBaseName
    identityClientId: identity.properties.clientId
    identityResourceId: identity.id
    identityTenantId: identity.properties.tenantId
    botAppDomain: webApp.properties.defaultHostName
    botDisplayName: botDisplayName
  }
}

// The output will be persisted in .env.{envName}. Visit https://aka.ms/teamsfx-actions/arm-deploy for more details.
output BOT_AZURE_APP_SERVICE_RESOURCE_ID string = webApp.id
output BOT_DOMAIN string = webApp.properties.defaultHostName

output BOT_ID string = identity.properties.clientId
output BOT_OBJECT_ID string = identity.properties.principalId
output AAD_APP_CLIENT_ID string = ssoApp.appId
output AAD_APP_OBJECT_ID string = ssoApp.id
output AAD_APP_TENANT_ID string = tenant().tenantId
output AAD_APP_OAUTH_AUTHORITY string = 'https://login.microsoftonline.com/${tenant().tenantId}'
output AAD_APP_OAUTH_AUTHORITY_HOST string = 'https://login.microsoftonline.com'
