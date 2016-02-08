# LocationManager

With the location manager we can get location updates using a Framer style API.

## Example

- [current distance and heading to NY](http://share.framerjs.com/hv9aj1uy1gfa/)

## Properties

- **`enabled`** *\<bool>*
- **`available`** *\<bool>*
- **`latitude`** *\<number>* (90 to -90 degrees)
- **`longitude`** *\<number>* (180 to -180 degrees)

```coffee
# Include the LocationManager
{LocationManager} = require "VRComponent"

locManager = new LocationManager
```

## Functions

- **`distance(locationBCoordinates)`** -> <number> (meters)
- **`heading(locationBCoordinates)`** -> <number> (degrees)

```coffee

NY =
	latitude: 40.748817
	longitude: -73.985428

distanceToNY = locManager.distance(NY)
```

## Events

- **`Events.LocationChange`**, (*\<object>* {latitude, longitude})

```coffee
locManager.onLocationChange (data) ->
	latitude = data.latitude
	longitude = data.longitude
```
