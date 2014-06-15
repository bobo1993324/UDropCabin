function getParentPath(path) {
    var returnVal = path.substring(0, path.lastIndexOf("/"));
    if (returnVal == "")
        return "/";
    else
        return returnVal;
}
