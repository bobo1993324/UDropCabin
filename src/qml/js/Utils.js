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
