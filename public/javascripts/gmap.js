var points = new Array()
var markers = new Array()
var map
var line = undefined
var vertex = true
var new_icon = new GIcon()
new_icon.image = "../images/cross.png"
new_icon.size = new GSize(16,16)
new_icon.iconAnchor = new GPoint(8,9)
new_icon.infoWindowAnchor = new GPoint(7,7)

var opt 
opt = {}

opt.icon = new_icon
opt.draggable = true
opt.clickable = false
opt.dragCrossMove = true


var geocoder = new GClientGeocoder();

function showAddress(address) {
  	geocoder.getLatLng(
    		address,
    		function(point) {
      			if (!point) {
        				alert(address + " not found");
      			} else {
        				map.setCenter(point, 14);
      			}
    		}
  	);
}

function load() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.setCenter(new GLatLng(52.2419, 21.01), 4);
    map.addControl(new GLargeMapControl())
    map.addControl(new GMapTypeControl())

    GEvent.addListener(map, "click", function (marker, point) {
      if (!vertex)	//don't add new points in Polygon mode
        return
      if (!marker) {
        new_marker = new GMarker(point,opt)
        map.addOverlay( new_marker )
        markers.push(new_marker)
        GEvent.addListener(new_marker,'dragend', function(){
          points[markers.indexOf(this)] = this.getPoint()
          reDraw()
          //asArray()
        })
      } 
      points.push(point)
      //alert(points)
      //alert(point)
      //asArray()
      reDraw()
    }
    )
  }
}

function clearPoints() {
  points= new Array()
  markers= new Array
  map.clearOverlays()
  //document.getElementById("output").innerHTML = ""
  line = undefined
  vertex = true
}

function toArray() {
  html = "var points = new Array()<br/>"
  for (i=0; i<points.length; i++) {
    html = html + 'points['+i+'] = [' + points[i].lat() +
            ', ' + points[i].lng() + ']<br/>'
  }
  return html
}

function toGLatLng() {
  html = "[<br/>"
  for (i=0; i<points.length; i++) {
    html = html + ' new GLatLng(' + points[i].lat() +
            ',' + points[i].lng() + ')'
    if (i <points.length-1)
      html = html +',<br/>'
    else
      html = html + '<br/>]<br/>'
        
  }
  return html
}

function asArray() {
  document.getElementById("output").innerHTML = toArray()
}

function asGLatLng() {
  document.getElementById("output").innerHTML = toGLatLng()
}

function reDraw() {
  if (vertex) {
    if (line) {
      map.removeOverlay(line)
    }
    line = new GPolyline( points )
    map.addOverlay(line)
  } else {
    map.clearOverlays()
    map.addOverlay(new GPolygon(points,'#000000',2,1,'#FF0000',.5))
  }
}

function delLast() {
  points.pop()
  map.removeOverlay(markers.pop())
  reDraw()
}

function reShape() {
  map.clearOverlays()
  vertex = !vertex
  
  if (vertex) 
    for (i=0;i<markers.length;i++) 
      map.addOverlay(markers[i])
  
  reDraw()
}

function savePoints() {
	if (points != "") {
		reShape();
	  	var current_count = document.getElementById("coords_count").value;
	  	var new_count = parseInt(current_count) + 1
	  	document.getElementById("coords_count").value = new_count;
		updateCordinates();
		clearPoints();
	}
	else {
		clearPoints();
		alert("Please click on the map to place the markers and select the area.");
	}
}

function updateCordinates() {
	var current_HTML = document.getElementById("output").innerHTML;
	var current_count = document.getElementById("coords_count").value;
	var new_HTML = current_HTML;
	new_HTML += "Saved Area "+current_count+" <a href='#' onClick='removeArea("+current_count+")' class='button button_la'>X</a>";
	new_HTML += "<input type='hidden' name='selected_cordinates"+current_count+"' id='selected_cordinates"+current_count+"' value='"+points+"'><br /><br />";
	document.getElementById("output").innerHTML = new_HTML;
	setIframeHeight('googleMaps');
}