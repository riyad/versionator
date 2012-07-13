
// From http://phpjs.org/functions/empty:392
function isEmpty(mixed_var) {
  var key;
  if (mixed_var === "" ||
    mixed_var === 0 ||
    mixed_var === "0" ||
    mixed_var === null ||
    mixed_var === false ||
    typeof mixed_var === 'undefined'
  ){
    return true;
  }
  if (typeof mixed_var == 'object') {
    for (key in mixed_var) {
      return false;
    }
    return true;
  }

  return false;
}

function renderAppProjectLink(app_name, project_url) {
  return renderExternalLink(app_name+" Website", project_url);
}

function renderAppLogo(basic_name) {
  return renderImage('logos/'+basic_name+'.png', basic_name);
}

function renderExternalLink(text, url, options) {
  if (isEmpty(options)) {
    options = {};
  }
  return '<a href="'+url+'" '+(isEmpty(options.class) ? '' : 'class="'+options.class+'"')+'>'+text+' <i class="icon-share link-external"></i></a>';
}

function renderImage(name, alt) {
  return '<img src="images/'+name+'" alt="'+alt+'" />';
}

function renderMiniAppLogo(basic_name) {
  return renderImage('logos/'+basic_name+'-mini.png', basic_name);
}

function titelize(text) {
  return text.substr(0,1).toUpperCase() + text.substr(1);
}



// installed version

function checkAllInstalledVersions() {
  var delayBetweenRequests = 250; // in ms
  var currentDelay = 0;
  
  $("section.app").each(function() {
    var section = $(this);
    if (!$(section).data("unrecognized")) {
      setTimeout(function() {
        checkInstalledVersionForDirectory($(section).data("dir_id"))
      }, currentDelay);
      currentDelay += delayBetweenRequests;
    }
  });
}

function checkInstalledVersionForDirectory(directory) {
  var dir = $("#"+directory);
  var installedVersionUrl = "/installations/"+directory+"/installed_version.json";

  $(dir).find(".installed-app .busy").show(); // show busy
  $(dir).find(".installed-version").html(""); // erase version + link
  $.getJSON(installedVersionUrl).success(function(data) {
    updateInstalledVersionFor(dir, data.installed_version);
    updateAssessments(dir);
    addInstalledVersionLink(dir, data);
  }).error(function(xhr, error, exception) {
    console.log(xhr);
    console.log(error);
    console.log(exception);
    error = titelize(error);
    addInstalledVersionLink(dir, '<span class="message error">'+error+': '+exception+'</span>');
  });
}



function updateInstalledVersionFor(dir, html) {
  var ia = $(dir).find(".installed-app");
  $(ia).find(".busy").hide();
  $(ia).find(".installed-version").html(html); // set installed version text
  // update button
  $(ia).find(".check-installed-version.btn").html('<i class="icon-refresh"/> Recheck');
}

function addInstalledVersionLink(dir, data) {
  if (data.project_url_for_installed_version) {
    var ivl = $(dir).find(".installed-version-link");
    $(ivl).html(renderExternalLink("Installed Release", data.project_url_for_installed_version, "installed-version"));
  }
}



// newest version

function checkAllNewestVersions() {
  var delayBetweenRequests = 250; // in ms
  var currentDelay = 0;

  var apps = $.unique($("section.app").map(function() {
      return $(this).data("basic_name");
  }));
  $(apps).each(function() {
    var app = this;
    if (!isEmpty($("."+app+"-app").toArray())) {
      setTimeout(function() {
        checkNewestVersionForApplication(app);
      }, currentDelay);
      currentDelay += delayBetweenRequests;
    }
  });
}

function checkNewestVersionForApplication(app) {
  var apps = $("."+app+"-app");
  var newestVersionUrl = "/applications/"+app+"/newest_version.json";

  $(apps).find(".newest-app .busy").show(); // show busy
  $(apps).find(".newest-version").html(""); // erase version + link
  $.getJSON(newestVersionUrl).success(function(data) {
    updateNewestVersionFor(apps, data.newest_version);
    updateAssessments(apps);
    addNewestVersionLink(apps, data);
  }).error(function(xhr, error, exception) {
    console.log(xhr);
    console.log(error);
    console.log(exception);
    error = titelize(error);
    updateNewestVersionFor(apps, '<span class="message error">'+error+': '+exception+'</span>');
  });
}



function addNewestVersionLink(inst, data) {
  if (data.project_url_for_newest_version) {
    var nvl = $(inst).find(".newest-version-link");
    $(nvl).html(renderExternalLink("Newest Release", data.project_url_for_newest_version, "newest-version"));
  }
}

function updateNewestVersionFor(inst, html) {
  var na = $(inst).find(".newest-app");
  $(na).find(".busy").hide();
  $(na).find(".newest-version").html(html); // set newest version text
  // update button
  $(na).find(".check-newest-version.btn").html('<i class="icon-refresh"/> Recheck');
}



// global

function checkAllVersions() {
  checkAllInstalledVersions();
  checkAllNewestVersions();
}

function loadInstallations() {
  $("h1 .busy").show();
  $("#check-all-versions").fadeOut();
  $("#errors").slideUp();
  $("#error-dirs").slideUp();
  $("#app-dirs").slideUp();

  $.getJSON("/installations.json").success(function(data) {
    renderErrorDirs(data.error_dirs);
    renderAppDirs(data.app_dirs)
    $("h1 .busy").hide();
    $("#check-all-versions").fadeIn();
  }).error(function(xhr, error, exception) {
    console.log(xhr);
    console.log(error);
    console.log(exception);
    $("h1 .busy").hide();
    $("#errors").html('<div class="alert alert-error"><h4 class="alert-heading">'+titelize(error)+'</h4> '+exception+'</div>').slideDown();
  });
}

function updateAssessments(inst) {
  $(inst).each(function() {
    var installed_version = $(this).find(".installed-app .installed-version").text();
    var newest_version = $(this).find(".newest-app .newest-version").text();
    var as = $(this).find(".assessment-summary");

    // reset styles
    $(this).removeClass("alert-success");
    $(this).removeClass("alert-warning");
    $(as).removeClass("btn-success");
    $(as).removeClass("btn-warning");
    $(as).html("<i class='icon-question-sign' /> Status Unknown");

    if(!isEmpty(installed_version) &&
       installed_version != "unknown" &&
       !isEmpty(newest_version) &&
       newest_version != "unknown"
    ) {
      $(this).addClass("alert");
      if(installed_version == newest_version) {
        $(this).addClass("alert-success");
        $(as).addClass("btn-success");
        $(as).html("<i class='icon-ok-sign icon-white' /> Up-to-Date");
      } else {
        $(this).addClass("alert-warning");
        $(as).addClass("btn-warning");
        $(as).html("<i class='icon-exclamation-sign icon-white' /> Needs Attention");
      }
      $(this).find("button.check-app").html('<i class="icon-refresh"/> Recheck');
    }
  });
}

function renderAppDirs(app_dirs) {
  var list = $("#app-dirs");

  // reset list
  $(list).html("");

  // list dirs
  $(app_dirs).each(function() {
    var app = this;
    var new_app = app.unrecognized ? $("#new-unrecognized-app").clone() : $("#new-app").clone();

    $(new_app).removeProp('id'); // erase cloded id
    for (prop in app) { // have all data available for later use
      $(new_app).find("section").data(prop, app[prop]);
    }

    // set values
    $(new_app).find("section").prop('id', app.dir_id);
    $(new_app).find("section").addClass("app");
    $(new_app).find("section").addClass(app.basic_name+"-app");
    $(new_app).find(".collapser").data('target', "#"+app.dir_id+"-details");
    $(new_app).find(".dir").append(app.dir);
    $(new_app).find(".collapser .app-name").append(renderMiniAppLogo(app.basic_name));
    $(new_app).find(".collapser .app-name").append(app.app_name);
    $(new_app).find(".collapse").attr('id', app.dir_id+"-details");
    $(new_app).find(".collapse .app-name").append(app.app_name);
    $(new_app).find(".collapse .project-link").append(renderAppProjectLink(app.app_name, app.project_url));
    $(new_app).find(".collapse .logo").append(renderAppLogo(app.basic_name));
    $(new_app).removeClass("hide").show();

    $(list).append(new_app);
  });

  $(list).slideDown();
  $(".collapser").click(function() {
    $($(this).data("target")).collapse('toggle');
    $(this).toggleClass("in");
  });
  $(list).find("button.check-app").click(function() {
    $(this).parents('.collapser').click(); // to prevent it from toggling
    checkInstalledVersionForDirectory($(this).parents("section").data('dir_id'));
    checkNewestVersionForApplication($(this).parents("section").data('basic_name'));
  });
  $(list).find("button.check-installed-version").click(function() {
    checkInstalledVersionForDirectory($(this).parents("section").data('dir_id'));
  });
  $(list).find("button.check-newest-version").click(function() {
    checkNewestVersionForApplication($(this).parents("section").data('basic_name'));
  });
}

function renderErrorDirs(error_dirs) {
  var list = $("#error-dirs-details ul");

  // reset list
  $(list).html("");

  // list dirs
  $(error_dirs).each(function() {
    $(list).append('<li>'+renderImage('folder-exists-not.png')+' ' + this + '</li>');
  });

  // show errors only of there are any
  if (!isEmpty(error_dirs)) {
    $("#error-dirs").slideDown();
  }
}



// on load

$(function() {
  $("button#check-all-versions").click(checkAllVersions);
  $("button#refresh-installations-button").click(loadInstallations);

  loadInstallations();
});