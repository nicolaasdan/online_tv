var x = new Date();
var currentTimeZoneOffsetInHours = x.getTimezoneOffset() / 60;

$('#timezone').html("We think you are located in GMT" + currentTimeZoneOffsetInHours + ". ")

$('.mytz').each(function(index, value) {
	var d = new Date();
	var int = parseInt($(this).text())
	var hour = int + currentTimeZoneOffsetInHours + 2
	if(hour > 24) {
		hour = hour - 24
	}
	d.setHours(hour)
	$(this).text(d.getHours())
});


$('.gmt').each(function(index, value) {
	var d = new Date();
	var int = parseInt($(this).text())
	var hour = int + currentTimeZoneOffsetInHours
	if(hour > 24) {
		hour = hour - 24
	}
	d.setHours(hour)
	$(this).text(d.getHours())
});