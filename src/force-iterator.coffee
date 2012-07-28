define () ->
	targetLength = 100
	k = 10
	dt = 0.01
	m = 1

	class ForceIterator
		constructor: (@nodes, @tracks) ->

		step: () ->
			for node in @nodes
				node.force = [0, 0]
				node.velocity ||= [0, 0]

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

			for node in @nodes
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

		linkUnitVector: (link) ->
			length = @linkLength(link)
			nodeA = @nodes[link[0]]
			nodeB = @nodes[link[1]]
			[
				(nodeB.position.x - nodeA.position.x) / length
				(nodeB.position.y - nodeA.position.y) / length
			]


