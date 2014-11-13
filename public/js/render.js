var Render = {
  ajaxError: function(error, exception) {
    return '<span class="message error">'+error+': '+exception+'</span>';
  },

  appDirs: function (app_dirs) {
    var list = $(".js-app-dirs");

    // reset list
    $(list).html("");

    // list dirs
    $(app_dirs).each(function() {
      var app = this;
      if (app.unrecognized) {
        var source = $("#tpl-unrecognized-app").html();
        var template = Handlebars.compile(source);
        var context = {
          dir: app.dir,
        };
        var new_app = template(context);
      } else {
        var source = $("#tpl-app").html();
        var template = Handlebars.compile(source);
        var context = {
          app_name: app.app_name,
          basic_name: app.basic_name,
          dir: app.dir,
          dir_id: app.dir_id,
          download_url: app.project_download_url,
          project_url: app.project_url,
          download_link: new Handlebars.SafeString(Render.appProjectDownloadLink(app.project_download_url)),
          website_link: new Handlebars.SafeString(Render.appProjectWebsiteLink(app.project_url)),
        };
        var new_app = template(context);
      }

      $(list).append(new_app);
    });

    return list;
  },

  externalLink: function(text, url, options) {
    if (isEmpty(options)) {
      options = {};
    }
    return '<a href="'+url+'" '+(isEmpty(options.class) ? '' : 'class="'+options.class+'"')+'>'+text+' <span class="glyphicon glyphicon-share link-external"></span></a>';
  },

  appProjectDownloadLink: function(project_download_url) {
    return Render.externalLink("Download Page", project_download_url);
  },

  appProjectWebsiteLink: function(project_website_url) {
    return Render.externalLink("Project Website", project_website_url);
  },

  appStatusNeedsAttention: function() {
    return '<span class="glyphicon glyphicon-exclamation-sign glyphicon-white"></span> Needs Attention';
  },

  appStatusUnknown: function() {
    return '<span class="glyphicon glyphicon-question-sign"></span> Status Unknown';
  },

  appStatusUpToDate: function() {
    return '<span class="glyphicon glyphicon-ok-sign glyphicon-white"></span> Up-to-Date';
  },

  missingDirs: function(missing_dirs) {
    var source = $("#tpl-missing-dirs").html();
    var template = Handlebars.compile(source);
    var context = {
        folder_image: "img/folder-missing.png",
        dirs: missing_dirs,
    };
    var html = template(context);
    $(".js-missing-dirs").html(html);
    return $(".js-missing-dirs");
  },

  loadErrors: function(error, exception) {
    return '<div class="alert alert-block alert-danger"><h4>'+titelize(error)+'</h4> '+exception+'</div>';
  },


  recheckButtonFace: function() {
    return '<i class="glyphicon glyphicon-refresh"/> Recheck';
  },

}
