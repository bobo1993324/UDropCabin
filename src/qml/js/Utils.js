function getParentPath(path) {
    var returnVal = path.substring(0, path.lastIndexOf("/"));
    if (returnVal == "")
        return "/";
    else
        return returnVal;
}

function getFileNameFromPath(path) {
    var i = path.lastIndexOf("/");
    return path.substring(i + 1, path.length);
}

function dropboxPathToLocalPath(dropboxPath) {
    return "file://" + PATH.homeDir() + "/.local/share/com.ubuntu.developer.bobo1993324.udropcabin/Documents/" + dropboxPath;
}

function transferItems2UrlStrings(transferItems) {
    var result = [];
    for (var i in transferItems) {
        result.push(transferItems[i].url.toString());
    }
    return result;
}
