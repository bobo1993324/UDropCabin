#include "downloadfile.h"
#include <QDir>
#include <QFileInfoList>
#include <QFileInfo>
DownloadFile::DownloadFile(QDropbox * qdropbox)
    : TaskWithProgress() {
    currentFile = new QDropboxFile(qdropbox);
    basePath = QDir::homePath() + "/.local/share/com.ubuntu.developer.bobo1993324.udropcabin/Documents/";
    if (!QDir(basePath).exists()) {
        QDir().mkpath(basePath);
    }
    connectQDropboxFile(currentFile);
}

bool DownloadFile::fileExists(QString dropboxPath) {
    return QFile(basePath + dropboxPath).exists();
}

void DownloadFile::download(QString path) {

    setProgress(-1);

    currentFile->setFilename("/dropbox/" + path);
    currentFile->open(QFile::ReadOnly);
    QByteArray content = currentFile->readAll();
    currentFile->close();

    //create parent directory
    QFileInfo fileInfo(basePath + path);
    QDir parentDir = fileInfo.dir();
    if (!parentDir.exists()) {
        parentDir.mkpath(parentDir.path());
    }

    QFile file(basePath + path);
    file.open(QFile::WriteOnly);
    file.write(content.data(), content.length());
    file.close();
}

QDateTime DownloadFile::getModify(QString dropboxPath) {
    QFileInfo qfi(QDir::homePath() + "/.local/share/com.ubuntu.developer.bobo1993324.udropcabin/Documents/"+ dropboxPath);
    return qfi.lastModified();
}

QDateTime DownloadFile::getDateTimeUTC(QString dateTime, QString format) {
    QDateTime qdt = QDateTime::fromString(dateTime, format);
    qdt.setTimeSpec(Qt::UTC);
    return qdt;
}

void DownloadFile::clear()
{
    removePath(basePath);
}

int DownloadFile::localCacheSize()
{
    QDir dir(basePath);
    if (dir.exists()) {
        return getDirSize(dir);
    } else {
        return 0;
    }
}

int DownloadFile::getDirSize(QDir dir)
{
    int returnVal = 0;
    QFileInfoList list = dir.entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot);
    for (int i = 0; i < list.size(); i++) {
        QFileInfo f = list[i];
        if (f.isDir()) {
            returnVal += getDirSize(QDir(f.filePath()));
        } else if (f.isFile()) {
            returnVal += f.size();
        }
    }
    return returnVal;
}

void DownloadFile::removePath(const QString &path)
{
    qDebug() << "removePath" << path;
    QFileInfo fileInfo(path);
    if(fileInfo.isDir()){
        QDir dir(path);
        QStringList fileList = dir.entryList();
        for(int i = 0; i < fileList.count(); ++i){
            if (fileList.at(i) != "." && fileList.at(i) != "..")
                removePath(path  + "/" + fileList.at(i));
        }
        dir.rmpath(path);
    }
    else{
        QFile::remove(path);
    }
}
