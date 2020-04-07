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
      // Update progress bar
      document.getElementById("progress-bar").value = data["value"] / data["max"];
      
      // Update table rows
      (document.querySelectorAll('td.converted')).forEach(($row, $index) => {
        if($index < data["value"]){
          $row.innerHTML = "Success"
        }else if($index == data["value"]){
          $row.innerHTML = "Converting..."
        }
      });
    }
  });
});