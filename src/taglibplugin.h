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
#ifndef MEDIAINFO_H
#define MEDIAINFO_H

#include <QObject>
#include <QFutureWatcher>
#include <QtConcurrent/QtConcurrent>
#include <QImage>

#include "fileref.h"
#include "tag.h"
#include "tpropertymap.h"


class taglibplugin : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool loaded READ loaded WRITE setLoaded NOTIFY loadedChanged)

    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(QString album READ album WRITE setAlbum NOTIFY albumChanged)
    Q_PROPERTY(qint64 year READ year WRITE setYear NOTIFY yearChanged)
    Q_PROPERTY(qint64 track READ track WRITE setTrack NOTIFY trackChanged)
    Q_PROPERTY(qint64 duration READ duration WRITE setDuration NOTIFY durationChanged)
//    Q_PROPERTY(QImage cover READ cover WRITE setCover NOTIFY coverChanged)

public:
    explicit taglibplugin(QObject *parent = nullptr);
    //    SingleFileTagInfos* mTaginfos;
    void setLoaded(const bool &a) {
        if (a != mLoaded) {
            mLoaded = a;
            emit loadedChanged();
        }
    }
    bool loaded() const {
        return mLoaded;
    }

    void setPath(const QString &a) {
        if (a != mFilePath) {
            mFilePath = a;
            emit pathChanged();
        }
    }
    QString path() const {
        return mFilePath;
    }

    void setArtist(const QString &a) {
        if (a != mTagArtist) {
            mTagArtist = a;
            emit artistChanged();
        }
    }
    QString artist() const {
        return mTagArtist;
    }

    void setTitle(const QString &a) {
        if (a != mTagTitle) {
            mTagTitle = a;
            emit titleChanged();
        }
    }
    QString title() const {
        return mTagTitle;
    }

    void setAlbum(const QString &a) {
        if (a != mTagAlbum) {
            mTagAlbum = a;
            emit albumChanged();
        }
    }
    QString album() const {
        return mTagAlbum;
    }

    void setYear(const qint64 &a) {
        if (a != mTagYear) {
            mTagYear = a;
            emit yearChanged();
        }
    }
    qint64 year() const {
        return mTagYear;
    }

    void setTrack(const qint64 &a) {
        if (a != mTagTrack) {
            mTagTrack = a;
            emit trackChanged();
        }
    }
    qint64 track() const {
        return mTagTrack;
    }

    void setDuration(const qint64 &a) {
        if (a != mTagDuration) {
            mTagDuration = a;
            emit durationChanged();
        }
    }
    qint64 duration() const {
        return mTagDuration;
    }


//    void setCover(const QImage &a) {
//        if (a != mCoverImage) {
//            mCoverImage = a;
//            emit coverChanged();
//        }
//    }
//    QImage cover() const {
//        return mCoverImage;
//    }

signals:
    void tagInfos(QString title, QString artist, QString album, qint64 year, qint64 track, qint64 duration, qint64 queryIndex, QString filePath);
    void incompleteDuration(QString title, QString artist, QString album, qint64 year, qint64 track, qint64 duration, qint64 queryIndex, QString filePath, bool setActive);

    void pathChanged();
    void titleChanged();
    void artistChanged();
    void albumChanged();
    void yearChanged();
    void trackChanged();
    void durationChanged();
    void loadedChanged();
//    void coverChanged();

public slots:
    void getFileTagInfos(QString filePath, qint64 queryIndex, bool setActive);
    void getFileTagInfos(QString filePath);
//    void getFileCoverArt(QString filePath);
private slots:
    void fixIncompleteDuration(QString title, QString artist, QString album, qint64 year, qint64 track, qint64 duration, qint64 queryIndex, QString filePath, bool setActive);
private:
    QFutureWatcher<void> mFutureWatcher;
    void calculateFileTagInfos(QString filePath, qint64 queryIndex, bool setActive);
//    void extractFileCoverArt(QString filePath);
    bool mLoaded;
    QString mFilePath;
    QString mTagTitle;
    QString mTagArtist;
    QString mTagAlbum;
    qint64 mTagYear;
    qint64 mTagTrack;
    qint64 mTagDuration;
//    QImage mCoverImage;
};
#endif // MEDIAINFO_H
