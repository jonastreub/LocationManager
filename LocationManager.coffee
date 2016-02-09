"""
LocationManager class

- enabled 	<bool>
- available <bool> 		readonly
- latitude 	<number> 	readonly
- longitude <number> 	readonly

- distance(locationBCoordinates) -> <number>
- heading(locationBCoordinates) -> 	<number>

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

	distance: (bCoordinates...) ->
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

	heading: (bCoordinates...) ->
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

	# event shortcuts

	onLocationChange:(cb) -> @on(Events.LocationChange, cb)
