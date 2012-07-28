define ["cs!node", "cs!track"], (Node, Track) ->
	#json = {"nodes":[{"name":"Southfield Way","position":{"x":100,"y":100}},{"name":"Southfield Way","position":{"x":136.07981366876626,"y":134.4262295081967}},{"name":"Framwelgate Peth","position":{"x":167.55538865270177,"y":192.30769230769232}},{"name":"Station Approach","position":{"x":255.08114244340285,"y":237.70491803278688}},{"name":"Milburngate Bridge","position":{"x":271.9734830841028,"y":265.32156368221945}},{"name":"Leazes Rd","position":{"x":283.87517798919214,"y":312.2320302648171}},{"name":"57 Gilesgate","position":{"x":265.4468430146528,"y":392.81210592686}},{"name":"114 Gilesgate","position":{"x":256.616790981412,"y":454.8549810844893}},{"name":"Sherburn Rd","position":{"x":273.5091729666318,"y":513.4930643127365}},{"name":"Newcastle Rd","position":{"x":363.73755080509477,"y":121.18537200504414}},{"name":"Crossgate Peth","position":{"x":319.58161725775085,"y":210.8448928121059}},{"name":"Sutton St","position":{"x":277.7323395252424,"y":213.11475409836066}},{"name":"81-82 New Elvet","position":{"x":309.59896725286603,"y":317.906683480454}},{"name":"22 Old Elvet","position":{"x":329.5644260728518,"y":359.14249684741486}},{"name":"Green Ln","position":{"x":339.1634304688032,"y":397.3518284993695}},{"name":"27 Orchard Dr","position":{"x":207.09401960953903,"y":380.327868852459}},{"name":"13 Ferens Close","position":{"x":213.62005266929106,"y":351.9546027742749}},{"name":"16 Providence Row","position":{"x":241.26047474188044,"y":314.1235813366961}},{"name":"100 Hallgarth St","position":{"x":351.83434109953055,"y":327.3644388398487}},{"name":"Hallgarth St","position":{"x":406.36057257300354,"y":351.1979823455233}},{"name":"2 A177","position":{"x":416.34476186633674,"y":361.0340479192938}},{"name":"A177","position":{"x":432.8574234680638,"y":394.70365699873895}},{"name":"7 Willow Tree Ave","position":{"x":546.9218559278077,"y":543.001261034048}},{"name":"Durham Rd","position":{"x":900,"y":700}},{"name":"Quarryheads Ln","position":{"x":362.5856174341813,"y":225.40983606557376}},{"name":"3 Quarryheads Ln","position":{"x":417.8808051006266,"y":254.16141235813367}},{"name":"2 A177","position":{"x":417.1127830214652,"y":304.8549810844893}},{"name":"Mill Ln","position":{"x":481.6299137937811,"y":574.2118537200504}},{"name":"A1(M)","position":{"x":469.340425249424,"y":688.4615384615385}},{"name":"A1(M)","position":{"x":338.77946749006395,"y":666.5195460277428}}],"tracks":[{"name":"Untitled","line":[0,1,2,3,4,5,6,7,8]},{"name":"Untitled","line":[9,10,11,4,5,12,13,14], "color": "blue"},{"name":"Untitled","line":[15,16,17,5,12,18,19,20,21,22,23], "color":"red"},{"name":"Untitled","line":[24,25,26,20,21,22,27,28,29], "color": "green"}]}

	json =
	   "nodes":[
	      {
	         "name":"A167",
	         "position":{
	            "x":0,
	            "y":0
	         }
	      },
	      {
	         "name":"Framwelgate Peth",
	         "position":{
	            "x":128.2890151988978,
	            "y":127.48735244519393
	         }
	      },
	      {
	         "name":"Framwelgate Peth",
	         "position":{
	            "x":245.6727453393098,
	            "y":201.34907251264755
	         }
	      },
	      {
	         "name":"1 Millburngate",
	         "position":{
	            "x":316.6549479892102,
	            "y":213.49072512647555
	         }
	      },
	      {
	         "name":"New Elvet",
	         "position":{
	            "x":341.22676288993387,
	            "y":292.4114671163575
	         }
	      },
	      {
	         "name":"Leazes Rd",
	         "position":{
	            "x":300.2740387565996,
	            "y":385.4974704890388
	         }
	      },
	      {
	         "name":"A690",
	         "position":{
	            "x":182.88456216229628,
	            "y":455.3119730185498
	         }
	      },
	      {
	         "name":"A690",
	         "position":{
	            "x":25.929568260873523,
	            "y":588.8701517706577
	         }
	      },
	      {
	         "name":"Darlington Rd",
	         "position":{
	            "x":498.2261340698691,
	            "y":31.36593591905565
	         }
	      },
	      {
	         "name":"Summerville",
	         "position":{
	            "x":447.7108821702845,
	            "y":127.48735244519393
	         }
	      },
	      {
	         "name":"14 Summerville",
	         "position":{
	            "x":408.1194457195488,
	            "y":150.75885328836426
	         }
	      },
	      {
	         "name":"25 Sutton St",
	         "position":{
	            "x":320.75021288494816,
	            "y":164.92411467116358
	         }
	      },
	      {
	         "name":"96 Elvet Bridge",
	         "position":{
	            "x":371.2597161543345,
	            "y":274.1989881956155
	         }
	      },
	      {
	         "name":"28 N Bailey",
	         "position":{
	            "x":450.44137785390586,
	            "y":264.08094435075884
	         }
	      },
	      {
	         "name":"Durham University - Mountjoy Centre",
	         "position":{
	            "x":515.9752790619449,
	            "y":232.7150084317032
	         }
	      },
	      {
	         "name":"2 A177",
	         "position":{
	            "x":577.4168073967477,
	            "y":281.2816188870152
	         }
	      },
	      {
	         "name":"17 Old Elvet",
	         "position":{
	            "x":401.2934779895501,
	            "y":309.61214165261384
	         }
	      },
	      {
	         "name":"100 Hallgarth St",
	         "position":{
	            "x":462.7286911264363,
	            "y":318.71838111298484
	         }
	      },
	      {
	         "name":"Hallgarth St",
	         "position":{
	            "x":559.6666850326181,
	            "y":341.98988195615516
	         }
	      },
	      {
	         "name":"S Rd",
	         "position":{
	            "x":649.7856130571233,
	            "y":253.9629005059022
	         }
	      },
	      {
	         "name":"S Rd",
	         "position":{
	            "x":735.8150154967848,
	            "y":217.5379426644182
	         }
	      },
	      {
	         "name":"2 Willow Tree Ave",
	         "position":{
	            "x":800,
	            "y":600
	         }
	      },
	      {
	         "name":"A177",
	         "position":{
	            "x":708.5033756246567,
	            "y":488.70151770657674
	         }
	      },
	      {
	         "name":"A177",
	         "position":{
	            "x":615.6487991990226,
	            "y":420.9106239460371
	         }
	      },
	      {
	         "name":"3 Quarryheads Ln",
	         "position":{
	            "x":569.2244081433182,
	            "y":207.41989881956155
	         }
	      },
	      {
	         "name":"Potters Bank",
	         "position":{
	            "x":634.7652863084261,
	            "y":120.40472175379428
	         }
	      }
	   ],
	   "tracks":[
	      {
	         "name":"Untitled",
	         "line":[
	            0,
	            1,
	            2,
	            3,
	            4,
	            5,
	            6,
	            7
	         ],
	         "color": "red"
	      },
	      {
	         "name":"Untitled",
	         "line":[
	            8,
	            9,
	            10,
	            11,
	            3,
	            4,
	            12,
	            13,
	            14,
	            15
	         ],
	         "color": "green"
	      },
	      {
	         "name":"Untitled",
	         "line":[
	            6,
	            5,
	            4,
	            16,
	            17,
	            18,
	            15,
	            19,
	            20
	         ],
	         "color": "blue"
	      },
	      {
	         "name":"Untitled",
	         "line":[
	            21,
	            22,
	            23,
	            18,
	            15,
	            24,
	            25,
	            8
	         ],
	         "color": "black"
	      }
	   ]
