Ext.define('cmoon.controller.News',{
	extend: 'Ext.app.Controller',

	stores: ['News'],
	models: ['News'],
	views: ['news.List'],
	refs: [
		{
			ref: 'list',
			selector: 'newsList'
		}	
	],
	init: function(){
		this.control({
			'newsList': {
				render : this.onPanelRendered
			}
		});
	},

	onPanelRendered: function(){
		this.getNewsStore().load();
	}

});