---
title: "Google Maps with AngularDart"
description: "In this article we will integrate Google Maps with an AngularDart application. The app itself will be very simple: it calculates the great…"
publishDate: 2017-02-23
author: "isoos"
image: images/1hLce2qgbJEkxjOlOr8jn9g.png
category: other
tags:
  - web-development
  - dartlang
  - dart
  - javascript
  - google-maps
---


In this article we will integrate Google Maps with an AngularDart application. The app itself will be very simple: it calculates the [great circle distance](https://en.wikipedia.org/wiki/Great-circle_distance) (the shortest distance on the surface of a sphere) between two selected markers on the map.

Along the way you will:

* Register your own Google Maps API key.

* Create a barebones Angular web application.

* Integrate Dart with the Google Maps JavaScript API, and handle the maps interaction.

* Learn some polishing tips for the Angular component.

This article is roughly four times longer than the code. If you want, just go look at the complete [**source code**](https://github.com/isoos/google_maps_angular_dart) and the final [**demo**](https://isoos.github.io/google_maps_angular_dart/).

<DashImage src="images/1hLce2qgbJEkxjOlOr8jn9g.png" alt="Screenshot of the demo" caption="Screenshot of the demo" />


## Google Maps JavaScript API

The [Google Maps JavaScript API](https://developers.google.com/maps/documentation/javascript/) allows developers to embed and integrate Google Maps on their site. You can customize the displayed map’s content and handling with your own imagery, data and processing.

To start developing with the Google Maps API, you must register a free API key that allows a reasonable amount of usage. As your application gets more traction, you can upgrade it to a paid plan.

Visit the [JavaScript API page](https://developers.google.com/maps/documentation/javascript/), and at the top of the page, click `GET A KEY`. Create a name for your project and click `CREATE AND ENABLE API`:

<DashImage src="images/1cPMKvi22U5csti4Dubb-4A.png" />


Your key will be enabled and ready to use in a couple of seconds:

<DashImage src="images/18Opaixc6Ardgd0wYKyvKNw.png" />


Note your API key. We’ll use it when we fetch the Maps JavaScript library:

```
[https://maps.googleapis.com/maps/api/js?key=**KEY_GOES_HERE**](https://maps.googleapis.com/maps/api/js?key=KEY_GOES_HERE)
```


In JavaScript, to create a map instance and place a marker on it, we’d use the following code:

```
var hostElement = document.getElementById('map-id');
var map = new google.maps.Map(hostElement, {
  zoom: 2,
  center: {lat: 47.4979, lng: 19.0402}
});
var marker = new google.maps.Marker({
  position: {lat: 47.4979, lng: 19.0402},
  map: map,
  label: 'A'
});
```


As you will see later, the Dart code will be very similar (with all of the added benefits of Dart).

## The AngularDart Application

The easiest way to get started with an AngularDart application is to follow the [Get Started](https://webdev.dartlang.org/guides/get-started) guide and [create a new project](https://webdev.dartlang.org/guides/get-started#4-create-and-run-a-web-app) in WebStorm or in the Community Edition of IntelliJ IDEA.

In case you are using a different editor, or you just want to follow the structure of our example code, here is the bare minimum.

In the pubspec file, `pubspec.yaml`:

```
name: google_maps_angular_dart
version: 0.0.1
description: Angular application with Google Maps integration

environment:
  sdk: '>=1.19.0 <2.0.0'

dependencies:
  angular2: ^2.2.0

dev_dependencies:
  dart_to_js_script_rewriter: ^1.0.1

transformers:
- angular2:
    platform_directives:
      - 'package:angular2/common.dart#COMMON_DIRECTIVES'
    platform_pipes:
      - 'package:angular2/common.dart#COMMON_PIPES'
    entry_points: web/main.dart
- dart_to_js_script_rewriter
```


In the host page, `web/index.html`:

```
<!DOCTYPE html>
<html>
<head>
    <!-- other headers -->
    <script defer src="main.dart" type="application/dart"></script>
</head>
<body>
   **<map-control></map-control>**
</body>
</html>
```


In the app’s entry point, `web/main.dart`:

```
import 'package:angular2/platform/browser.dart';
import 'package:google_maps_angular_dart/component/map_control.dart';

void main() {
  bootstrap(MapControl);
}
```


In the Dart file for the `&lt;map-control&gt;` component, `lib/component/map_control.dart`:

```
import 'package:angular2/core.dart';

@Component(
  selector: 'map-control',
  template: '{{distance}}',
)
class MapControl {
  String distance = 'no distance yet';
}
```


The above code won’t do too much, but it is a start and you can run it by using `pub serve` and then opening the page in Dartium:

```
$ pub serve
Loading source assets...
Loading angular2 and dart_to_js_script_rewriter transformers...
Serving google_maps_angular_dart web on [http://localhost:8080](http://localhost:8080)
Build completed successfully
```


## Google Maps integration

To start with the Google Maps integration, put the following script tag into your `web/index.html`. Notice that you need to set your API key:

```
<script src="https://maps.googleapis.com/maps/api/js?key=**[YOUR_KEY_HERE]**"></script>
```


Fortunately there is a ready-to-use Google Maps Dart package on pub. Add it to your `pubspec.yaml`:

```
dependencies:
  angular2: ^2.2.0
  **google_maps: ^3.0.0**
```


Then run `pub get` to download the package.

We need to create a host element for the map area in our component template. We will start with basic styling, and use the `#mapArea` anchor to identify the element in the next step:

```
<div style="width: 300px; height: 300px" #**mapArea**>[map]</div>
```


In the component code, we can inject the element’s reference as follows:

```
@ViewChild('mapArea')
ElementRef mapAreaRef;
```


The element reference is not available immediately after the MapControl class has been created, so we need to hook into Angular’s lifecycle callbacks:

```
class MapControl **implements AfterViewInit** {

  @override
  void ngAfterViewInit() {
    // mapAreaRef is available now
  }
}
```


Tip: use the IDE to write the method bodies for you. For example, in IntelliJ, hit `CMD + N` (or `CTRL + N`), and select the “Implement Methods…” menu item. It will allow you to select the missing methods and you need to worry only about the method body:

<DashImage src="images/1V9N-6dAV8vZjuT6cI1Sftw.png" />


As the following code shows, the Dart API is very similar to to the JavaScript one, with the added benefit that it is type checked.

```
class MapControl implements AfterViewInit {
  // ...

@override
  void ngAfterViewInit() {
    GMap map = new GMap(
        mapAreaRef.nativeElement,
        new MapOptions()
          ..zoom = 2
          ..center = new LatLng(47.4979, 19.0402)
                             // ^ Budapest, Hungary
        );
    new Marker(new MarkerOptions()
      ..map = map
      ..position = new LatLng(47.4979, 19.0402)
      ..label = 'A');
  }
}
```


One example of the benefits of type checking is that when we listen for events, we don’t need to think about how to access properties. For example, the IDE can help us find the MouseEvent property (`latLng`) that holds the location of the marker.

Here is the code that reacts to dragging the marker:

```
    marker.onDrag.listen((MouseEvent event) {
      print('New location while dragging: ${event.latLng}');
    });
```


Capturing click events on the map is similar:

```
    map.onClick.listen((MouseEvent event) {
      print('User clicked on position: ${event.latLng}');
    });
```


## Putting it together

To measure the distance between two coordinates, we will track two markers on the map. The user shall be able to drag the markers around or place them by clicking.

We need to keep track of the map and the markers as fields:

```
  GMap _map;
  Marker _aMarker;
  Marker _bMarker;
```


Update the initialization to store the map reference and to register a click handler. The click handler updates the marker positions and the distance:

```
  @override
  void ngAfterViewInit() {
    **_map** = new GMap(
        mapAreaRef.nativeElement,
        new MapOptions()
          ..zoom = 2
          ..center = new LatLng(47.4979, 19.0402)
                             // ^ Budapest, Hungary
        );
    **_map.onClick**.listen((MouseEvent event) {
      **_updatePosition**(event.latLng);
      **_updateDistance**();
    });
  }
```


Here is the code for the first part of the click handler:

```
  void _updatePosition(LatLng position) {
    if (_aMarker == null) {
      _aMarker = _createMarker(_map, 'A', position);
    } else if (_bMarker == null) {
      _bMarker = _createMarker(_map, 'B', position);
    } else {
      _aMarker.position = _bMarker.position;
      _bMarker.position = position;
    }
  }
```


The code for marker instantiation is similar to the earlier example:

```
  Marker _createMarker(GMap map, String label, LatLng position) {
    final Marker marker = new Marker(new MarkerOptions()
      ..map = map
      ..draggable = true
      ..label = label
      ..position = position);
    marker.onDrag.listen((MouseEvent event) {
      _updateDistance();
    });
    return marker;
  }
```


With the help of utility functions from `dart:math`, we are able to crunch through the mathematics of the great circle distance calculation, and set the value in our `distance` field:

```
  /// Radius of the earth in km.
  const int radiusOfEarth = 6371;

double _toRadian(num degree) => degree * PI / 180.0;

void _updateDistance() {
    if (_aMarker == null || _bMarker == null) return;
    LatLng a = _aMarker.position;
    LatLng b = _bMarker.position;
    double dLat = _toRadian(b.lat - a.lat);
    double sLat = pow(sin(dLat / 2), 2);
    double dLng = _toRadian(b.lng - a.lng);
    double sLng = pow(sin(dLng / 2), 2);
    double cosALat = cos(_toRadian(a.lat));
    double cosBLat = cos(_toRadian(b.lat));
    double x = sLat + cosALat * cosBLat * sLng;
    double d = 2 * atan2(sqrt(x), sqrt(1 - x)) * radiusOfEarth;
    distance = '${d.round()} km';
  }
```


Have you ever wondered how far do you live from a relative, a famous location or a landmark? It is time to try out the application and check it for yourself. It turns out that my home is 9815 km from Google Headquarters in Mountain View:

<DashImage src="images/1AOtq_2d-f5cETtXb-ixzYA.png" alt="The distance between Googleplex in Mountain View, California and the author’s home in Budapest, Hungary" caption="The distance between Googleplex in Mountain View, California and the author’s home in Budapest, Hungary" />


## Polishing the application

The Google Maps integration in our Angular app is complete at this point. We are listening and reacting to map events and creating objects on the map. In this last section we will implement features that add a nice finish for our demo.

### Separate template and style

It is a good practice to put complex UI template in a separate .html file. We can do the same with CSS styles:

```
@Component(
    selector: 'map-control',
    templateUrl: 'map_control.html',
    styleUrls: const <String>['map_control.css'])
class MapControl implements AfterViewInit {
```


The map element has a CSS class, map-area:

```
<div class="map-area" #mapArea>[map]</div>
```


Our CSS file can be as simple as this:

```
.map-area {
  width: 500px;
  height: 400px;
  margin: 10px;
}
```


### Handling the unit of distance

Some people are fluent in km ⟷ miles conversions, but the rest of us would like a dropdown where we can select the distance unit. In the HTML template the dropdown can be a simple `&lt;SELECT&gt;` element with a model binding to the `unit` field.

```
<label>Unit:</label>
<select [(ngModel)]="**unit**">
  <option value="km">km</option>
  <option value="miles">miles</option>
</select>
```


In the Dart code, we want to store the unit and to update the distance whenever the unit is updated:

```
String _unit = 'km';

String get unit => _unit;

set unit(String value) {
  _unit = value;
  _updateDistance();
}
```


And don’t forget to update the previously hardcoded `km` in the distance calculation:

```
    /// Const value to convert from km to miles.
    const double milesPerKm = 0.621371;

    // ... same code as earlier
    if (unit == 'miles') {
      d *= milesPerKm;
    }
    distance = '${d.round()} $unit';
```


### Formatting the coordinates

What if we are interested in publishing the position of our markers? The easiest way would be to expose the position values in Dart, so we can use `{{a}}` and `{{b}}` in our template:

```
  // Expose the position values.
  LatLng get a => _aMarker?.position;
  LatLng get b => _bMarker?.position;
```


The template can hide the label when the marker is not initialized yet, preventing potential issues with null values:

```
  <div *ngIf="a != null">A: {{a}}</div>
  <div *ngIf="b != null">B: {{b}}</div>
```


However, `{{a}}` would translate to calling `LatLng.toString()`, and it would give us two really long double values, whereas a few digits would be just fine. One solution is to use pipes in the template:

```
<div *ngIf="a != null">A: {{a.lat | number : '1.4-4'}}, {{a.lng | number : '1.4-4'}}</div>
<div *ngIf="b != null">B: {{b.lat | number : '1.4-4'}}, {{b.lng | number : '1.4-4'}}</div>
```


The [template syntax guide](https://webdev.dartlang.org/angular/guide/template-syntax) suggests placing that logic in the controller class, for better testing:

```
  /// Formatted position of the 'A' marker.
  String get **aPosition** => _formatPosition(a);

  /// Formatted position of the 'B' marker.
  String get bPosition => _formatPosition(b);

  String _formatPosition(LatLng pos) {
    if (pos == null) return null;
    return '${pos.lat.toStringAsFixed(4)}, ' 
        '${pos.lng.toStringAsFixed(4)}';
  }
```


With that, the template can be much simpler:

```
<div *ngIf="a != null">A: {{**aPosition**}}</div>
<div *ngIf="b != null">B: {{**bPosition**}}</div>
```


### Clean up the template

As a last step, move all of the remaining code parts from the template to the controller:

```
  /// Whether the 'A' marker's positions should be shown
  bool get **showA** => a != null;

  /// Whether the 'B' marker's positions should be shown
  bool get showB => b != null;

  /// Whether the 'distance' label should be shown
  bool get showDistance => distance != null;
```


Doing so, the template references only the getters:

```
<div *ngIf="**showA**">A: {{aPosition}}</div>
<div *ngIf="**showB**">B: {{bPosition}}</div>

<p *ngIf="showDistance">
  Distance: {{distance}}<br/>
</p>
```


## Closing notes

As you can see, implementing two-way integration with Google Maps is easy: the source code is clean and readable. With the full support of the Dart toolchain, it is easily extensible, without ever worrying about what we may break at other places.

As an exercise for the reader, you can add [heatmap visualization](https://developers.google.com/maps/documentation/javascript/earthquakes#heatmaps) to the map using the same API in Dart. Check out the [google_maps](https://pub.dartlang.org/packages/google_maps) package for all of the possibilities.