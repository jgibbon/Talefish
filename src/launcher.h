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
#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
#include <QProcess>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QStorageInfo>
#include <QVariant>
#include <QRegExp>
#include <QStandardPaths> // for migrateTalefishDatabase

class Launcher : public QObject
{
    Q_OBJECT
public:
    explicit Launcher(QObject *parent = nullptr);
    ~Launcher();
    Q_INVOKABLE QString launch(const QString &program);
    Q_INVOKABLE QString fileAbsolutePath(const QString &path);

    Q_INVOKABLE bool fileExists(const QString &path);
    Q_INVOKABLE bool folderExists(const QString &path);
    Q_INVOKABLE void launchAndForget(const QString &program, const QStringList &arguments);
    Q_INVOKABLE void migrateTalefishDatabase();
    Q_INVOKABLE QString getRoot();
    Q_INVOKABLE QList<QVariant> getExternalVolumes();

//    Q_INVOKABLE void setupFileHandling(const bool activate);

    Q_INVOKABLE QString getSFVersion();
signals:

public slots:
protected:
    QProcess *m_process;
};

#endif // LAUNCHER_H
