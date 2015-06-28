#ifndef TASKWITHPROGRESS_H
#define TASKWITHPROGRESS_H

#include <QObject>
#include "qdropboxfile.h"

class TaskWithProgress : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float progress READ progress NOTIFY progressChanged)
public:
    explicit TaskWithProgress(QObject *parent = 0);
    float progress();
    void setProgress(float p);
    void connectQDropboxFile(QDropboxFile *file);
signals:
    void progressChanged();
public slots:
    void handleDownloadProgress(qint64 downloaded, qint64 total);
private:
    float m_progress;
};

#endif // TASKWITHPROGRESS_H
