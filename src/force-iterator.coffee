define ["cs!node"],(Node) ->

	# spring system constants
	k = 10
	dt = basedt = 0.1
	m = 1
	c = 1
	
	k2 = 0.3

	gridForce = 100
	
	# field system constants
	G = 100000

	class ForceIterator
		constructor: (@nodes, @tracks) ->
			lengths = []
			for track in tracks
				for link in track.links()
					lengths.push @linkLength link
			sum = 0
			sum += length for length in lengths
			@targetLength = sum / lengths.length

			@scheme = "spread"

		step: () ->
			# intialize node force data
			for node in @nodes
				node.initialPosition ||= {x: node.position.x, y:node.position.y}
				node.force = [0, 0]
				node.velocity ||= [0, 0]

			totalDelta = 0
			if @scheme == "spread"
				@assignNodeRepulsionForces()
				@assignSpringForces()
				@assignCloseToHomeForces()
			else
				@assignGridForces()
				@assignSpringForces()
				@assignCloseToHomeForces()
			delta = @applyForces()
			if delta < 100 and @scheme == "spread"
				k = k / 500.0
				k2 = k2 / 100.0
				@scheme = "grid"
			if delta < 100
				dt = 5 * basedt
			else
				dt = basedt

			return delta

		assignNodeRepulsionForces: () ->
			# repulsion force field
			for node1 in @nodes
				for node2 in @nodes
					if node1 != node2
						unit = @nodesUnitVector(node1,node2)
						node1.force = [
							node1.force[0] - (G * 2 * m )/Math.pow(@nodesDist(node1,node2),2) * unit[0],
							node1.force[1] - (G * 2 * m )/Math.pow(@nodesDist(node1,node2),2) * unit[1]
						]

		assignSpringForces: () ->
			# track springs
			for track in @tracks
				for link in track.links()
					# Spring force to fix lengths of tracks
					length = @linkLength(link)
					forceMagnitude = k * (@targetLength - length)
					unitDirection = @linkUnitVector(link)
					nodeFrom = @nodes[link[0]]
					nodeTo = @nodes[link[1]]

					nodeFrom.force = [
						nodeFrom.force[0] - forceMagnitude * unitDirection[0]
						nodeFrom.force[1] - forceMagnitude * unitDirection[1]
					]

					nodeTo.force = [
						nodeTo.force[0] + forceMagnitude * unitDirection[0]
						nodeTo.force[1] + forceMagnitude * unitDirection[1]
					]
		
		assignCloseToHomeForces: () ->
			# Stay close to original points
			for node in @nodes
				pseudoInitNode = new Node('none',node.initialPosition.x,node.initialPosition.y)
				unit = @nodesUnitVector(node,pseudoInitNode)
				forceMagnitude = k2 * (@nodesDist(node,pseudoInitNode))
				
				node.force = [
					node.force[0] + forceMagnitude * unit[0]
					node.force[1] + forceMagnitude * unit[1]
				]
			
		applyForces: () ->
			totalDelta = 0
			for node in @nodes
				node.force = [
					node.force[0] - c * node.velocity[0]
					node.force[1] - c * node.velocity[1]
				]
			
				node.velocity = [
					node.velocity[0] + node.force[0] / m * dt
					node.velocity[1] + node.force[1] / m * dt
				]
				node.position.x = node.position.x + node.velocity[0] * dt
				node.position.y = node.position.y + node.velocity[1] * dt

				totalDelta += Math.abs(node.velocity[0])
				totalDelta += Math.abs(node.velocity[1])

			return totalDelta

		assignGridForces: () ->
			for track in @tracks
				for link in track.links()
					unitDirection = @linkUnitVector(link)
					nodeFrom = @nodes[link[0]]
					nodeTo = @nodes[link[1]]

					angle = Math.atan2( unitDirection[1], unitDirection[0] )
					if angle < 0
						angle += 2*Math.PI
					
					alignmentAngles = [
						0, Math/4, Math.PI/2, 3*Math.PI/4,
						Math.PI, 5*Math.PI/4, 3 * Math.PI/2, 7*Math.PI/4
					]

					angleDelta = null
					for alignmentAngle in alignmentAngles
						diff = angle - alignmentAngle

						# always take acute angle
						if diff > Math.PI
							diff = 2 * Math.PI - diff

						if !angleDelta? or Math.abs(diff) < Math.abs(angleDelta)
							angleDelta = diff

					forceMagnitude = gridForce * (angleDelta)

					nodeToNormal = [unitDirection[1], -unitDirection[0]]
					nodeFromNormal = [-unitDirection[1], unitDirection[0]]

					nodeTo.force = [
						nodeTo.force[0] + forceMagnitude * nodeToNormal[0]
						nodeTo.force[1] + forceMagnitude * nodeToNormal[1]
					]
					nodeFrom.force = [
						nodeFrom.force[0] + forceMagnitude * nodeFromNormal[0]
						nodeFrom.force[1] + forceMagnitude * nodeFromNormal[1]
					]
			


		linkLength: (link) ->
			nodeA = @nodes[link[0]]
			nodeB = @nodes[link[1]]
			Math.sqrt(
				Math.pow(nodeA.position.x - nodeB.position.x, 2) +
				Math.pow(nodeA.position.y - nodeB.position.y, 2)
			)
			
		nodesDist: (nodeA,nodeB) ->
			Math.sqrt(
				Math.pow(nodeA.position.x - nodeB.position.x, 2) +
				Math.pow(nodeA.position.y - nodeB.position.y, 2)
			)

		nodesUnitVector: (nodeA,nodeB) ->
			dist = @nodesDist(nodeA,nodeB)
			if dist < 0.1
				return [0,0]
			[
				(nodeB.position.x - nodeA.position.x) / dist
				(nodeB.position.y - nodeA.position.y) / dist
			]

		linkUnitVector: (link) ->
			@nodesUnitVector(@nodes[link[0]], @nodes[link[1]])

