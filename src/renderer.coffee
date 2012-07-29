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
				
	
		draw: () ->
			
			ctx.clearRect(0,0,canvas.width, canvas.height)
			
			maxx = canvas.width/2
			maxy = canvas.height/2
			minx = canvas.width/2
			miny = canvas.height/2
			
			for aNode in @nodes
				do (aNode) =>
					aNode.nameRendered = false
					if aNode.position.x>maxx
						maxx = aNode.position.x
					if aNode.position.x<minx
						minx = aNode.position.x
					if aNode.position.y>maxy
						maxy = aNode.position.y
					if aNode.position.y<miny
						miny = aNode.position.y
					
			avx = (minx+maxx)/2
			avy = (miny+maxy)/2
			
			ctx.save()
			ctx.translate(avx/2,avy/2)
			
			#ctx.scale(0.7,0.7)
			
			for aTrack in @tracks
				do (aTrack) =>
					@drawTrack(aTrack)
			for aNode in @nodes
				do (aNode) =>
					@drawNode(aNode)
					
			ctx.restore()

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
			ctx.lineCap = "round"
			ctx.lineJoin = "round"
			
			ctx.beginPath()
			ctx.moveTo(start.x,start.y)
			ctx.lineTo(stop.x,stop.y)
			ctx.closePath()
			
			ctx.stroke()
			ctx.restore()
			
		drawAllTracksBetweenNodes: (nodeA,nodeB) ->
			localTracks = @trackUnion(nodeA,nodeB) 
			norm = @nodesUnitNormal(nodeA,nodeB)
			
			if nodeA.type != "interchange"
				ctx.save()
				
				ctx.strokeStyle = @tracks[localTracks[0]].colour
				ctx.lineWidth = trackWidth
	
				ctx.lineCap = "round"
				ctx.lineJoin = "round"
	
				ctx.beginPath()
				ctx.moveTo(nodeA.position.x,nodeA.position.y)
				ctx.lineTo(nodeA.position.x+norm[0]*trackWidth*2,nodeA.position.y+norm[1]*trackWidth*2)
				ctx.closePath()
				
				ctx.stroke()
	
				ctx.restore()
				
			ctx.save()			
			
			if nodeA.nameRendered == false
			
				metric=ctx.measureText(nodeA.name)
				
				deadZone=0
				
				if norm[0]>deadZone and norm[1]>deadZone
					ctx.fillText(nodeA.name,nodeA.position.x+norm[0]*trackWidth*5,nodeA.position.y+norm[1]*trackWidth*5)
	
				if norm[0]<deadZone and norm[1]<deadZone
					ctx.fillText(nodeA.name,nodeA.position.x+norm[0]*trackWidth*5-metric.width,nodeA.position.y+norm[1]*trackWidth*5)
	
				if norm[0]>deadZone and norm[1]<deadZone
					ctx.fillText(nodeA.name,nodeA.position.x+norm[0]*trackWidth*5,nodeA.position.y+norm[1]*trackWidth*5)
	
				if norm[0]<deadZone and norm[1]>deadZone
					ctx.fillText(nodeA.name,nodeA.position.x+norm[0]*trackWidth*5,nodeA.position.y+norm[1]*trackWidth*5)
					
					nodeA.nameRendered = true
			
			ctx.restore()
			
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

		clear: () ->
			ctx.clearRect(0, 0, canvas.width, canvas.height);


		drawNode: (node) ->
			if node.type == 'interchange' or !node.type?
				ctx.save()
	
				ctx.translate(node.position.x,node.position.y)

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
