"""
LocationManager class

- enabled 	   <bool>
- latitude 	   <number> readonly
- longitude    <number> readonly
- errorMessage <string or null> readonly

- distanceTo(destinationCoordinates) returns <number> (meters)
- headingTo(destinationCoordinates)  returns <number> (degrees)

class methods
- available() returns <bool>

events
- onLocationChange (data {latitude, longitude})
- onLocationError  (message <string>)
"""

Events.LocationChange = "geolocationchange"
Events.LocationError = "geolocationerror"

class exports.LocationManager extends Framer.BaseClass
	
	constructor: () ->
		@enabled = true
		@degToRad = Math.PI / 180
	
	@define "enabled",
		get: -> return @_activeWatchId?
		set: (setActive) ->
			if setActive
				@_activeWatchId = navigator.geolocation.watchPosition(@_updatePosition, @_positionError) if LocationManager.available() and not @enabled
			else
				navigator.geolocation.clearWatch(@_activeWatchId) if @enabled
				@_activeWatchId = null
	
	@define "latitude",
		get: -> @_latitude
	
	@define "longitude",
		get: -> @_longtitude

	@define "errorMessage",
		get: -> @_errorMessage

	distanceTo: (bCoordinates...) ->
		{lat2, lon2} = @_normalizeCoordinates(bCoordinates)
		return false unless @latitude? and @longitude? and lat2? and lon2?
		R = 6371000 # metres
		φ1 = @latitude * @degToRad
		φ2 = lat2 * @degToRad
		Δφ = (lat2-@latitude) * @degToRad
		Δλ = (lon2-@longitude) * @degToRad
		a = Math.sin(Δφ/2) * Math.sin(Δφ/2) + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ/2) * Math.sin(Δλ/2)
		c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
		d = R * c
		return d

	headingTo: (bCoordinates...) ->
		{lat2, lon2} = @_normalizeCoordinates(bCoordinates)
		return false unless @latitude? and @longitude? and lat2? and lon2?
		lat1 = @latitude * @degToRad
		lat2 = lat2 * @degToRad
		lon1 = @longitude * @degToRad
		lon2 = lon2 * @degToRad
		angle = Math.atan2(Math.sin(lon2 - lon1) * Math.cos(lat2), Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
		heading = angle * 180 / Math.PI
		heading += 360 if heading < 0
		return heading

	_updatePosition: (location) =>
		@_errorMessage = null
		@_latitude = location.coords.latitude
		@_longtitude = location.coords.longitude
		coords = {latitude: @_latitude, longitude: @_longtitude}
		@emit(Events.LocationChange, coords)
	
	_positionError: (error) =>
		@_errorMessage = error.message
		@emit(Events.LocationError, error.message)

	_normalizeCoordinates: (input) ->
		coord = {}
		for item in input
			if item.latitude? and item.longitude?
				coord.lat2 = item.latitude if _.isNumber(item.latitude)
				coord.lon2 = item.longitude if _.isNumber(item.longitude)
			if _.isNumber(item)
				if not coord.lat2?
					coord.lat2 = item
				else if not coord.lon2?
					coord.lon2 = item
		return coord

	toInspect: =>
		"<#{@constructor.name} lat:#{@latitude} lon:#{@longitude}>"

	# class methods

	@available: -> "geolocation" in _.keys(navigator)

	# event shortcuts

	onLocationChange:(cb) -> @on(Events.LocationChange, cb)
	onLocationError:(cb)  -> @on(Events.LocationError, cb)
