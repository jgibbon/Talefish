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
#include "taglibplugin.h"
#include <QMimeDatabase>
#include <QDebug>
#include <QMediaPlayer>
#include <QUrl>

taglibplugin::taglibplugin(QObject *parent) : QObject(parent) {
//    QObject::connect(this, SIGNAL(incompleteDuration(QString, QString, QString, qint64, qint64, qint64, qint64, QString, bool)),
//                     this,  SLOT(fixIncompleteDuration(QString, QString, QString, qint64, qint64, qint64, qint64, QString, bool)));
    QObject::connect(this, &taglibplugin::incompleteDuration,
                     this,  &taglibplugin::fixIncompleteDuration);
}

// queryIndex just gets pushed out to ease matching for list operations
// setActive=false if you don't need the actual component properties
void taglibplugin::calculateFileTagInfos(QString filePath, qint64 queryIndex = -1, bool setActive=true) {
    QMimeDatabase db;
    QString mimetype = db.mimeTypeForFile(filePath).name();
    TagLib::FileRef f(filePath.toLocal8Bit().data());
    QString ltitle = "";
    QString lartist = "";
    QString lalbum = "";
    qint64 lyear = 0;
    qint64 ltrack = 0;
    qint64 lduration = 0;

    if(!f.isNull() && f.tag()) {
        TagLib::Tag *tag = f.tag();
        ltitle = tag->title().toCString(true);
        lartist = tag->artist().toCString(true);
        lalbum = tag->album().toCString(true);
        lyear = tag->year();
        ltrack = tag->track();
    }

    // workaround: mka and aac not supported but without error… would not work for aac in other containers
    if(mimetype == "audio/x-matroska" || mimetype == "audio/aac") {
        lduration = 0;
    } else if(!f.isNull() && f.audioProperties()) {
        TagLib::AudioProperties *properties = f.audioProperties();
        lduration = properties->lengthInMilliseconds();
    }
    // fallbacks:
    if(lduration < 1) {
        emit incompleteDuration(ltitle,lartist,lalbum,lyear,ltrack,lduration,queryIndex, filePath, setActive);
    }

    if(setActive) {
        setTitle(ltitle);
        setArtist(lartist);
        setAlbum(lalbum);
        setYear(lyear);
        setTrack(ltrack);
        setDuration(lduration);
        setLoaded(true);
    }
    //    qDebug() << "tl query title" << ltitle;
    emit tagInfos(ltitle,lartist,lalbum,lyear,ltrack,lduration,queryIndex, filePath);
}

void taglibplugin::fixIncompleteDuration(QString title, QString artist, QString album, qint64 year, qint64 track, qint64 duration, qint64 queryIndex, QString filePath, bool setActive)
{

        qDebug() << "duration workaround for:" << filePath;
        taglibplugin *inst = this;

        QMediaPlayer *player = new QMediaPlayer(this);
        player->setAudioRole(QAudio::AlarmRole);
        connect(player, &QMediaPlayer::durationChanged, this, [title,artist,album,year,track,duration,queryIndex, filePath, setActive, inst,player](qint64 dur) mutable {

            qDebug() << "duration = " << dur;
                player->stop();
                if(setActive) {
                    inst->setDuration(dur);
                }
                emit inst->tagInfos(title,artist,album,year,track,dur,queryIndex, filePath);
                player->deleteLater();
        });
        player->setMedia(QUrl::fromLocalFile(filePath));
        player->setVolume(0);
        player->play();
        // todo: delete on error
}

void taglibplugin::getFileTagInfos(QString filePath, qint64 queryIndex=-1, bool setActive=true) {
    if(setActive) {
        setLoaded(false);
    }
    QFuture<void> future = QtConcurrent::run(this, &taglibplugin::calculateFileTagInfos, filePath, queryIndex, setActive);
    mFutureWatcher.setFuture(future);
}


void taglibplugin::getFileTagInfos(QString filePath) {
    setLoaded(false);
    QFuture<void> future = QtConcurrent::run(this, &taglibplugin::calculateFileTagInfos, filePath, -1, true);
    mFutureWatcher.setFuture(future);
}
