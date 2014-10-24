#include "qdropbox.h"
#include "qdropboxfile.h"
class DownloadFile: public QObject {
    Q_OBJECT
    Q_PROPERTY(float progress READ progress NOTIFY progressChanged);
public:
    DownloadFile(QDropbox * qdropbox);

    float progress();

    Q_INVOKABLE bool fileExists(QString dropboxPath);
    Q_INVOKABLE void download(QString path);
    Q_INVOKABLE QDateTime getModify(QString dropboxPath);
    Q_INVOKABLE QDateTime getDateTimeUTC(QString dateTime, QString format);
signals:
    void progressChanged();
public slots:
    void handleDownloadProgress(qint64 downloaded, qint64 total);
private:
    QDropboxFile * currentFile;
    QString basePath;
    float m_progress;
};
