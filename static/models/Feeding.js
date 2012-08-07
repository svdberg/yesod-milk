(function ( models ) {
  models.Feeding = Backbone.Model.extend({
    idAttribute: "_id",
    defaults:{
          "_id": null,
          "date": new Date(),
          "side":"",
          "time":"",
          "excrements":"P",
          "remarks":"",
          "userid":null
    },

                // the URL (or base URL) for the service
                urlRoot: '../../api/feeding'
  });

})( app.models );
