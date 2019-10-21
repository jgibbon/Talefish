//#ifdef QT_QML_DEBUG
//#include <QtQuick>
//#endif
#include <QDebug>
#include <QtQuick>

#include <QQmlEngine>
#include <QQuickView>
#include <QGuiApplication>
#include <sailfishapp.h>
//#include <QtDBus>
#include <QDBusInterface>
#include <QDBusReply>
#include <QDBusConnection>
#include <QDBusConnectionInterface>

#include "lib/folderlistmodel/qquickfolderlistmodel.h"
#include "launcher.h"
#include "taglibplugin.h"
#include "taglibimageprovider.h"

#define TALEFISH_SERVICE "de.gibbon.talefish"

int main(int argc, char *argv[])
{

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    //workaround to access pre-harbour-rename settings
    QCoreApplication::setOrganizationName("Talefish");
    QCoreApplication::setOrganizationDomain("Talefish");
    QCoreApplication::setApplicationName("Talefish");
    // if there is a previous instance: do not run at all, instead pass arguments via dbus:
    if(QDBusConnection::sessionBus().interface()->isServiceRegistered(TALEFISH_SERVICE))
    {
        QDBusInterface *previousInstance = new QDBusInterface( "de.gibbon.talefish", "/de/gibbon/talefish", "de.gibbon.talefish" );
        previousInstance->call( "setArguments", QCoreApplication::arguments(), QDir::currentPath());
        return 0;
    }


    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQmlEngine *engine = view->engine();

    engine->addImageProvider(QLatin1String("taglib-cover-art"), new taglibImageprovider);

    qmlRegisterType<Launcher>("Launcher", 1 , 0 , "Launcher");
    qmlRegisterType<taglibplugin>("TaglibPlugin", 1, 0, "TaglibPlugin");
    qmlRegisterType<QQuickFolderListModel>("harbour.talefish.folderlistmodel", 1, 0, "FolderListModel");

    view->setSource(SailfishApp::pathToMainQml());
    view->rootObject()->setProperty("cwd", QDir::currentPath());
    view->showFullScreen();

    return app->exec();

}
