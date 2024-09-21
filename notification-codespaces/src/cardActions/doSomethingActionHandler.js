const { AdaptiveCards } = require("@microsoft/adaptivecards-tools");
    const { AdaptiveCardResponse, InvokeResponseFactory } = require("@microsoft/teamsfx");
    const responseCard = require("../adaptiveCards/doSomethingResponse.json");

    class DoSomethingActionHandler { 
    triggerVerb = "doStuff";

        async handleActionInvoked(context, message) { 
            const actionData = {

            };
            const responseCardJson = AdaptiveCards.declare(responseCard).render(actionData);

            
            return InvokeResponseFactory.adaptiveCard(responseCardJson);
        }
    }

     module.exports = {

       DoSomethingActionHandler,
    }