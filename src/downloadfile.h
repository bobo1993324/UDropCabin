#include "qdropbox.h"
#include "qdropboxfile.h"
#include "taskwithprogress.h"
#include <QDir>

class DownloadFile: public TaskWithProgress {
    Q_OBJECT
public:
    DownloadFile(QDropbox * qdropbox);
    Q_INVOKABLE bool fileExists(QString dropboxPath);
    Q_INVOKABLE void download(QString path);
    Q_INVOKABLE QDateTime getModify(QString dropboxPath);
    Q_INVOKABLE QDateTime getDateTimeUTC(QString dateTime, QString format);
    Q_INVOKABLE void clear();
    Q_INVOKABLE int localCacheSize();
    Q_INVOKABLE QString iconNameForMimeType(QString mimetype);
signals:
    void progressChanged();
private:
    int getDirSize(QDir dir);
    void removePath(const QString &path);

    QDropboxFile * currentFile;
    QString basePath;
};
