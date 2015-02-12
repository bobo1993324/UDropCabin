#include "uploadfile.h"
#include <QFile>
#include <QDir>
UploadFile::UploadFile(QDropbox *qdropbox)
    : TaskWithProgress()
{
    currentFile = new QDropboxFile(qdropbox);
    connectQDropboxFile(currentFile);
}

void UploadFile::upload(QString sourcePath, QString pathToUpload)
{
    qDebug() << "upload called with" << sourcePath << pathToUpload;
    setProgress(-1);
    currentFile->setFilename("/dropbox" + pathToUpload);
    QFile sourceFile(sourcePath);
    sourceFile.open(QFile::ReadOnly);
    QByteArray sourceContent = sourceFile.readAll();
    currentFile->open(QFile::WriteOnly);
    currentFile->write(sourceContent.data(), sourceContent.length());
    currentFile->close();
}

QStringList UploadFile::photosToUpload()
{
    QString photoPath = QDir::homePath() + "/Pictures/com.ubuntu.camera/";
    QDir dir(photoPath);
    QFileInfoList files = dir.entryInfoList();
    QStringList list;
    for (int i = 0; i < files.length(); i++) {
        list += files[i].fileName();
    }
    return list;
}
