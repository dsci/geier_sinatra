Ext.define('cmoon.view.news.List', {
	extend: 'Ext.grid.Panel',

	alias: 'widget.newsList',
	title: 'News',
	initComponent: function(){
			
		this.store = 'News';
		this.forceFit = true;
		this.columns = [
			{
				text: "Titel",
				dataIndex: 'title'
			},
			{
				text: "Text (Auszug)",
				dataIndex: 'text',
				renderer: this.textRenderer,
			}
		];

		this.bbar = this.initButtonBar();
		this.callParent(arguments);
	},

	initButtonBar: function(){
		return [];
	},

	textRenderer: function(value){
		
	}
});