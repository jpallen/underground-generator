define ["cs!node", "cs!track"], (Node, Track) ->
	{
		nodes: [
			new Node('station1',100,100),
			new Node('station2',100,200),
			new Node('station3',200,200),
			new Node('station3',300,300)
		]
		tracks: [
			new Track('waterloo',[0,1],'blue'),
			new Track('bakerloo',[1,2],'green'),
			new Track('victoria',[0,2,3],'brown')
		]
	}
