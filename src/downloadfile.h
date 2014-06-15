#include "qdropbox.h"
#include "qdropboxfile.h"
class DownloadFile: public QObject {
    Q_OBJECT
public:
    DownloadFile(QDropbox * qdropbox);
    Q_INVOKABLE bool fileExists(QString dropboxPath);
    Q_INVOKABLE void download(QString path);
signals:
    void downloadFinished();
private:
    QDropboxFile * currentFile;
    QString basePath;

};
