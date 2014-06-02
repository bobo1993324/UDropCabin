#include "mytype.h"
#include <QDebug>
#include <QDir>
MyType::MyType(QObject *parent) :
    QObject(parent),
    applicationName("com.ubuntu.developer.bobo1993324.udropcabin")
{
    QDir qdir(getStorePath());
    if (!qdir.exists())
        qdir.mkpath(getStorePath());
}

MyType::~MyType() {

}

bool MyType::saveFile(QString path, QString data) {
    qDebug() << data.size();
    QString fullPath = getStorePath() + path;
    QFileInfo qFileInfo(fullPath);
    if (!qFileInfo.dir().exists())
        QDir().mkpath(qFileInfo.dir().path());
    QFile qFile(fullPath);
    qFile.open(QFile::WriteOnly);
    qFile.write(data.toStdString().c_str(), data.size());
    qFile.close();
    return true;
}

QString MyType::getStorePath() {
    return QDir::homePath() + "/.local/share/" + applicationName + "/files/";
}
