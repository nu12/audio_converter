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
	// Hide screen elements during convertion
	var convert_button = document.getElementById("convert-button");
	if (convert_button){
		document.getElementById("convert-button").addEventListener("click", function(e){
			this.classList.add("is-loading")
			document.getElementById("files-table").classList.add("is-hidden")
			
		})
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

