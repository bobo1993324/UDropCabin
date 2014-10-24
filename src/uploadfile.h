#include "qdropbox.h"
#include "qdropboxfile.h"
#include "taskwithprogress.h"
class UploadFile: public TaskWithProgress {
    Q_OBJECT
public:
    UploadFile(QDropbox * qdropbox);

    float progress();

    Q_INVOKABLE void upload(QString sourcePath, QString pathToUpload);
signals:
    void progressChanged();
private:
    QDropboxFile * currentFile;
    QString basePath;
};
