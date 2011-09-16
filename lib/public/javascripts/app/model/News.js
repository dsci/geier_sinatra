Ext.define('cmoon.model.News',{
	extend: 'Ext.data.Model',

	fields: [
		{name: 'title', type: 'String', allowBlank: false},
		{name: 'text', type: 'String', allowBlank: false},
		{name: 'id', type: 'int', allowBlank:false}
	],

	idProperty: 'id',
	proxy: {
		url: '/news',
		type: 'rest',
		format: 'json',

		reader: {
			root: 'news',
			record: 'news',
			successProperty: 'success'
		},
		writer: {
			getRecordData: function(record){
				return { news:record.data }
			}
		}
	}
});