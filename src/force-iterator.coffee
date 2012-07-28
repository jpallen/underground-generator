define ["cs!node"],(Node) ->

	# spring system constants
	targetLength = 100
	k = 10
	dt = 0.1
	m = 1
	c = 1
	
	k2 = 0.3
	
	# field system constants
	G = 100000

	class ForceIterator
		constructor: (@nodes, @tracks) ->

		step: () ->
			# intialise node force data
			for node in @nodes
				node.initialPosition ||= {x: node.position.x, y:node.position.y}
				node.force = [0, 0]
				node.velocity ||= [0, 0]
			
			# repulsion force field
			for node1 in @nodes
				for node2 in @nodes
					if node1 != node2
						unit = @nodesUnitVector(node1,node2);
						node1.force = [
							node1.force[0] - (G * 2 * m )/Math.pow(@nodesDist(node1,node2),2) * unit[0],
							node1.force[1] - (G * 2 * m )/Math.pow(@nodesDist(node1,node2),2) * unit[1]  							
						]

			# track springs
			for track in @tracks
				for link in track.links()
					length = @linkLength(link)
					forceMagnitude = k * (targetLength - length)
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

			# damping and force update
			for node in @nodes
				
				pseudoInitNode = new Node('none',node.initialPosition.x,node.initialPosition.y)
				unit = @nodesUnitVector(node,pseudoInitNode)				
				forceMagnitude = k2 * (@nodesDist(node,pseudoInitNode))
				
				node.force = [
					node.force[0] + forceMagnitude * unit[0]
					node.force[1] + forceMagnitude * unit[1]
				]	
				
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
			length = @linkLength(link)
			nodeA = @nodes[link[0]]
			nodeB = @nodes[link[1]]
			[
				(nodeB.position.x - nodeA.position.x) / length
				(nodeB.position.y - nodeA.position.y) / length
			]


