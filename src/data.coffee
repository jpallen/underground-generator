define ["cs!node", "cs!track"], (Node, Track) ->
	{
		nodes: [
			new Node('station1',100,100) # 0
			new Node('station2',200,100) # 1
			new Node('station3',300,100) # 2
			new Node('station1',400,100) # 3
			new Node('station2',200,200) # 4
			new Node('station3',300,350) # 5
			new Node('station1',400,300) # 6
			new Node('station2',500,500) # 7
			new Node('station3',700,300) # 8
		]
		tracks: [
			new Track('waterloo',[0,1,2,3],'blue'),
			new Track('bakerloo',[1,4,5,3],'green'),
			new Track('victoria',[5,7,8],'brown')
		]
	}
