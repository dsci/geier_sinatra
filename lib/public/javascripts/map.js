function initializeMap() {
  try{
		var parkPos = createLatLng(51.324852839492486, 12.290053367614746);
		var map = createMap(parkPos,"map_park");
		setMarker(map, "Park 5.1", parkPos);
  	
		var mzhPos = createLatLng(51.3800638, 12.504664);
		var mzhMap = createMap(mzhPos, "map_mzh");
		setMarker(mzhMap, "Mehrzweckhalle Taucha", mzhPos);
		
		//var map2 = new google.maps.Map(document.getElementById("map_canvas2"),myOptions);
	}catch(e){
		
	}
}

function setMarker(map,title,pos){
	var marker = new google.maps.Marker({
		position: pos, 
	  map: map, 
	  title:title
	});
}

function createLatLng(lat,lng){
	return new google.maps.LatLng(lat,lng);
}

function createMap(latlng,element){
	
	var options = {
  	zoom: 17,
  	center: latlng,
  	mapTypeId: google.maps.MapTypeId.ROADMAP,
		navigationControl: true,
		mapTypeControl: true,
		scaleControl: true
	};
	return new google.maps.Map(document.getElementById(element),options);
}