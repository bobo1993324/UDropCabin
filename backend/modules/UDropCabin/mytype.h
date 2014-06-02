#ifndef MYTYPE_H
#define MYTYPE_H

#include <QObject>

class MyType : public QObject
{
    Q_OBJECT
public:
    explicit MyType(QObject *parent = 0);
    ~MyType();

    Q_INVOKABLE bool saveFile(QString path, QString data);
private:
    QString getStorePath();

    const QString applicationName;
};

#endif // MYTYPE_H
