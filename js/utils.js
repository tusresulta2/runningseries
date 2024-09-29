function counterUp(timeDuration, iconUTF8){
	
	$('.counter').each(function() {
	  var $this = $(this),
	      countTo = $this.attr('data-count');
	  
	  $({ countNum: $this.text()}).animate({
	    countNum: countTo
	  },
	  {
	    duration: timeDuration,
	    easing:'linear',
	    step: function() {
	      $this.text(Math.floor(this.countNum));
	    },
	    complete: function() {
	      $this.text(this.countNum);
	    }
	  });  
	});
	
	$('.counterFinalIcon').each(function() {
		  var $this = $(this),
		      countTo = $this.attr('data-count');
		  
		  $({ countNum: $this.text()}).animate({
		    countNum: countTo
		  },
		  {
		    duration: timeDuration,
		    easing:'linear',
		    step: function() {
		      $this.text(Math.floor(this.countNum));
		    },
		    complete: function() {
		      $this.text(iconUTF8);
		    }
		  });  
		});
}

function secondsToHms(d) {
	d = Number(d);

	var h = Math.floor(d / 3600);
	var m = Math.floor(d % 3600 / 60);
	var s = Math.floor(d % 3600 % 60);

	return ('0' + h).slice(-2) + ":" + ('0' + m).slice(-2) + ":"
			+ ('0' + s).slice(-2);
}

function getRaceInfo(raceNumber) {
	var race;
	$.ajax({
		type : "POST",
		async : false,
		url : "/races/info",
		data : JSON.stringify(raceNumber),
		contentType : "application/json",
		success : function(result) {
			race = result;
		},
		error : function() {
			alert('failure');
		}
	});
	return race;
}

function getRaces() {
	var raceList;
	$.ajax({
		type : "POST",
		async : false,
		url : "/races/list",
		contentType : "application/json",
		success : function(result) {
			raceList = result;
		},
		error : function() {
			alert('failure');
		}
	});
	return raceList;
}

function addResultBIB(bib) {
	$.ajax({
		type : "POST",
		url : "/results/add/bib",
		data : bib,
		contentType : "application/json",
		success : function() {
			alert('success');
		},
		error : function() {
			alert('failure');
		}
	});
}

function getHeight() {
	return $(window).height() - $('h1').outerHeight(true);
}

function getPhoto(timestampRequested, threshold) {
	$('img')
			.each(
					function(index) {
						if (undefined !== $(this).attr("data-image-meta")) {
							var photoURL = $(this).attr("data-orig-file");
							var photoProperties = $.parseJSON($(this).attr(
									"data-image-meta"));
							var photoTime = photoProperties.created_timestamp;
							if (photoTime !== '0'
									&& Number(photoTime) >= (Number(timestampRequested) - threshold)
									&& Number(photoTime) <= (Number(timestampRequested) + threshold))
								console.log(photoURL + ',' + photoTime);
						}
					});
}

var photos = '';
function getPhoto() {
	$('img').each(function(index) {
		if (undefined !== $(this).attr("data-image-meta")) {
			var photoURL = $(this).attr("data-orig-file");
			var photoProperties = $.parseJSON($(this).attr("data-image-meta"));
			var photoTime = photoProperties.created_timestamp;
			if (photoTime !== '0')
				photos = photos + photoTime + ',' + photoURL + "\n";
		}
	});
}

function getPhotos(carreraRequested, yearRequested, timeRequested) {
	$.post('/getPhotos', {
		carrera : carreraRequested,
		year : yearRequested,
		time : timeRequested
	});
}

function getVideos(carreraRequested, yearRequested, timeRequested) {
	$.post('/getVideos', {
		carrera : carreraRequested,
		year : yearRequested,
		time : timeRequested
	});
}

function logout(){
	$.post('/logout');
}