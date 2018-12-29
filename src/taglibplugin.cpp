#include "taglibplugin.h"

taglibplugin::taglibplugin(QObject *parent) : QObject(parent) {}

void taglibplugin::calculateFileTagInfos(QString filePath) {
    TagLib::FileRef f(filePath.toLocal8Bit().data());
    if(!f.isNull() && f.tag()) {
        TagLib::Tag *tag = f.tag();
        setTitle(tag->title().toCString(true));
        setArtist(tag->artist().toCString(true));
        setAlbum(tag->album().toCString(true));
        setYear(tag->year());
        setTrack(tag->track());
    }

    if(!f.isNull() && f.audioProperties()) {
        TagLib::AudioProperties *properties = f.audioProperties();
        setDuration(properties->lengthInMilliseconds());
    }
    setLoaded(true);
    emit tagInfos(mTagTitle,mTagArtist,mTagAlbum,mTagYear,mTagTrack,mTagDuration);
}

void taglibplugin::getFileTagInfos(QString filePath) {
    setLoaded(false);
    QFuture<void> future = QtConcurrent::run(this, &taglibplugin::calculateFileTagInfos, filePath);
    mFutureWatcher.setFuture(future);
}
