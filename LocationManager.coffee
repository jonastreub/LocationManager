"""
LocationManager class

- enabled 	<bool>
- available <bool> 		readonly
- latitude 	<number> 	readonly
- longitude <number> 	readonly

- distance(bCoordinates) -> <number>
- heading(bCoordinates) -> 	<number>

events
- onLocationChange (data {latitude, longitude})
"""

Events.LocationChange = "geolocationchange"

class exports.LocationManager extends Framer.BaseClass
	
	constructor: () ->
		@enabled = true
		@degToRad = Math.PI / 180
	
	@define "enabled",
		get: -> return @_activeWatchId?
		set: (setActive) ->
			if setActive
				@_activeWatchId = navigator.geolocation.watchPosition(@_updatePosition) if @available and not @enabled
			else
				navigator.geolocation.clearWatch(@_activeWatchId) if @enabled
				@_activeWatchId = null
	
	_updatePosition: (location) =>
		@_latitude = location.coords.latitude
		@_longtitude = location.coords.longitude
		coords = {latitude: @_latitude, longitude: @_longtitude}
		@emit(Events.LocationChange, coords)
	
	@define "available",
		get: -> "geolocation" in _.keys(navigator)
	
	@define "latitude",
		get: -> @_latitude
	
	@define "longitude",
		get: -> @_longtitude

	distance: (bCoordinates, bCoordinates2) ->
		lat2 = bCoordinates.latitude
		lon2 = bCoordinates.longitude
		if _.isNumber(bCoordinates) and _.isNumber(bCoordinates2)
			lat2 = bCoordinates
			lon2 = bCoordinates2
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

	heading: (bCoordinates) ->
		lat2 = bCoordinates.latitude
		lon2 = bCoordinates.longitude
		if _.isNumber(bCoordinates) and _.isNumber(bCoordinates2)
			lat2 = bCoordinates
			lon2 = bCoordinates2
		return false unless @latitude? and @longitude? and lat2? and lon2?
		lat1 = @latitude * @degToRad
		lat2 = lat2 * @degToRad
		lon1 = @longitude * @degToRad
		lon2 = lon2 * @degToRad
		angle = Math.atan2(Math.sin(lon2 - lon1) * Math.cos(lat2), Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
		heading = angle * 180 / Math.PI
		heading += 360 if heading < 0
		return heading

	toInspect: =>
		"<#{@constructor.name} lat:#{@latitude} lon:#{@longitude}>"

	# event shortcuts

	onLocationChange:(cb) -> @on(Events.LocationChange, cb)
