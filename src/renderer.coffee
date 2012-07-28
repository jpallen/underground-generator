define ["cs!node", "cs!track"], (Node, Track) ->
	canvas = $("#canvas")[0]
	ctx  = canvas.getContext("2d")
	
	resizeCanvas = () -> 
		canvas.width = 1024
		canvas.height = 768
		
	resizeCanvas()
	
	$(window).resize(resizeCanvas)
	
	nodeRadius = 10
	nodeRadius2 = 7
	
	nodeFillColour = 'white'
	nodeEdgeColour = 'black'
	trackWidth = 5
	
	class Renderer
		constructor: (@nodes, @tracks, options) ->
			@element = options.element
			
			@expandDataSet()
		
		expandDataSet: () ->
		
			for aNode in @nodes
				aNode.trackList = []
		
			console.log("expanding...")
			
			i=-1
			
			for aTrack in @tracks
				do (aTrack) =>
					i=i+1
					for aNodeIndex in aTrack.nodeList
						do (aNodeIndex) => 
							@nodes[aNodeIndex].trackList.push(i)
							
			for aNode in @nodes
				aNode.trackList.sort()
				
				prevVal = -1;
				newArray = []
				for i in [0..aNode.trackList.length-1]
					if aNode.trackList[i] != prevVal
						newArray.push(aNode.trackList[i])
					prevVal = aNode.trackList[i]
				
				aNode.trackList = newArray
				
				console.log newArray

		draw: () ->
			ctx.clearRect(0,0,canvas.width, canvas.height)
			for aTrack in @tracks
				do (aTrack) =>
					@drawTrack(aTrack)
			for aNode in @nodes
				do (aNode) =>
					@drawNode(aNode)

		drawTrack: (track) ->
			prevNode = @nodes[track.nodeList[0]]
			
			for arrayIndex in [1..track.nodeList.length-1]
				do (arrayIndex) =>
					thisNode = @nodes[track.nodeList[arrayIndex]]
					@drawAllTracksBetweenNodes(prevNode,thisNode)
					prevNode = thisNode

		drawTrackLine: (colour, start, stop) ->
			ctx.save()
			
			ctx.strokeStyle = colour
			ctx.lineWidth = trackWidth
			
			ctx.beginPath()
			ctx.moveTo(start.x,start.y)
			ctx.lineTo(stop.x,stop.y)
			ctx.closePath()
			
			ctx.stroke()
			ctx.restore()
			
		drawAllTracksBetweenNodes: (nodeA,nodeB) ->
			localTracks = @trackUnion(nodeA,nodeB) 
			norm = @nodesUnitNormal(nodeA,nodeB)
			for i in [0..localTracks.length-1]
				offset = i*trackWidth
				start = {x:nodeA.position.x + norm[0]*offset,y:nodeA.position.y + norm[1]*offset}
				stop = {x:nodeB.position.x + norm[0]*offset,y:nodeB.position.y + norm[1]*offset}
				@drawTrackLine(@tracks[localTracks[i]].colour,start,stop)
				
		nodesDist: (nodeA,nodeB) ->
			Math.sqrt(
				Math.pow(nodeA.position.x - nodeB.position.x, 2) +
				Math.pow(nodeA.position.y - nodeB.position.y, 2)
			)

				
		nodesUnitNormal: (nodeA,nodeB) ->
			dist = @nodesDist(nodeA,nodeB)
			if dist < 0.1
				return [0,0]
			[
				-(nodeB.position.y - nodeA.position.y) / dist
				(nodeB.position.x - nodeA.position.x) / dist
			]

			
		trackUnion: (nodeA,nodeB) ->
			union = []
			for track in nodeA.trackList
				do (track) ->
					for otherTrack in nodeB.trackList
						do (otherTrack) ->
							if track == otherTrack
								union.push(track)
			return union

		drawNode: (node) ->
			ctx.save()
			ctx.translate(node.position.x,node.position.y)

			if node.type == 'interchange' 
				ctx.fillStyle = nodeEdgeColour
				
				ctx.beginPath()
				ctx.arc(0,0,nodeRadius,0,6.29,0)
				ctx.closePath()			
				ctx.fill()
	
				ctx.fillStyle = nodeFillColour
	
				ctx.beginPath()
				ctx.arc(0,0,nodeRadius2,0,6.29,0)
				ctx.closePath()			
				ctx.fill()
			#else if node.type=='stop' or !node.type?
				
				
				
			ctx.restore()
			
		clear: () ->
			ctx.clearRect(0, 0, canvas.width, canvas.height);
