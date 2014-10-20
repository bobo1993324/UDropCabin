#include "uploadfile.h"
#include <QFile>
UploadFile::UploadFile(QDropbox *qdropbox)
{
    currentFile = new QDropboxFile(qdropbox);
}

UploadFile::~UploadFile()
{
    delete currentFile;
}

void UploadFile::upload(QString sourcePath, QString pathToUpload)
{
    qDebug() << "upload called with" << sourcePath << pathToUpload;
    currentFile->setFilename("/dropbox" + pathToUpload);
    QFile sourceFile(sourcePath);
    sourceFile.open(QFile::ReadOnly);
    QByteArray sourceContent = sourceFile.readAll();
    currentFile->open(QFile::WriteOnly);
    currentFile->write(sourceContent.data(), sourceContent.length());
    currentFile->close();
}
