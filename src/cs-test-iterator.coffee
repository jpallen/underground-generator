define ["cs!data", "cs!map-generator", "cs!renderer"], (data, MapGenerator, Renderer) ->
	$ () ->
		mapGenerator = new MapGenerator(data)
		displayData = mapGenerator.displayData

		render = () ->
			renderer = new Renderer displayData.nodes, displayData.tracks,
				element: $("#rendered-map")
			renderer.draw()
		setInterval render, 10

		mapGenerator.makeNice () ->
			clearInterval render
