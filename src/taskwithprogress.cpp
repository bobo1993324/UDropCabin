#include "taskwithprogress.h"

TaskWithProgress::TaskWithProgress(QObject *parent) :
    QObject(parent), m_progress(-1)
{

}

float TaskWithProgress::progress()
{
    return m_progress;
}

void TaskWithProgress::setProgress(float p)
{
    m_progress = p;
    emit progressChanged();
}

void TaskWithProgress::connectQDropboxFile(QDropboxFile *file)
{
    connect(file, SIGNAL(downloadProgress(qint64, qint64)), this, SLOT(handleDownloadProgress(qint64,qint64)));
    connect(file, SIGNAL(uploadProgress(qint64, qint64)), this, SLOT(handleDownloadProgress(qint64,qint64)));
}

void TaskWithProgress::handleDownloadProgress(qint64 downloaded, qint64 total)
{
    setProgress(downloaded / (float) total);
}
