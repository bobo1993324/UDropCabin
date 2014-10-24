#include "downloadfile.h"
#include <QDir>
DownloadFile::DownloadFile(QDropbox * qdropbox)
    : m_progress(-1) {
    currentFile = new QDropboxFile(qdropbox);
    basePath = QDir::homePath() + "/.local/share/com.ubuntu.developer.bobo1993324.udropcabin/Documents/";
    if (!QDir(basePath).exists()) {
        QDir().mkpath(basePath);
    }

    connect(currentFile, SIGNAL(downloadProgress(qint64, qint64)), this, SLOT(handleDownloadProgress(qint64,qint64)));
}

bool DownloadFile::fileExists(QString dropboxPath) {
    return QFile(basePath + dropboxPath).exists();
}

void DownloadFile::download(QString path) {

    m_progress = -1;
    emit progressChanged();

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

void DownloadFile::handleDownloadProgress(qint64 downloaded, qint64 total)
{
    m_progress = downloaded / (float) total;
    emit progressChanged();
}


float DownloadFile::progress()
{
    return m_progress;
}
