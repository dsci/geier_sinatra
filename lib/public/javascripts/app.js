Ext.Loader.setPath('Ext','/ext/src/');
Ext.Loader.setConfig({enabled:true});

Ext.onReady(function(){
	Ext.application({
    name: 'cmoon',
    appFolder: '/javascripts/app',
    models: ['News'],
    controllers: [],
    launch: function(){
			console.log("fooo");
    },
	});	
});

