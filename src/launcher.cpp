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
#include "launcher.h"
#include <QDebug>

#include <QCryptographicHash>

Launcher::Launcher(QObject *parent) : QObject(parent),
    m_process(new QProcess(this))
{

}

QString Launcher::launch(const QString &program)
{
    m_process->start(program);
    m_process->waitForFinished(-1);
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}
void Launcher::launchAndForget(const QString &program, const QStringList &arguments)
{
    QProcess *forgettable = new QProcess(this);
    forgettable->startDetached(program, arguments);
}

void Launcher::migrateTalefishDatabase()
{
    QString oldPath = QDir::homePath()+"/.local/share/Talefish";
    if(folderExists(oldPath)) {
        qDebug() << "Old database exists. Trying to migrate to harbour-compatible path.";

        qDebug() << QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
//        QDir folder(path);
//        return folder.mkpath(path);
    }
}

QString Launcher::fileAbsolutePath(const QString &path)
{
    QFileInfo fileinfo(path);
    return fileinfo.absoluteFilePath();
}

bool Launcher::fileExists(const QString &path)
{
    QFile file(path);
    return file.exists();
}

bool Launcher::folderExists(const QString &path)
{
    QDir folder(path);
    return folder.exists();
}

QString Launcher::getSFVersion()
{
    QString val = this->launch("bash -c \"rpm -qa --queryformat '%{NAME} %{VERSION}\n' | grep sailfish-version\"");
    QRegExp rx("(\\d+.\\d+)");
    int pos = rx.indexIn(val);
    if (pos > -1) {
        return rx.cap(1);
    } else {
        return "0.0";
    }
}

QString Launcher::getRoot() {
    return QDir::rootPath();
}

QList<QVariant> Launcher::getExternalVolumes()
{
    QList<QVariant> mounts;

    foreach (const QStorageInfo &storage, QStorageInfo::mountedVolumes()) {
            if (storage.isValid() && storage.isReady() && (storage.rootPath().indexOf("/run/media") == 0 || storage.rootPath().indexOf("/media") == 0)) {
                QStringList mountList(storage.device());
                mountList.append(storage.rootPath());
                mounts.append(QVariant(mountList));
            }
    }
    return mounts;
}

QString Launcher::getGeneratedCoverImgPath(const QString &mediafilePath)
{

    QString appDataLocation = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/coverimg/";
    QString mediaLocationHash = QString(QCryptographicHash::hash((mediafilePath.toUtf8()),QCryptographicHash::Md5).toHex());
    QString coverImgPath = appDataLocation + "/" + mediaLocationHash + ".jpg";
    return coverImgPath;
}
//  using mimer works without this, but we may need something like it in the future
//void Launcher::setupFileHandling(const bool activate)
//{
//    qDebug() << "setupFileHandling" << activate;
//    QString homeDir = QDir().homePath();
//    QFile fileInterface;
//    QString desktopTargetPath = homeDir + "/.local/share/applications/harbour-talefish-open-file.desktop";
//    bool desktopTargetExists = fileExists(desktopTargetPath);
//    qDebug() << "target exists" << desktopTargetExists << "source" << fileExists("/usr/share/harbour-talefish/harbour-talefish-open-file.desktop");
//    if (activate && !desktopTargetExists) {
//        fileInterface.copy("/usr/share/harbour-talefish/harbour-talefish-open-file.desktop", desktopTargetPath);
//        launchAndForget("update-desktop-database ", QStringList(homeDir +"/.local/share/applications"));
//        qDebug() << "enabled file handling";
//    } else if (!activate && desktopTargetExists) {
//        fileInterface.remove(desktopTargetPath);
//        launchAndForget("update-desktop-database ", QStringList(homeDir +"/.local/share/applications"));
//        qDebug() << "disable file handling";
//    }
//}


Launcher::~Launcher() {

}
