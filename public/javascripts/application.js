// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//this will set all ajax requests headers to javascript so rails knows what format to return
jQuery.ajaxSetup({
	'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

//this is the ajax functionality on the item pictures in the carosel
$(document).ready(function(){
	$('.carousel').click(function(){
		$.get($(this).attr("href"), null, null, "script");
		return false;
	})
})

//this loads the corousel for the items
$(document).ready(function(){
	$("#carousel").jCarouselLite({
      btnNext: "#carousel-prev",
      btnPrev: "#carousel-next",
			speed:   1000,
			vertical: true,
			visible: 3
  });
})

//setting the options for the lightbox
options = {opacity: 0.85,
		animationSpeed: 'slow'};

//this loads the lightbox functionality for the items
$(document).ready(function(){
	$('#carousel_view a.lightbox').prettyPhoto(options);
});

//this re-activates the lightbox functionality on ajax loaded items
$().ajaxSuccess(function(){
	$('#carousel_view a.lightbox').prettyPhoto(options);
});

//making the items on the items index page sortable
//also adds the callback to persist the order in the db
$().ready(function() {
      $('#items').tableDnD({
        onDrop: function(table, row) {
          $.ajax({
             type: "PUT",
             url: window.location + "/sort",
             processData: false,
             data: $.tableDnD.serialize(),
             success: function(msg) {
               alert("Items succesfully sorted")
             }
           });
        }
      })
    })

//changing the sites colour
$(document).ready(function(){
	$('.colour_button').click(function(){
		var colour = this.getAttribute("id");
		stylepath = "/stylesheets/" + colour + ".css";
		logopath = "/images/anna_logo1-" + colour + ".png";
		$('.colour_sheet').attr("href", stylepath);
		$('#header img').attr("src", logopath);
	})
})