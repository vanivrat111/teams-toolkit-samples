const doSomethingCard = require("./adaptiveCards/doSomethingCommandResponse.json");
const { AdaptiveCards } = require("@microsoft/adaptivecards-tools");
const { CardFactory, MessageFactory } = require("botbuilder");

class DoSomethingCommandHandler {
  triggerPatterns = "doSomething";

  async handleCommandReceived(context, message) {
    // verify the command arguments which are received from the client if needed.
    console.log(`App received message: ${message.text}`);

    const cardData = {
      title: "doSomething command is added",
      body: "Congratulations! You have responded to doSomething command",
    };

    const cardJson = AdaptiveCards.declare(doSomethingCard).render(cardData);
    return MessageFactory.attachment(CardFactory.adaptiveCard(cardJson));
  }
}

module.exports = {
  DoSomethingCommandHandler,
};