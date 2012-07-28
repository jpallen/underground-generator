require({
	paths: {
		"cs" : "/lib/cs",
		"coffee-script": "/lib/coffee-script"
	}
},
["cs!app"],
function(App) {
	app = new App()
	app.helloWorld()
})
