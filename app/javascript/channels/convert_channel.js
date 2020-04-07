import consumer from "./consumer"

document.addEventListener("turbolinks:load", function() {
  consumer.subscriptions.create({channel: "ConvertChannel", user: user_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Connect to convert channel")
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(data)
      document.querySelectorAll('td.converted')[data["index"]].innerHTML = "Converted!";
    }
  });
});