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

function getUserInfo(token, callback) {
    var request = new XMLHttpRequest();
    request.open("GET", "https://api.dropbox.com/1/account/info");
    request.setRequestHeader("Authorization", "Bearer " + token);
    request.onreadystatechange = function () {
        if (request.readyState == 4) {
            var tmp = eval(request.responseText)
            callback(tmp);
        }
    }
    request.send();
}

function getFileList(path, token, callback) {
    var request = new XMLHttpRequest();
    var root = "dropbox";
    request.open("GET", "https://api.dropbox.com/1/metadata/" + root + "/" + path);
    request.setRequestHeader("Authorization", "Bearer " + token);
    request.onreadystatechange = function () {
        if (request.readyState == 4) {
            var tmp = eval(request.responseText)
            callback(tmp);
        }
    }
    request.send();
}

function getParentPath(path) {
    var returnVal = path.substring(0, path.lastIndexOf("/"));
    if (returnVal == "")
        return "/";
    else
        return returnVal;
}
