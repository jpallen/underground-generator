define [
	"cs!renderer",
	"cs!map-interface"
], (Renderer, MapInterface) ->
	App = class App
		constructor: () ->
			@renderer = new Renderer
				element: $("#rendered-map")
			@mapInterface = new MapInterface
				element: $("#google-map")

	$ () ->
		app = new App()
		app.renderer.clear()
		app.renderer.draw()