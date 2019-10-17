#include "taglibplugin.h"
#include <QMimeDatabase>
//#include <QDebug>

taglibplugin::taglibplugin(QObject *parent) : QObject(parent) {}

void taglibplugin::calculateFileTagInfos(QString filePath) {

    QMimeDatabase db;
    QString mimetype = db.mimeTypeForFile(filePath).name();
//    qDebug() << "mimetype:" << mimetype;
    TagLib::FileRef f(filePath.toLocal8Bit().data());
    if(!f.isNull() && f.tag()) {
        TagLib::Tag *tag = f.tag();
        setTitle(tag->title().toCString(true));
        setArtist(tag->artist().toCString(true));
        setAlbum(tag->album().toCString(true));
        setYear(tag->year());
        setTrack(tag->track());
    } else {
        setTitle("");
        setArtist("");
        setAlbum("");
        setYear(0);
        setTrack(0);

    }

    if(!f.isNull() && f.audioProperties()) {
        TagLib::AudioProperties *properties = f.audioProperties();
        setDuration(properties->lengthInMilliseconds());
    }
    // workaround: mka and aac not supported but without error… would not work for aac in other containers
    if(mimetype == "audio/x-matroska" || mimetype == "audio/aac") {
        setDuration(0);
    }
    setLoaded(true);
    emit tagInfos(mTagTitle,mTagArtist,mTagAlbum,mTagYear,mTagTrack,mTagDuration);
}

void taglibplugin::getFileTagInfos(QString filePath) {
    setLoaded(false);
    QFuture<void> future = QtConcurrent::run(this, &taglibplugin::calculateFileTagInfos, filePath);
    mFutureWatcher.setFuture(future);
}
