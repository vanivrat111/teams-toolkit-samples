# Getting Started with Notification Sample

[![Open notification app in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=dol%2Fcodespaces&repo=348288141&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Fnotification-codespaces%2Fdevcontainer.json&location=WestUs2)

> Note: We really appreciate your feedback! If you encounter any issue or error, please report issues to us following the [Supporting Guide](https://github.com/OfficeDev/TeamsFx-Samples/blob/dev/SUPPORT.md). Meanwhile you can make [recording](https://aka.ms/teamsfx-record) of your journey with our product, they really make the product better. Thank you!
>  
> This warning will be removed when the samples are ready for production.

This sample showcases an app that send a message to Teams with Adaptive Cards triggered by a HTTP post request. You can further extend the template to consume, transform and post events to individual, chat or channel in Teams.

The app is built using the TeamsFx SDK, which provides a simple set of functions over the Microsoft Bot Framework to implement this scenario.

## Prerequisite
- [Node.js](https://nodejs.org/), supported versions: 14, 16, 18 (preview)
- A Microsoft 365 account. If you do not have Microsoft 365 account, apply one from [Microsoft 365 developer program](https://developer.microsoft.com/en-us/microsoft-365/dev-program)
- Latest [Teams Toolkit Visual Studio Code Extension](https://aka.ms/teams-toolkit) or [TeamsFx CLI](https://aka.ms/teamsfx-cli)
- An [Azure subscription](https://azure.microsoft.com/en-us/free/)

## What you will learn in this sample:
- How to build notification app with Teams Toolkit
- How to send notification in Teams

## Try the Sample in GitHub Codespaces:
1. Click [Open in GitHub Codespaces](#getting-started-with-notification-sample) badge to create a codespace for the notification sample.

2. Once your codespace is created, Select the Teams Toolkit icon on the left in the VS Code toolbar. And then select `Preview your Teams app (F5)` from Teams Toolkit or simply press `F5` to run and preview your application:

4. When Teams launches in the browser, select the `Add` button in the dialog to install your app to Teams.

5. Open a terminal in your Codespaces, and send a POST request to the app with the following command:
   ```bash
   curl -X POST http://localhost:3978/api/notification
   ```

The application will send an Adaptive Card to Teams:

![Notification Message in Teams](https://user-images.githubusercontent.com/10163840/224254253-21b4dedd-1079-4cda-ac9e-cd3bce725702.png)

## Edit the manifest

You can find the Teams app manifest in `./appPackage` folder. The folder contains one manifest file:
* `manifest.json`: Manifest file for Teams app running locally or running remotely (After deployed to Azure).

This file contains template arguments with `${{...}}` statements which will be replaced at build time. You may add any extra properties or permissions you require to this file. See the [schema reference](https://docs.microsoft.com/en-us/microsoftteams/platform/resources/schema/manifest-schema) for more information.

## Code structure

| Folder / File| Contents |
| - | - |
| `teamsapp.yml` | Main project file describes your application configuration and defines the set of actions to run in each lifecycle stages |
| `teamsapp.local.yml`| This overrides `teamsapp.yml` with actions that enable local execution and debugging |
| `env/`| Name / value pairs are stored in environment files and used by `teamsapp.yml` to customize the provisioning and deployment rules |
| `.vscode/` | VSCode files for debugging |
| `src/` | The source code for the notification Teams application |
| `appPackage/` | Templates for the Teams application manifest |
| `infra/` | Templates for provisioning Azure resources |

The following files can be customized and demonstrate an example implementation to get you started.

| File | Contents |
| - | - |
| `src/index.js` | Application entry point and `restify` handlers for notifications |
| `src/teamsBot.js`| An empty teams activity handler for bot customization |
| `src/adaptiveCards/notification-default.json` | A generated Adaptive Card that is sent to Teams |
| `src/cardModels.js` | The default Adaptive Card data model |

## Learn more
- [Send notification to Teams](https://aka.ms/teamsfx-notification-new)
- [Teams Toolkit Documentations](https://docs.microsoft.com/microsoftteams/platform/toolkit/teams-toolkit-fundamentals)
- [Teams Toolkit CLI](https://docs.microsoft.com/microsoftteams/platform/toolkit/teamsfx-cli)
- [TeamsFx SDK](https://docs.microsoft.com/microsoftteams/platform/toolkit/teamsfx-sdk)
- [Teams Toolkit Samples](https://github.com/OfficeDev/TeamsFx-Samples)

## Code of Conduct
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).

For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.