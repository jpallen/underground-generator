define [
	"cs!map-interface"
], (MapInterface) ->
	App = class App
		constructor: () ->
			@mapInterface = new MapInterface
				element: $("#google-map")

	$ () ->
		window.app = new App()
