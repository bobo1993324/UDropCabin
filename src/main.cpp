#include <QQuickView>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QtQml>
#include "qdropbox.h"
#include "downloadfile.h"
#include "path.h"
int main(int argc, char ** argv) {
    QDropbox * qDropbox = new QDropbox();
    DownloadFile * downloadFile = new DownloadFile(qDropbox);
    path * p = new path();
    QGuiApplication app(argc, argv);
    QQuickView viewer;

    viewer.engine()->rootContext()->setContextProperty("QDropbox", qDropbox);
    viewer.engine()->rootContext()->setContextProperty("PATH", p);
    viewer.engine()->rootContext()->setContextProperty("DownloadFile", downloadFile);

    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setSource(QUrl::fromLocalFile("./qml/UDropCabin.qml"));
    viewer.show();
    return app.exec();
}
