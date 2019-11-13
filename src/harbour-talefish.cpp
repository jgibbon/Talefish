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

#define TALEFISH_SERVICE "de.gibbon.talefish"

int main(int argc, char *argv[])
{

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    //workaround to access pre-harbour-rename settings
    QCoreApplication::setOrganizationName("Talefish");
    QCoreApplication::setOrganizationDomain("Talefish");
    QCoreApplication::setApplicationName("Talefish");

    // get files/directories to open/enqueue mode from arguments
    QStringList allowedFileExtensions;
    allowedFileExtensions << "mp3" << "m4a" << "m4b" << "flac" << "ogg" << "wav" << "opus" << "aac" << "mka";

    bool doEnqueue = false;
    // for nicer progress saving when opening just one folder:
//    bool openingOneDirectory = false;
    QStringList filesToOpen = QStringList();
    QStringList realArguments = QCoreApplication::arguments();
    realArguments.removeFirst();
    // for directory arguments, we want natural sorting
    QCollator c;
    c.setNumericMode(true);

    for (const QString argumentString : realArguments) {
        if(argumentString == "-e") {
            doEnqueue = true;
        } else { // file handling
            QFile argumentFile(argumentString);
            if(argumentFile.exists()) { // TODO global allowed file extensions? directory?
                QFileInfo argumentFileInfo(argumentFile);
                if(argumentFileInfo.isFile()) {
                    if(allowedFileExtensions.contains(argumentFileInfo.suffix(), Qt::CaseInsensitive)) {
                        // qDebug() << "found valid file name" << argumentFileInfo.absoluteFilePath();
                        filesToOpen << argumentFileInfo.absoluteFilePath();
                    }
                } else if(argumentFileInfo.isDir()) { // open directory contents just for fun
//                    openingOneDirectory = realArguments.length() == 1;
                    QDir argumentDir(argumentFileInfo.absoluteFilePath());
                    argumentDir.setSorting(QDir::Name);
                    QFileInfoList argumentDirContents = argumentDir.entryInfoList();
                    // natural sort
                    std::sort(argumentDirContents.begin(), argumentDirContents.end(), [&c](QFileInfo lhs, QFileInfo rhs) {
                        if(c.compare(lhs.baseName(), rhs.baseName()) < 0) {
                            return true;
                        }
                        return false;
                    });
                    for(const QFileInfo dirContentFile : argumentDirContents) {
                        if(dirContentFile.isFile()) {
                            if(allowedFileExtensions.contains(dirContentFile.suffix(), Qt::CaseInsensitive)) {
//                                qDebug() << "found valid file name in dir" << dirContentFile.absoluteFilePath();
                                filesToOpen << dirContentFile.absoluteFilePath();
                            }
                        }
                    }
                }
            }
        }
    }

    // if there is a previous instance: do not run at all, instead pass arguments via dbus:
    if(QDBusConnection::sessionBus().interface()->isServiceRegistered(TALEFISH_SERVICE))
    {
        qDebug() << "Talefish seems to be running already";
        if(!filesToOpen.isEmpty()) {
            qDebug() << "Opening files with previous instance";
            QDBusInterface *previousInstance = new QDBusInterface( "de.gibbon.talefish", "/de/gibbon/talefish", "de.gibbon.talefish" );
            previousInstance->call( "openFiles", filesToOpen, doEnqueue);
        }
        qDebug() << "quitting";
        return 0;
    }

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQmlEngine *engine = view->engine();
//    QObject::connect(&engine, &QQmlApplicationEngine::quit, &QGuiApplication::quit);

    engine->addImageProvider(QLatin1String("taglib-cover-art"), new taglibImageprovider);
    qmlRegisterType<Launcher>("Launcher", 1 , 0 , "Launcher");
    qmlRegisterType<taglibplugin>("TaglibPlugin", 1, 0, "TaglibPlugin");
    qmlRegisterType<QQuickFolderListModel>("harbour.talefish.folderlistmodel", 1, 0, "FolderListModel");

    view->setSource(SailfishApp::pathToMainQml());
    view->rootObject()->setProperty("allowedFileExtensions", allowedFileExtensions);
    if(!filesToOpen.isEmpty()) {
        qDebug() << "c++ open files";
        view->rootObject()->setProperty("commandLineArgumentDoEnqueue", doEnqueue);
        view->rootObject()->setProperty("commandLineArgumentFilesToOpen", filesToOpen);
    }

    view->showFullScreen();

    return app->exec();

}
