#include "downloadfile.h"
#include <QDir>
DownloadFile::DownloadFile(QDropbox * qdropbox) {
    currentFile = new QDropboxFile(qdropbox);
    basePath = QDir::homePath() + "/.local/share/com.ubuntu.developer.bobo1993324.udropcabin/Documents/";
    if (!QDir(basePath).exists()) {
        QDir().mkpath(basePath);
    }
}

bool DownloadFile::fileExists(QString dropboxPath) {
    return QFile(basePath + dropboxPath).exists();
}

void DownloadFile::download(QString path) {
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
    emit downloadFinished();
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
