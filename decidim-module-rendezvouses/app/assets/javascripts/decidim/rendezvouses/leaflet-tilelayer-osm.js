// 🍂class TileLayer.OpenStreetMap
// Tile layer for OpenStreetMap maps tiles.
L.TileLayer.OpenStreetMap = L.TileLayer.extend({

    options: {
        subdomains: 'abc',
        minZoom: 2,
        maxZoom: 18,
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    },


    initialize: function initialize(options) {
        options = L.setOptions(this, options);
        options.tileResolution = 256;

        if (L.Browser.retina) {
            options.tileResolution = 512;
        }

        var path = '/{z}/{x}/{y}.png';
        var osmAttrib = '<a href="https://openstreetmap.org">OpenStreetMap</a>';
        var tileServer = 'tile.openstreetmap.org';
        var tileUrl = 'https://{s}.' + tileServer + path;

        L.TileLayer.prototype.initialize.call(this, tileUrl, options);
    },

});


L.tileLayer.OpenStreetMap = function (opts) {
    return new L.TileLayer.OpenStreetMap(opts);
}
