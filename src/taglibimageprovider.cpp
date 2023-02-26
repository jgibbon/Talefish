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
#include "taglibimageprovider.h"
#include "attachedpictureframe.h"
#include "id3v2tag.h"
#include "mpegfile.h"
#include "mp4file.h"
#include "flacfile.h"
#include "vorbisfile.h"
#include <QMimeDatabase>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QFileInfo>
// levenshtein test
#include <QVector>
// save current image
#include <QStandardPaths>
#include <QCryptographicHash>
#include <QDateTime>

//#include <QElapsedTimer>
//#include <QDebug>

taglibImageprovider::taglibImageprovider() : QQuickImageProvider(QQuickImageProvider::Image) {
    // delete all cached covers
    appDataLocationString = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/coverimg";
    appDataLocation = appDataLocationString;
    appDataLocation.removeRecursively();
}



QImage taglibImageprovider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
//    QElapsedTimer timer;
//    timer.start();

    QImage img;
    QMimeDatabase db;
    QString mediafilePath;
    bool imageFound = false;
    // try to get implicit requestedSize height=width from id as url fragment
    // because then we can still query for sourceSize.width === 1 in qml to check for "no image"
    // we only search for digits here:
    QRegularExpression hashRegex("(.*)(#)(\\d*)$");
    QRegularExpressionMatch hashMatch = hashRegex.match(id);
    if(hashMatch.hasMatch()) {
//        qDebug() << "hashMatch!" << hashMatch.captured(0) << "…" << hashMatch.captured(1) << "…" << hashMatch.captured(2) << "…" << hashMatch.captured(3);
        mediafilePath = hashMatch.captured(1); //id.split("#")[0];
    } else {
        mediafilePath = id;
    }

    QFile mediafile(mediafilePath);
    if (mediafile.exists()) {
        QString mimetype = db.mimeTypeForFile(mediafilePath).name();
        if(mimetype == "audio/mp4" || mimetype == "audio/m4a" || mimetype == "audio/x-m4b" || mimetype == "audio/x-m4a") {
            TagLib::MP4::File f(mediafilePath.toStdString().c_str());
            TagLib::MP4::Tag* tag = f.tag();
            TagLib::MP4::Item coverItem = tag->item("covr");
            TagLib::MP4::CoverArtList coverArtList = coverItem.toCoverArtList();
            if (!coverArtList.isEmpty()) {
                imageFound = true;
                TagLib::MP4::CoverArt coverArt = coverArtList.front();
                img.loadFromData((const uchar *) coverArt.data().data(), coverArt.data().size());
            }
        } else if(mimetype == "audio/mpeg" || mimetype == "audio/x-mp3" || mimetype == "audio/x-mpg" || mimetype == "audio/x-mpeg" || mimetype == "audio/mp3"){
            TagLib::MPEG::File mp3(mediafilePath.toStdString().c_str(), true, TagLib::MPEG::Properties::Fast);
            TagLib::ID3v2::FrameList list = mp3.ID3v2Tag()->frameListMap()["APIC"];

            if(!list.isEmpty()) {
                imageFound = true;
                TagLib::ID3v2::AttachedPictureFrame *Pic = static_cast<TagLib::ID3v2::AttachedPictureFrame *>(list.front());
                img.loadFromData((const uchar *) Pic->picture().data(), Pic->picture().size());
            }
        } else if(mimetype == "audio/flac" || mimetype == "audio/x-flac") {
            TagLib::FLAC::File f(mediafilePath.toStdString().c_str());
            const TagLib::List<TagLib::FLAC::Picture*>& picList = f.pictureList();
            if(!picList.isEmpty()) {
                TagLib::FLAC::Picture* pic = picList[0]; //we assume the first one is the cover, because it's much easier
                QByteArray image_data( pic->data().data(), pic->data().size() );

                if( pic->type() == TagLib::FLAC::Picture::FrontCover )
                {
                    imageFound = true;
                    img.loadFromData( image_data );
                }
            }
        } else if(mimetype == "audio/ogg" || mimetype == "audio/x-vorbis+ogg" || mimetype == "audio/x-flac+ogg" || mimetype == "audio/x-ogg" || mimetype == "audio/x-vorbis") {
            TagLib::Ogg::Vorbis::File f(mediafilePath.toStdString().c_str());
            TagLib::Ogg::XiphComment* tag = f.tag();
            const TagLib::List<TagLib::FLAC::Picture*>& picList = tag->pictureList();
            if(!picList.isEmpty()) {
                TagLib::FLAC::Picture* pic = picList[0]; //we assume the first one is the cover, because it's much easier
                QByteArray image_data( pic->data().data(), pic->data().size() );

                if( pic->type() == TagLib::FLAC::Picture::FrontCover )
                {
                    imageFound = true;
                    img.loadFromData( image_data );
                }
            }
        }

        // search for external cover image
        if(!imageFound) {
            QFileInfo mediafileinfo(mediafile);
            QDir filedir = mediafileinfo.absoluteDir();
            QStringList images = filedir.entryList(QStringList() << "*.jpg" << "*.JPG" << "*.png" << "*.PNG" << "*.bmp" << "*.BMP", QDir::Files, QDir::Name);
            if(images.count() > 0) {
                imageFound = true;
                img.load(filedir.absolutePath()+"/"+this->nearestName(mediafileinfo.fileName(), images));
            }
        }
    }

    if(!imageFound){// make it transparent
        img = QImage(1,1, QImage::Format_ARGB32);
        img.fill(qRgba(0, 0, 0, 0));
        if(size) {
            *size = QSize(1, 1);
        }
    } else {
        if(requestedSize.width() > 0 && requestedSize.height() > 0) {
//            qDebug() << "scaling " << requestedSize.width() << "x" << requestedSize.height() << "";
            img = img.scaled(requestedSize, Qt::KeepAspectRatio, Qt::SmoothTransformation);
        } else {
            if(hashMatch.hasMatch()) { // for really small versions in lists
//                qDebug() << "image has fragment: " << idUrl.fragment().toInt();
                QSize implicitRequestedSize(hashMatch.captured(3).toInt(), hashMatch.captured(3).toInt());
                img = img.scaled(implicitRequestedSize, Qt::KeepAspectRatio);
            }
        }
        if(size) {
            *size = QSize(img.width(), img.height());
        }
    }


    // save the album art for mpris / lock screen

    QString mediaLocationHash = QString(QCryptographicHash::hash((mediafilePath.toUtf8()),QCryptographicHash::Md5).toHex());

    QFile coverimage(appDataLocationString + "/" + mediaLocationHash + ".jpg");
    QDateTime now = QDateTime::currentDateTime();

    // qDebug() << "paths…" << mediafilePath << "hashy" << mediaLocationHash << coverimage.fileName();
    if(!coverimage.exists()) {
        QFileInfoList previousCovers = appDataLocation.entryInfoList(QDir::Files);
        for (const QFileInfo &previousCoverInfo : previousCovers) {
            if(previousCoverInfo.created().daysTo(now) > 3) { // delete old files just in case
                QFile delFile(previousCoverInfo.filePath());
                delFile.remove();
            }
        }
        // qDebug() << "creating path for image copy" << appDataLocationString; // << "hashy" << mediaLocationHash;
        appDataLocation.mkpath(".");

        img.save(coverimage.fileName(),"JPG",90);
    }


//    qDebug() << "Image took" << timer.elapsed() << "milliseconds";
    return img;
}

int taglibImageprovider::levenshteinDistance(const QString &source, const QString &target)
{
    // from https://qgis.org/api/2.14/qgsstringutils_8cpp_source.html which is GPL2, so all is well.

   if (source == target) {
       return 0;
   }

   const int sourceCount = source.count();
   const int targetCount = target.count();

   if (source.isEmpty()) {
       return targetCount;
   }

   if (target.isEmpty()) {
       return sourceCount;
   }

   if (sourceCount > targetCount) {
       return levenshteinDistance(target, source);
   }

   QVector<int> column;
   column.fill(0, targetCount + 1);
   QVector<int> previousColumn;
   previousColumn.reserve(targetCount + 1);
   for (int i = 0; i < targetCount + 1; i++) {
       previousColumn.append(i);
   }

   for (int i = 0; i < sourceCount; i++) {
       column[0] = i + 1;
       for (int j = 0; j < targetCount; j++) {
           column[j + 1] = std::min({
               1 + column.at(j),
               1 + previousColumn.at(1 + j),
               previousColumn.at(j) + ((source.at(i) == target.at(j)) ? 0 : 1)
           });
       }
       column.swap(previousColumn);
   }

   return previousColumn.at(targetCount);
}

QString taglibImageprovider::nearestName(const QString &actual, const QStringList &candidates)
{
    int deltaBest = 10000;
    QString best;
    QString actualBaseName = QFileInfo(actual).baseName().toLower();
    for (const QString &candidate : candidates) {

        QString candidateBaseName = QFileInfo(candidate).baseName().toLower();
        int delta;
        if(candidateBaseName == "cover" || candidateBaseName == "folder" || candidateBaseName == "album") {
            delta = 10; // arbitrary low-ish number for common cover names
        } else {
            delta = this->levenshteinDistance(actualBaseName, candidateBaseName);
        }
        if ( delta < deltaBest )
        {
            deltaBest = delta;
            best = candidate;
        }
    }
    return best;
}
