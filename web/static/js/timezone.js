var x = new Date();
var currentTimeZoneOffsetInHours = x.getTimezoneOffset() / 60;

$('#timezone').html("you are located in the timezone GMT" + currentTimeZoneOffsetInHours + ". ")

$('.mytz').each(function(index, value) {
	var d = new Date();
	var int = parseInt($(this).text())
	var hour = int + currentTimeZoneOffsetInHours + 2
	d.setHours(hour)
	$(this).text(d.getHours())
});


