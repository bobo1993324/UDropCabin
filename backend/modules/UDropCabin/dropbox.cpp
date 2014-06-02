#include "dropbox.h"

DropBox::DropBox(QObject *parent) :
    QObject(parent) {
    m_qDropBox = new QDropbox();
//    m_fileModel = new DropBoxFileListModel(m_qDropBox);
}

DropBox::~DropBox() {

}

QObject * DropBox::fileModel() {
    return m_qDropBox;
}

QObject * DropBox::qDropBox() {
    return m_qDropBox;
}
