#include "qdropbox.h"
#include "qdropboxfile.h"
class UploadFile: public QObject {
    Q_OBJECT
public:
    UploadFile(QDropbox * qdropbox);
    ~UploadFile();
    Q_INVOKABLE void upload(QString sourcePath, QString pathToUpload);
private:
    QDropboxFile * currentFile;
    QString basePath;
};
