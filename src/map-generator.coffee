define ["cs!force-iterator"], (ForceIterator) ->
	class MapGenerator
		constructor: (@nodes, @tracks) ->
		
		makeNice: () ->
			iterator = new ForceIterator(@nodes, @tracks)
			iterator.run()

