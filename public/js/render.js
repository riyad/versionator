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
      var new_app = app.unrecognized ? $(".js-new-unrecognized-app").clone() : $(".js-new-app").clone();

      for (prop in app) { // have all data available for later use
        $(new_app).attr('data-'+prop, app[prop]);
      }

      // set values
      $(new_app).removeClass("js-new-app");
      $(new_app).removeClass("js-new-unrecognized-app");
      $(new_app).find(".js-collapser").attr('data-target', '#'+app.dir_id+"-details");
      $(new_app).find(".js-collapse").attr('id', app.dir_id+"-details");
      $(new_app).find(".js-dir").append(app.dir);
      $(new_app).find(".js-app-name").append(Render.miniAppLogo(app.basic_name));
      $(new_app).find(".js-app-name").append(app.app_name);
      $(new_app).find(".js-logo").append(Render.appLogo(app.basic_name));
      $(new_app).find(".js-project-website-link").append(Render.appProjectWebsiteLink(app.project_url));
      $(new_app).find(".js-project-download-link").append(Render.appProjectDownloadLink(app.project_download_url));
      $(new_app).removeClass("hide").show();

      $(list).append(new_app);
    });

    $(list).slideDown();
  },

  appLogo: function(basic_name) {
    return Render.image('logos/'+basic_name+'.png', basic_name);
  },

  appProjectDownloadLink: function(project_download_url) {
    return Render.externalLink("Download Page", project_download_url);
  },

  appProjectWebsiteLink: function(project_website_url) {
    return Render.externalLink("Project Website", project_website_url);
  },

  appStatusNeedsAttention: function() {
    return '<i class="icon-exclamation-sign icon-white"></i> Needs Attention';
  },

  appStatusUnknown: function() {
    return '<i class="icon-question-sign"></i> Status Unknown';
  },

  appStatusUpToDate: function() {
    return '<i class="icon-ok-sign icon-white"></i> Up-to-Date';
  },
  
  missingDirs: function(missing_dirs) {
    // reset list
    list = $("<ul></ul>");

    // list dirs
    $(missing_dirs).each(function() {
      $(list).append(Render.missingFolder(this));
    });

    return list;
  },

  externalLink: function(text, url, options) {
    if (isEmpty(options)) {
      options = {};
    }
    return '<a href="'+url+'" '+(isEmpty(options.class) ? '' : 'class="'+options.class+'"')+'>'+text+' <i class="icon-share link-external"></i></a>';
  },

  image: function(name, alt) {
    return '<img src="img/'+name+'" alt="'+alt+'" />';
  },

  loadErrors: function(error, exception) {
    return '<div class="alert alert-block alert-error"><h4>'+titelize(error)+'</h4> '+exception+'</div>';
  },

  miniAppLogo: function(basic_name) {
    return Render.image('logos/'+basic_name+'-mini.png', basic_name);
  },

  missingFolder: function(dir) {
    return '<li>'+Render.image('folder-missing.png')+' '+dir+'</li>';
  },

  recheckButtonFace: function() {
    return '<i class="icon-refresh"/> Recheck';
  },

}

