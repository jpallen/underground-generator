define () ->
	class Track
		constructor: (@name,@nodeList,@colour) ->

		links: () ->
			links = []
			for nodeIndex in @nodeList
				if prevNodeIndex?
					links.push [prevNodeIndex, nodeIndex]
				prevNodeIndex = nodeIndex
			return links
