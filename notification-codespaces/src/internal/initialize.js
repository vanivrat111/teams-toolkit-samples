const { BotBuilderCloudAdapter } = require("@microsoft/teamsfx");
const ConversationBot = BotBuilderCloudAdapter.ConversationBot;
const config = require("./config");
const { DoSomethingCommandHandler } = require("../doSomethingCommandHandler");
const {DoSomethingActionHandler} = require("../cardActions/doSomethingActionHandler")

// Create bot.
const notificationApp = new ConversationBot({
  // The bot id and password to create CloudAdapter.
  // See https://aka.ms/about-bot-adapter to learn more about adapters.
  adapterConfig: config,
  // Enable notification
  notification: {
    enabled: true,
  },
  command: {
    enabled: true,
    commands: [ new DoSomethingCommandHandler()],
  },
  cardAction : {
    enabled: true, 
       actions: [ 
         new DoSomethingActionHandler() 
       ], 
  }
});

module.exports = {
  notificationApp,
};
