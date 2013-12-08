
// installed version

function checkAllInstalledVersions() {
  var delayBetweenRequests = 250; // in ms
  var currentDelay = 0;

  $(".js-app").not(".js-new-app").each(function() {
    var app = $(this);
    setTimeout(function() {
      checkInstalledVersionForApplication(app);
    }, currentDelay);
    currentDelay += delayBetweenRequests;
  });
}

function checkInstalledVersionForApplication(app) {
  var dirId = $(app).data("dir_id");
  var installedVersionUrl = "/installations/"+dirId+"/installed_version.json";

  $(app).find(".js-installed-app .js-busy").show(); // show busy
  $(app).find(".js-installed-version").html(""); // erase version + link
  $.getJSON(installedVersionUrl).success(function(data) {
    updateInstalledVersionFor(app, data.installed_version);
    updateAssessments(app);
  }).error(function(xhr, error, exception) {
    console.log(xhr);
    console.log(error);
    console.log(exception);
    error = titelize(error);
    updateInstalledVersionFor(app, Render.ajaxError(error, exception));
  });
}



function updateInstalledVersionFor(dir, html) {
  var ia = $(dir).find(".js-installed-app");
  $(ia).find(".js-busy").hide();
  $(ia).find(".js-installed-version").html(html); // set installed version text
  // update button
  $(ia).find(".js-check-installed-version-button").html(Render.recheckButtonFace());
}



// newest version

function checkAllNewestVersions() {
  var delayBetweenRequests = 250; // in ms
  var currentDelay = 0;

  var basicNames = $.unique($(".js-app").map(function() {
      return $(this).data("basic_name");
  }));
  $(basicNames).each(function() {
    var basicName = this;
    if (!isEmpty($("[data-basic_name='"+basicName+"']").toArray())) {
      setTimeout(function() {
        checkNewestVersionForApplicationByName(basicName);
      }, currentDelay);
      currentDelay += delayBetweenRequests;
    }
  });
}

function checkNewestVersionForApplicationByName(basicName) {
  var apps = $("[data-basic_name='"+basicName+"']");
  var newestVersionUrl = "/applications/"+basicName+"/newest_version.json";

  $(apps).find(".js-newest-app .js-busy").show(); // show busy
  $(apps).find(".js-newest-version").html(""); // erase version + link
  $.getJSON(newestVersionUrl).success(function(data) {
    updateNewestVersionFor(apps, data.newest_version);
    updateAssessments(apps);
  }).error(function(xhr, error, exception) {
    console.log(xhr);
    console.log(error);
    console.log(exception);
    error = titelize(error);
    updateNewestVersionFor(apps, Render.ajaxError(error, exception));
  });
}


function updateNewestVersionFor(inst, html) {
  var na = $(inst).find(".js-newest-app");
  $(na).find(".js-busy").hide();
  $(na).find(".js-newest-version").html(html); // set newest version text
  // update button
  $(na).find(".js-check-newest-version-button").html(Render.recheckButtonFace());
}



// global

function checkAllVersions() {
  checkAllInstalledVersions();
  checkAllNewestVersions();
}

function loadInstallations() {
  $(".js-refresh-installations-button .js-busy").show();
  $(".js-check-all-versions-button").fadeOut();
  $(".js-load-errors").slideUp();
  $(".js-dir-errors").slideUp();
  $(".js-app-dirs").slideUp();

  $.getJSON("/installations.json").success(function(data) {
    // update content
    $(".js-missing-dirs").html(Render.missingDirs(data.error_dirs));
    Render.appDirs(data.app_dirs);

    // show content
    if (!isEmpty(data.error_dirs)) {
      $(".js-dir-errors").slideDown();
    }
    $(".js-refresh-installations-button .js-busy").hide();
    $(".js-check-all-versions-button").fadeIn();
  }).error(function(xhr, error, exception) {
    $(".js-busy").hide();
    $(".js-load-errors").html(Render.loadErrors(error, exception)).slideDown();
  });
}

function updateAssessments(inst) {
  $(inst).each(function() {
    var installed_version = $(this).find(".js-installed-app .js-installed-version").text();
    var newest_version = $(this).find(".js-newest-app .js-newest-version").text();
    var as = $(this).find(".js-assessment-summary");

    // reset styles
    $(this).removeClass("alert-success");
    $(this).removeClass("alert-warning");
    $(as).removeClass("btn-success");
    $(as).removeClass("btn-warning");
    $(as).html(Render.appStatusUnknown());

    if(!isEmpty(installed_version) &&
       installed_version != "unknown" &&
       !isEmpty(newest_version) &&
       newest_version != "unknown"
    ) {
      $(this).addClass("alert");
      if(installed_version == newest_version) {
        $(this).addClass("alert-success");
        $(as).addClass("btn-success");
        $(as).html(Render.appStatusUpToDate());
      } else {
        $(this).addClass("alert-warning");
        $(as).addClass("btn-warning");
        $(as).html(Render.appStatusNeedsAttention());
      }
      $(this).find(".js-check-app-button").html(Render.recheckButtonFace());
    }
  });
}



// on load

$(function() {
  $(".js-check-all-versions-button").click(checkAllVersions);
  $(".js-refresh-installations-button").click(loadInstallations);

  $("body").on("click", ".js-collapser", function() {
    $($(this).data("target")).collapse('toggle');
    $(this).toggleClass("in");
  });

  $("body").on("click", ".js-check-app-button", function(e) {
    e.stopPropagation(); // to prevent .collapser to trigger
    checkInstalledVersionForApplication($(this).parents(".js-app"));
    checkNewestVersionForApplicationByName($(this).parents(".js-app").data('basic_name'));
  });
  $("body").on("click", ".js-check-installed-version-button", function() {
    checkInstalledVersionForApplication($(this).parents(".js-app"));
  });
  $("body").on("click", ".js-check-newest-version-button", function() {
    checkNewestVersionForApplicationByName($(this).parents(".js-app").data('basic_name'));
  });

  loadInstallations();
});
