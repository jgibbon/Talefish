#include "taglibimageprovider.h"
#include <taglib/attachedpictureframe.h>
#include <taglib/id3v2tag.h>
#include <taglib/mpegfile.h>
#include <taglib/mp4file.h>
#include <taglib/flacfile.h>
#include <taglib/vorbisfile.h>
#include <QMimeDatabase>
#include <QDebug>

taglibImageprovider::taglibImageprovider() : QQuickImageProvider(QQuickImageProvider::Image) {}



QImage taglibImageprovider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QImage img;
    QMimeDatabase db;
    QMimeType type = db.mimeTypeForFile(id);
    bool imageFound = false;
        qDebug() << "Mime type:" << type.name();
    if(type.name() == "audio/mp4") {
        TagLib::MP4::File f(id.toStdString().c_str());
        TagLib::MP4::Tag* tag = f.tag();
        TagLib::MP4::ItemListMap itemsListMap = tag->itemListMap();
        TagLib::MP4::Item coverItem = itemsListMap["covr"];
        TagLib::MP4::CoverArtList coverArtList = coverItem.toCoverArtList();
        if (!coverArtList.isEmpty()) {
            imageFound = true;
            TagLib::MP4::CoverArt coverArt = coverArtList.front();
            img.loadFromData((const uchar *) coverArt.data().data(), coverArt.data().size());
        }

    } else if(type.name() == "audio/mpeg"){
        TagLib::MPEG::File mp3(id.toStdString().c_str(), true, TagLib::MPEG::Properties::Fast);
        TagLib::ID3v2::FrameList list = mp3.ID3v2Tag()->frameListMap()["APIC"];

        if(!list.isEmpty()) {
            imageFound = true;
            TagLib::ID3v2::AttachedPictureFrame *Pic = static_cast<TagLib::ID3v2::AttachedPictureFrame *>(list.front());
            img.loadFromData((const uchar *) Pic->picture().data(), Pic->picture().size());
            //            img = img.scaled(45,45);
        }
    } else if(type.name() == "audio/flac") {
        TagLib::FLAC::File f(id.toStdString().c_str());
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
    } else if(type.name() == "audio/ogg" || type.name() == "audio/x-vorbis+ogg" || type.name() == "audio/x-vorbis") {

        qDebug() << "VORBIS";
        TagLib::Ogg::Vorbis::File f(id.toStdString().c_str());
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

//        if (auto *comment = dynamic_cast<TagLib::Ogg::XiphComment *>(f.tag())) {

//            qDebug() << "YES COMMENT";
//            TagLib::String str = "COVERART";

//            if (!comment->contains(str))
//                str = "METADATA_BLOCK_PICTURE";

// //            qDebug() << "WHICH STRING: " << str;

//            qDebug() << "contains?" << comment->contains(str);
//            if (comment->contains(str)) {
//                TagLib::ByteVector tagBytes = comment->fieldListMap()[str].front().data(TagLib::String::Latin1);
//                QByteArray base64;
//                base64.setRawData(tagBytes.data(), tagBytes.size());
//                img.loadFromData(QByteArray::fromBase64(base64));
//                imageFound = true;
//            }
//        }
    }

    if(!imageFound){//make it transparent
        img = QImage(1,1, QImage::Format_ARGB32);
        //        qDebug()<<"depth "<<image.depth(); //prints 32
        img.fill(qRgba(0, 0, 0, 0));
    }
    return img;
}
