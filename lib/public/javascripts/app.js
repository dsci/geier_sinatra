Ext.Loader.setPath('Ext','/ext/src/');
Ext.Loader.setConfig({enabled:true});

Ext.onReady(function(){
	
	Ext.application({
    name: 'cmoon',
    appFolder: '/javascripts/app',
    models: ['News'],
    controllers: ['News'],
    launch: function(){
			//console.log("fooo");
			this.initApplication();
    },

    initApplication: function(){
    	Ext.create('Ext.panel.Panel',{
    		layout: 'fit',
    		renderTo: 'admin-panel',
    		border: false,
    		id: "panel-container",
    		items: [
    			{
    				xtype: 'tabpanel',
    				activeTab: 0,
    				plain: true,
    				defaults:{
    					autoScroll: true
    				},
    				items:[
    					{xtype: 'newsList'}
    				]
    			}
    		]
    	});	
    }

	})/* end Ext.application */
});