# LocationManager

With the location manager we can get location updates using a [Framer](http://framerjs.com) style API.

## Example

- [current distance and heading to NY](http://share.framerjs.com/hv9aj1uy1gfa/)

## Properties

- **`enabled`** *\<bool>*
- **`latitude`** *\<number>* (90 to -90 degrees) readonly
- **`longitude`** *\<number>* (180 to -180 degrees) readonly
- **`errorMessage`** *\<string or null>* readonly

```coffee
# Include the LocationManager
{LocationManager} = require "LocationManager"

locManager = new LocationManager
```

## Functions

- LocationManager.**`available()`** returns *\<bool>*

- **`distance(locationBCoordinates)`** returns *\<number>* (meters)
- **`heading(locationBCoordinates)`** returns *\<number>* (degrees)

```coffee

NY =
	latitude: 40.748817
	longitude: -73.985428

distanceToNY = locManager.distance(NY)
headingToNY = locManager.heading(NY)
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
