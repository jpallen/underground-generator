define () ->
	class Node
		constructor: (@name,x,y) ->
			@position = {}
			@position.x = x
			@position.y = y
			@type = "stop"
