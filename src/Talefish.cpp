#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QQmlEngine>
#include <QQuickView>
#include <QGuiApplication>
#include <sailfishapp.h>
#include "lib/folderlistmodel/qquickfolderlistmodel.h"
#include "launcher.h"
#include "taglibplugin.h"
#include "taglibimageprovider.h"

int main(int argc, char *argv[])
{

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQmlEngine *engine = view->engine();

    engine->addImageProvider(QLatin1String("taglib-cover-art"), new taglibImageprovider);

    qmlRegisterType<Launcher>("Launcher", 1 , 0 , "Launcher");
    qmlRegisterType<taglibplugin>("TaglibPlugin", 1, 0, "TaglibPlugin");
    qmlRegisterType<QQuickFolderListModel>("harbour.talefish.folderlistmodel", 1, 0, "FolderListModel");

    view->setSource(SailfishApp::pathToMainQml());
    view->showFullScreen();

    return app->exec();
}

