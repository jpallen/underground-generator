define [
	"cs!map-interface",
	"cs!renderer",
	"cs!map-generator"
], (MapInterface, Renderer, MapGenerator) ->
	App = class App
		constructor: () ->
			@mapInterface = new MapInterface
				element: $("#google-map")

		generateMap: () ->
			clearInterval @renderIntervalId
			mapData = @mapInterface.export(0, 0, 800, 600)
			@mapGenerator = new MapGenerator(mapData)
			@mapGenerator.makeNice () =>
				clearInterval @render
				@render()
			displayData = @mapGenerator.displayData
			@renderer = new Renderer displayData.nodes, displayData.tracks, {
				element: $("#rendered-map")
			}
			@renderIntervalId = setInterval((() => @render()), 100)
			return true

		render: () ->
			@renderer.draw()

	$ () ->
		window.app = new App()
		$("#view-map-tab").on "click", () -> app.generateMap()
