define ["cs!track", "cs!node", "cs!force-iterator"], (Track, Node, ForceIterator) ->
	class MapGenerator
		constructor: (data) ->
			colors = [
				"red",
				"blue",
				"green",
				"orange",
				"brown",
				"black"
			]
			colorIndex = 0
			@displayData = {
				nodes: for node in data.nodes
					new Node(node.name,node.position.x,node.position.y)
				tracks: for track in data.tracks
					colorIndex++
					colorIndex = 0 if colorIndex > colors.length
					new Track(track.name,track.line, colors[colorIndex])
			}
			@assignIntersections()

		assignIntersections: () ->
			nodeTracks = {}

			for track, trackIndex in @displayData.tracks
				for nodeIndex in track.nodeList
					nodeTracks[nodeIndex] ||= []
					nodeTracks[nodeIndex].push trackIndex

			for track, trackIndex in @displayData.tracks
				alongsideTrackIndices = []
				for nodeIndex in track.nodeList
					otherTrackIndices = nodeTracks[nodeIndex]

					# make it an intersection is we join a new track
					for otherTrackIndex in otherTrackIndices
						unless otherTrackIndex == trackIndex
							if alongsideTrackIndices.indexOf(otherTrackIndex) == -1
								@displayData.nodes[nodeIndex].type = "interchange"
								alongsideTrackIndices.push otherTrackIndex

			for track, trackIndex in @displayData.tracks
				alongsideTrackIndices = []
				for nodeIndex in track.nodeList.reverse()
					otherTrackIndices = nodeTracks[nodeIndex]

					# make it an intersection is we join a new track
					for otherTrackIndex in otherTrackIndices
						unless otherTrackIndex == trackIndex
							if alongsideTrackIndices.indexOf(otherTrackIndex) == -1
								@displayData.nodes[nodeIndex].type = "interchange"
								alongsideTrackIndices.push otherTrackIndex
				track.nodeList.reverse()

		makeNice: (callback) ->
			iterator = new ForceIterator(@displayData.nodes, @displayData.tracks)
			runner = () =>
				delta = iterator.step()
				if delta < 1
					clearInterval runner
					callback(@displayData)

			setInterval runner, 0

