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
			canvas = $("canvas")[0]
			canvas.width = $("#rendered-map").width()
			canvas.height = $("#rendered-map").height()
			console.log $("#rendered-map").width()
			console.log canvas.width, canvas.height

			clearInterval @renderIntervalId
			mapData = @mapInterface.export(0, 0, canvas.width, canvas.height)
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
		$("#view-map-tab").on "shown", () -> app.generateMap()
