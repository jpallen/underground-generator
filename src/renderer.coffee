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
					@drawTrackLine(track.colour,prevNode.position,thisNode.position)
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

		drawNode: (node) ->
			ctx.save()
			ctx.translate(node.position.x,node.position.y)

			if node.type == 'interchange' or !node.type?
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
				
			ctx.restore()
			
		clear: () ->
			ctx.clearRect(0, 0, canvas.width, canvas.height);
