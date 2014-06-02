#ifndef DROPBOX_H
#define DROPBOX_H

#include <QObject>
#include "dropboxfile.h"
#include <qtdropbox.h>
class DropBox : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject * fileModel READ fileModel NOTIFY fileModelChanged)
    Q_PROPERTY(QObject * qDropBox READ qDropBox NOTIFY qDropBoxChanged)
public:
    explicit DropBox(QObject *parent = 0);
    ~DropBox();

    QObject * fileModel();
    QObject * qDropBox();
signals:
    void fileModelChanged();
    void qDropBoxChanged();
private:
    DropBoxFileListModel * m_fileModel;
    QDropbox * m_qDropBox;
};

#endif // DROPBOX_H
