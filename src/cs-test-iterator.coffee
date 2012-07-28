define ["cs!data", "cs!force-iterator", "cs!renderer"], (data, ForceIterator, Renderer) ->
	$ () ->
		iterator = new ForceIterator(data.nodes, data.tracks)
		renderer = new Renderer data.nodes, data.tracks,
			element: $("#rendered-map")
		setInterval((() ->
			iterator.step()
			renderer.draw()
		), 10)
