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
function getReadableFileSizeString(fileSizeInBytes) {

    var i = -1;
    var byteUnits = [' kB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
    do {
        fileSizeInBytes = fileSizeInBytes / 1024;
        i++;
    } while (fileSizeInBytes > 1024);

    return Math.max(fileSizeInBytes, 0.1).toFixed(1) + byteUnits[i];
};
