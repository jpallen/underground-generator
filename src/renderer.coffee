define () ->

	canvas = $("#canvas")[0]
	ctx  = canvas.getContext("2d")
	
	resizeCanvas = () -> 
		canvas.width = 1024
		canvas.height = 768
		
	resizeCanvas()
	
	$(window).resize(resizeCanvas)
	
	nodeRadius = 7
	nodeFillColour = 'black'
	trackWidth = 5
	
	class node
		constructor: (@name,x,y) ->
			@position = {}
			@position.x = x
			@position.y = y
	
	class track
		constructor: (@name,@nodeList,@colour) ->
		
	nodes = [
		new node('station1',100,100),
		new node('station2',100,200),
		new node('station3',200,200),
		new node('station3',300,300)
		
		]
	
	tracks = [
		new track('waterloo',[0,1],'blue'),
		new track('bakerloo',[1,2],'green'),
		new track('victoria',[0,2,3],'brown')
		]
	
	drawNode = (node) ->
		ctx.save()
		ctx.translate(node.position.x,node.position.y)
		ctx.fillStyle = nodeFillColour
		ctx.fillRect(-nodeRadius,-nodeRadius,2*nodeRadius,2*nodeRadius)
		ctx.restore()
	
	drawTrack = (track) ->
		prevNode = nodes[track.nodeList[0]]
		console.log([1..track.nodeList.length])
		
		for arrayIndex in [1..track.nodeList.length-1]
			do (arrayIndex) ->
				thisNode = nodes[track.nodeList[arrayIndex]]
				console.log(prevNode.position.x,prevNode.position.y)
				drawTrackLine(track.colour,prevNode.position,thisNode.position)
				prevNode = thisNode
	
	drawTrackLine = (colour,start,stop) ->
		ctx.save()
		
		ctx.strokeStyle = colour
		ctx.lineWidth = trackWidth
		
		ctx.beginPath()
		ctx.moveTo(start.x,start.y)
		ctx.lineTo(stop.x,stop.y)
		ctx.closePath()
		
		ctx.stroke()
		ctx.restore()
	
	drawMap = () -> 
		for aTrack in tracks
			do (aTrack) ->
				drawTrack(aTrack)
		for aNode in nodes
			do (aNode) ->
				drawNode(aNode)
	
	class Renderer
		constructor: (options) ->
			@element = options.element
		draw: () ->
			drawMap(nodes,tracks)
		clear: () ->
			ctx.clearRect(0, 0, canvas.width, canvas.height);
