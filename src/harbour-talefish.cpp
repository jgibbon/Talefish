/*

Talefish Audiobook Player
Copyright (C) 2016-2019  John Gibbon

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

*/
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
//#include "resourcehandler.h"
//#include "mpris/mprisobject.h"

//#include "lib/qtmpris-1.0.0/src/Mpris"
//#include "lib/qtmpris-1.0.0/src/MprisPlayer"
//#include "lib/qtmpris-1.0.0/src/MprisManager"

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

//    ResourceHandler handler;
//    handler.acquire();

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQmlEngine *engine = view->engine();
//    QObject::connect(&engine, &QQmlApplicationEngine::quit, &QGuiApplication::quit);

    engine->addImageProvider(QLatin1String("taglib-cover-art"), new taglibImageprovider);
    qmlRegisterType<Launcher>("Launcher", 1 , 0 , "Launcher");
    qmlRegisterType<taglibplugin>("TaglibPlugin", 1, 0, "TaglibPlugin");
//    qmlRegisterType<MprisPlayer>("MprisPlayer", 1, 0, "MprisPlayer");
    qmlRegisterType<QQuickFolderListModel>("harbour.talefish.folderlistmodel", 1, 0, "FolderListModel");

    view->setSource(SailfishApp::pathToMainQml());
    view->rootObject()->setProperty("cwd", QDir::currentPath());
//    view->rootObject()->setProperty("mprisplayer", mprisplayer);

//    QObject::connect(view->rootObject(),SIGNAL(aquireResources()), &handler, SLOT(acquire()));
//    QObject::connect(view->rootObject(),SIGNAL(releaseResources()), &handler, SLOT(release()));

    view->showFullScreen();

    return app->exec();

}
