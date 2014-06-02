#ifndef DROPBOXFILE_H
#define DROPBOXFILE_H

#include <QObject>
#include <QAbstractListModel>
#include <qtdropbox.h>
class DropBoxFileListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString path READ path WRITE setpath NOTIFY pathChanged)

    enum FileRoles {
        SizeRole = Qt::UserRole + 1,
        BytesRole,
        ModifiedRole,
        PathRole,
        IsDirRole
    };
public:
    explicit DropBoxFileListModel(QDropbox *);
    ~DropBoxFileListModel();

    QHash<int, QByteArray> roleNames() const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    QString path();
    void setpath(QString path);

signals:
    void pathChanged();

private:
    QDropboxFileInfo dirFileInfo;
};

#endif // DROPBOXFILE_H
