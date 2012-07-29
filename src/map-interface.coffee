define ["../lib/mustache"], (Mustache) ->
	colors = [
		"#263d96", "#ee2622", "#fdd005",
		"#098137", "#960154", "#f468a1",
		"#000000",
		"#2d9edf", "#ae520e"
	]
	currentColor = -1
	getNextColor = () ->
		currentColor = (currentColor + 1) % colors.length
		return colors[currentColor]

	names = [
		"Picadilly", "Central", "Circle",
		"District", "Metropolitan", "Hammersmith & City",
		"Northern", "Victoria", "Bakerloo"
	]
	currentName = -1
	getNextName = () ->
		currentName = (currentName + 1) % names.length
		return names[currentName]

	class Track
		constructor: (@map, @name) ->
			_.extend this, Backbone.Events
			@nodes = []
			@color = getNextColor()
			@renderInSidebar()

		addNode: (node) ->
			node.track = this
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
			@$el = $(Mustache.render(template, {
				name: @name
				color: @color
			}))
			@$el.insertBefore $("#add-track")
			@on "change:name", =>
				@$el.find(".name").text(@name)

		renderNodeInSidebar: (node) ->
			template =
				"""
				<li class="node">{{name}}</li>
				"""
			$nodeEl = $(Mustache.render(template, {
				name: node.name
			}))
			@$el.find("ul").append $nodeEl
			node.on "change:name", (name) ->
				$nodeEl.text(name)

		select: () ->
			@$el.css({
				color: "white"
				"background-color": @color
			})

		unselect: () ->
			@$el.css({
				color: @color
				"background-color": "white"
			})

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
				if results? and results.length > 0
					@name = results[0].formatted_address.split(",")[0]
				else
					@name = "Unknown"
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
				strokeWeight: 4
				strokeColor: @from.track.color
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
			@nodes = []
			@addTrack()
			$("#add-track").click () => @addTrack()
			$("#rename-track-modal a").on "click", () =>
				@finishRename()

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
				@nodes.push node
				@currentTrack.addNode node
				node.on "click", () => @addExistingNode(node)

		addExistingNode: (node) ->
			if @currentTrack
				@currentTrack.addNode node

		addTrack: () ->
			track = new Track @map, getNextName()
			@tracks.push track
			@changeTrack(track)
			track.$el.on "dblclick", () =>
				@renameTrack(track)
			track.$el.on "click", () =>
				@changeTrack(track)

		changeTrack: (track) ->
			@currentTrack = track
			for oldTrack in @tracks
				oldTrack.unselect()
		 	track.select()

		renameTrack: (track) ->
			$("#track-name").val(track.name)
			$("#rename-track-modal").modal()

		finishRename: (track) ->
			console.log "done"
			@currentTrack.name = $("#track-name").val()
			@currentTrack.trigger("change:name")
			$("#rename-track-modal").modal("hide")

		export: (x, y, width, height) ->
			json =
				nodes: []
				tracks: []

			for node in @nodes
				node.index = json.nodes.length
				json.nodes.push
					name: node.name
					position:
						x: -node.marker.position.lat()
						y: node.marker.position.lng()
			
			for track in @tracks
				json.tracks.push
					name : track.name
					line : (node.index for node in track.nodes)

			for node in json.nodes
				if !minX? or node.position.x < minX
					minX = node.position.x
				if !maxX? or node.position.x > maxX
					maxX = node.position.x
				if !minY? or node.position.y < minY
					minY = node.position.y
				if !maxY? or node.position.y > maxY
					maxY = node.position.y

			xScaleFactor = width / (maxX - minX)
			yScaleFactor = height / (maxY - minY)
			
			for node in json.nodes
				node.position.x = (node.position.x - minX) * xScaleFactor + x
				node.position.y = (node.position.y - minY) * yScaleFactor + y

			return JSON.stringify(json)
			
