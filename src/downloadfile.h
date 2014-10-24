#include "qdropbox.h"
#include "qdropboxfile.h"
#include "taskwithprogress.h"
class DownloadFile: public TaskWithProgress {
    Q_OBJECT
public:
    DownloadFile(QDropbox * qdropbox);
    Q_INVOKABLE bool fileExists(QString dropboxPath);
    Q_INVOKABLE void download(QString path);
    Q_INVOKABLE QDateTime getModify(QString dropboxPath);
    Q_INVOKABLE QDateTime getDateTimeUTC(QString dateTime, QString format);
signals:
    void progressChanged();
private:
    QDropboxFile * currentFile;
    QString basePath;
};
