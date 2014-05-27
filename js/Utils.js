function queryTokenUrl(url) {
    // This function is anonymous, is executed immediately and
    // the return value is assigned to QueryString!
    url = url.substring(url.indexOf("#") + 1, url.length);
    var returnVal = {};
    var vars = url.split("&");
    for (var i in vars) {
        var key = vars[i].substring(0, vars[i].indexOf("="));
        var value = vars[i].substring(vars[i].indexOf("=") + 1, vars[i].length);
        returnVal[key] = value;
    }
    return returnVal;
};
