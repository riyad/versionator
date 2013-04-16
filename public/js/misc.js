
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

function titelize(text) {
  return text.substr(0,1).toUpperCase() + text.substr(1);
}
