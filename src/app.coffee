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
		window.app = new App()
