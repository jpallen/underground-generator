define [
	"cs!map-interface"
], (MapInterface) ->
	App = class App
		constructor: () ->
			@mapInterface = new MapInterface
				element: $("#google-map")

	$ () ->
		app = new App()
