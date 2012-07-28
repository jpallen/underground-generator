define () ->
	class Node
		constructor: (@map, position) ->
			@connections = []
			@marker = new google.maps.Marker
				map: @map
				draggable: true
				animation: google.maps.Animation.DROP
				position: position
			@updateName()
			google.maps.event.addListener @marker, "dragend", () => @updateName()

		updateName: () ->
			@geocoder ||= new google.maps.Geocoder()
			@geocoder.geocode {latLng: @marker.position}, (results, status) =>
				@name = results[0].formatted_address.split(",")[0]
				console.log @name

		connectTo: (node) ->
			line = new Line @map, this, node
			@connections.push(line)
			node.connections.push(line)
			return line

	class Line
		constructor: (@map, @from, @to) ->
			@line = new google.maps.Polyline
				map: @map
				path: [@from.marker.position, @to.marker.position]
			@listenForNodeUpdate(@from)
			@listenForNodeUpdate(@to)

		listenForNodeUpdate: (node) ->
			google.maps.event.addListener node.marker, "drag", () =>
				@line.setPath [@from.marker.position, @to.marker.position]

	class MapInterface
		constructor: (options) ->
			@element = options.element
			@nodes = []
			@lines = []
			@initMap()

		initMap: () ->
			@map = new google.maps.Map @element[0],
				center: new google.maps.LatLng(54.7771, -1.5607)
				zoom: 14
				mapTypeId: google.maps.MapTypeId.ROADMAP

			google.maps.event.addListener @map, "click", (e) =>
				@addNode e.latLng

		addNode: (position) ->
			node = new Node @map, position
			@nodes.push(node)
			if @currentNode?
				@currentNode.connectTo node
			@currentNode = node


