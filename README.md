# LocationManager

With the location manager we can get location updates using a Framer style API.

## Properties

- **`enabled`** *\<bool>*
- **`available`** *\<bool>*
- **`latitude`** *\<number>* (90 to -90 degrees)
- **`longitude`** *\<number>* (180 to -180 degrees)

```coffee
# Include the LocationManager
{LocationManager} = require "VRComponent"
```

## Functions

- **`distance(coordinates2)`** -> <number> (meters)
- **`heading(coordinates2)`** -> <number> (degrees)

## Events

- **`Events.LocationChange`**, (*\<object>* {latitude, longitude})

```coffee

NY =
	latitude: 40.748817
	longitude: -73.985428

locManager.onLocationChange (data) ->
	latitude = data.latitude
	longitude = data.longitude

	distanceToNY = locManager.distance(NY)
```
