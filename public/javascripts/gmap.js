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

function load(randNum) {
  if (GBrowserIsCompatible()) {
    var existing_coordinates = parent.document.getElementById("survey_geographic_locations_attributes_"+randNum+"_value").value;
    var coordinatesArr = eval('[' + existing_coordinates + ']');
    if (existing_coordinates != "") {
      var initialCoordinateArr = coordinatesArr[0].split(",");
    }
    else {
      var initialCoordinateArr = new Array(52.2419, 21.01);
    }
    
    map = new GMap2(document.getElementById("map"));
    map.setCenter(new GLatLng(initialCoordinateArr[0], initialCoordinateArr[1]), 14);
    map.addControl(new GOverviewMapControl());
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.addControl(new GScaleControl());
    map.enableDoubleClickZoom();
    map.enableScrollWheelZoom();
    
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
        })
      } 
      points.push(point)
      reDraw()
    }
    )
    
    if (existing_coordinates != "") {
      var temp_pointsArr = new Array();
      for (i=0; i<coordinatesArr.length-1; i++) {
        var temp_points = new GMarker(new GLatLng(coordinatesArr[i].split(",")[0], coordinatesArr[i].split(",")[1]), opt).getPoint();
        temp_pointsArr.push(temp_points);
      }
      var polygon  = new GPolygon(temp_pointsArr, '#000000', 2, 1, '#FF0000', .5);
      map.clearOverlays();
      map.addOverlay(polygon);
      var latlngbounds = new GLatLngBounds();
      for (var i = 0; i < temp_pointsArr.length; i++)
      {
        latlngbounds.extend(temp_pointsArr[i]);
      }
      map.setCenter(latlngbounds.getCenter(), map.getBoundsZoomLevel(latlngbounds));
    }
  }
}

function clearPoints() {
  points= new Array();
  markers= new Array;
  map.clearOverlays();
  line = undefined;
  vertex = true;
}

function toArray() {
  html = ""
  for (i=0; i<points.length; i++) {
    html = html + 'points['+i+'] = [' + points[i].lat() + ', ' + points[i].lng() + ']'
  }
  return html
}

function toGLatLng() {
  html = ""
  for (i=0; i<points.length; i++) {
    html = html + "'" + points[i].lat() + ', ' + points[i].lng() + "',"
  }
  html = html + "'" + new GPolygon(points,'#000000',2,1,'#FF0000',.5).getBounds() + "'"
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
    points.push(points[0]);
    map.clearOverlays();
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
  if (vertex) {
    for (i = 0; i < markers.length; i++) {
      map.addOverlay(markers[i])
    }
  }
  reDraw()
}

function savePoints(randNum) {
  if (points != "") {
    reShape();
    parent.document.getElementById("survey_geographic_locations_attributes_"+randNum+"_value").value = toGLatLng();
    parent.document.getElementById("savedArea"+randNum).innerHTML = "Selected area has been recorded successfully!!";
    setTimeout('hideIframe("'+randNum+'");', 1000);
  }
  else {
    clearPoints();
    alert("Please click on the map to place the markers and select the area.");
  }
}

function hideIframe (arg) {
  clearPoints();
  parent.document.getElementById("googleMaps"+arg).style.height = "0px";
  parent.document.getElementById("googleMaps"+arg).style.width = "0px";
  parent.document.getElementById("googleMaps"+arg).src = "about:blank";
}

