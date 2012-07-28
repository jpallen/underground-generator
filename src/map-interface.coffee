define ["../lib/mustache"], (Mustache) ->
	class Track
		constructor: (@map, @name) ->
			@nodes = []
			@renderInSidebar()

		addNode: (node) ->
			@nodes.push(node)
			if @currentNode?
				@currentNode.connectTo node
			@currentNode = node
			@renderNodeInSidebar node

		renderInSidebar: () ->
			template =
				"""
				<div class="track">
					<div class="name">{{name}}</div>
					<ul class="nodes">
					</ul>
				</div>
				"""
			@$sidebarEl = $(Mustache.render(template, {
				name: @name
			}))
			@$sidebarEl.insertBefore $("#add-track")

		renderNodeInSidebar: (node) ->
			template =
				"""
				<li class="node">{{name}}</li>
				"""
			$nodeEl = $(Mustache.render(template, {
				name: node.name
			}))
			@$sidebarEl.find("ul").append $nodeEl
			node.on "change:name", (name) ->
				$nodeEl.text(name)

	class Node
		constructor: (@map, position) ->
			_.extend this, Backbone.Events
			@connections = []
			@marker = new google.maps.Marker
				map: @map
				draggable: true
				animation: google.maps.Animation.DROP
				position: position
			@updateName()
			google.maps.event.addListener @marker, "dragend", () => @updateName()
			google.maps.event.addListener @marker, "click", (e) =>
				@trigger "click", e

		updateName: () ->
			@name = "Loading..."
			@trigger("change:name", @name)
			@geocoder ||= new google.maps.Geocoder()
			@geocoder.geocode {latLng: @marker.position}, (results, status) =>
				@name = results[0].formatted_address.split(",")[0]
				@trigger("change:name", @name)

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
			@initMap()
			@tracks = []
			@addTrack()
			$("#add-track").click () => @addTrack()

		initMap: () ->
			@map = new google.maps.Map @element[0],
				center: new google.maps.LatLng(54.7771, -1.5607)
				zoom: 14
				mapTypeId: google.maps.MapTypeId.ROADMAP

			google.maps.event.addListener @map, "click", (e) =>
				@addNewNode e.latLng

		addNewNode: (position) ->
			if @currentTrack?
				node = new Node @map, position
				@currentTrack.addNode node
				node.on "click", () => @addExistingNode(node)

		addExistingNode: (node) ->
			if @currentTrack
				@currentTrack.addNode node

		addTrack: () ->
			@currentTrack = new Track @map, "Untitled"
			@tracks.push @currentTrack
			
