provider microsoftGraph

param resourceBaseName string
param accessAsUserPermissionId string
param botDomain string

resource botApp 'Microsoft.Graph/applications@v1.0' = {
  displayName: 'bot${resourceBaseName}'
  uniqueName: 'bot${resourceBaseName}'
  signInAudience: 'AzureADMultipleOrgs'
}

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
    'api://botid-${botApp.appId}'
  ]
  web: {
    redirectUris: [
      'https://${botDomain}/auth-end.html'
    ]
  }
}

output BOT_ID string = botApp.appId
output BOT_OBJECT_ID string = botApp.id
output AAD_APP_CLIENT_ID string = ssoApp.appId
output AAD_APP_OBJECT_ID string = ssoApp.id
output AAD_APP_TENANT_ID string = tenant().tenantId
output AAD_APP_OAUTH_AUTHORITY string = 'https://login.microsoftonline.com/${tenant().tenantId}'
output AAD_APP_OAUTH_AUTHORITY_HOST string = 'https://login.microsoftonline.com'

