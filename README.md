# LocationManager

Useful location data for [Framer](http://framerjs.com) prototypes. Find out where the user is located and get distance and heading to other locations.

## Example

- [current distance and heading to NY](http://share.framerjs.com/hv9aj1uy1gfa/)

## Properties

- **`enabled`** *\<bool>*
- **`latitude`** *\<number>* readonly (90 to -90 degrees)
- **`longitude`** *\<number>* readonly (180 to -180 degrees)
- **`errorMessage`** *\<string or null>* readonly

```coffee
# Include the LocationManager
{LocationManager} = require "LocationManager"

locManager = new LocationManager
```

## Functions

- LocationManager.**`available()`** returns *\<bool>* (whether current device supports location data)
- **`distanceTo(destinationCoordinates)`** returns *\<number>* (meters)
- **`headingTo(destinationCoordinates)`** returns *\<number>* (degrees)

```coffee

NY =
	latitude: 40.748817
	longitude: -73.985428

distanceToNY = locManager.distanceTo(NY)
headingToNY = locManager.headingTo(NY)
```

## Events

- **`onLocationChange`** (data *\{latitude, longitude}*)
- **`onLocationError`**  (message *\<string>*)

```coffee
locManager.onLocationChange (data) ->
	latitude = data.latitude
	longitude = data.longitude

locManager.onLocationError (message) ->
	print message
```
