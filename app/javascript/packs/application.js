// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

document.addEventListener("turbolinks:load", function() {
	// Change screen elements while converting
	var convert_button = document.getElementById("convert-button");
	if (convert_button){
		document.getElementById("convert-button").addEventListener("click", function(e){
			// Display loading icon
			this.classList.add("is-loading");

			// Replace upload section with a progress bar
			document.querySelector("section.upload").innerHTML = "<progress id='progress-bar' class='progress is-primary' value='0' max='1'></progress>";

			// Hide action buttons
			(document.querySelectorAll('td.action') || []).forEach(($td) => {
				$td.innerHTML = "";
			});

			// Replace converted file name
			(document.querySelectorAll('.converted') || []).forEach(($td) => {
				$td.innerHTML = "Queued";
			});
		});
	};

	// Close notification panel
	(document.querySelectorAll('.delete') || []).forEach(($delete) => {
		$notification = $delete.parentNode;
		$notification.classList.add("fade-out");
		$delete.addEventListener('click', () => {
			$notification.parentNode.removeChild($notification);
		});
	});
})

