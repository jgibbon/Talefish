# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed 

# The name of your application
TARGET = harbour-talefish

CONFIG += sailfishapp

SOURCES += \
    lib/folderlistmodel/qquickfolderlistmodel.cpp \
    lib/folderlistmodel/plugin.cpp \
    lib/folderlistmodel/fileinfothread.cpp \
    src/harbour-talefish.cpp \
    src/launcher.cpp \
#    src/mpris/mprisobject.cpp \
#    src/mpris/mprisplayer.cpp \
#    src/resourcehandler.cpp \
    src/taglibplugin.cpp \
    src/taglibimageprovider.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    translations/*

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
QT += dbus
QT += multimedia

# using mimer works without this
#opendesktopfile.files = harbour-talefish-open-file.desktop
#opendesktopfile.path = /usr/share/harbour-talefish

INSTALLS += opendesktopfile

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += \
    translations/*.ts

DISTFILES += \
    harbour-talefish.desktop \
    qml/assets/icon-l-ffwd.svg \
    qml/assets/icon-l-fwd.svg \
    qml/assets/wheel_1.png \
    qml/components/FadeImage.qml \
    qml/components/MarqueeLabel.qml \
    qml/components/OptionArea.qml \
    qml/components/OptionComboBox.qml \
    qml/components/OptionsAppearance.qml \
    qml/components/OptionsCommands.qml \
    qml/components/OptionsFiles.qml \
    qml/components/OptionsMisc.qml \
    qml/components/OptionsPlayback.qml \
    qml/components/OptionsSleepTimer.qml \
    qml/components/PlacesDirectoryListItem.qml \
    qml/components/PlacesDirectoryListView.qml \
    qml/components/PlacesDirectoryProgressBar.qml \
    qml/components/PlacesModelComponent.qml \
    qml/components/PlacesModels.qml \
    qml/components/PlayerPageProgressArea.qml \
    qml/components/PlayerPageSeekButton.qml \
    qml/harbour-talefish.qml \
    qml/lib/CoverImage.qml \
    qml/lib/Jslib.js \
    qml/lib/Options.qml \
    qml/lib/PersistentObject.qml \
    qml/lib/PersistentObjectStore.js \
    qml/lib/PlayerCommands.qml \
    qml/lib/PlaylistView.qml \
    qml/lib/ProgressCassette.qml \
    qml/lib/RemoteControl.qml \
    qml/lib/StringScore.js \
    qml/lib/TalefishAudio.qml \
    qml/lib/TalefishPlaylist.qml \
    qml/lib/TalefishState.qml \
    qml/pages/AboutPage.qml \
    qml/pages/OptionsPage.qml \
    qml/pages/PlayerPage.qml \
    qml/pages/PlaylistPage.qml \
    qml/pages/OpenPage.qml \
    rpm/harbour-talefish.changes \
    rpm/harbour-talefish.spec \
    rpm/harbour-talefish.yaml

SUBDIRS += \
    lib/folderlistmodel/folderlistmodel.pro

HEADERS += \
    lib/folderlistmodel/qquickfolderlistmodel.h \
    lib/folderlistmodel/fileproperty_p.h \
    lib/folderlistmodel/fileinfothread_p.h \
    src/launcher.h \
#    src/mpris/mprisobject.h \
#    src/mpris/mprisplayer.h \
#    src/resourcehandler.h \
    src/taglibplugin.h \
    src/taglibimageprovider.h

#LIBS += -ldl

#unix: PKGCONFIG += taglib


DEFINES += MAKE_TAGLIB_LIB
DEFINES += TAGLIB_STATIC=1

DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/it
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpc
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v1
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/flac
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/opus
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/speex
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/vorbis
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/aiff
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/wav
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/s3m
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/trueaudio
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/wavpack
DEPENDPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/xm

INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/it
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpc
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v1
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/flac
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/opus
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/speex
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/vorbis
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/aiff
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/wav
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/s3m
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/trueaudio
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/wavpack
INCLUDEPATH += lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/xm

HEADERS += \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apefile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apefooter.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apeitem.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apeproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apetag.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asfattribute.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asffile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asfpicture.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asfproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asftag.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacmetadatablock.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacpicture.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacunknownmetadatablock.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/it/itfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/it/itproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modfilebase.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modfileprivate.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modtag.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4atom.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4coverart.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4file.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4item.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4properties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4tag.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpc/mpcfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpc/mpcproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v1/id3v1genres.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v1/id3v1tag.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/attachedpictureframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/chapterframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/commentsframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/eventtimingcodesframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/generalencapsulatedobjectframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/ownershipframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/podcastframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/popularimeterframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/privateframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/relativevolumeframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/synchronizedlyricsframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/tableofcontentsframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/textidentificationframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/uniquefileidentifierframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/unknownframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/unsynchronizedlyricsframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/urllinkframe.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2extendedheader.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2footer.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2frame.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2framefactory.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2header.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2synchdata.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2tag.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/mpegfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/mpegheader.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/mpegproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/xingheader.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/flac/oggflacfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/opus/opusfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/opus/opusproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/speex/speexfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/speex/speexproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/vorbis/vorbisfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/vorbis/vorbisproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/oggfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/oggpage.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/oggpageheader.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/xiphcomment.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/aiff/aifffile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/aiff/aiffproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/wav/infotag.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/wav/wavfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/wav/wavproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/rifffile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/s3m/s3mfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/s3m/s3mproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/taglib.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tbytevector.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tbytevectorlist.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tbytevectorstream.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tdebug.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tdebuglistener.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tfilestream.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tiostream.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tlist.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tmap.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tpropertymap.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/trefcounter.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tstring.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tstringlist.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tutils.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tzlib.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/unicode.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/trueaudio/trueaudiofile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/trueaudio/trueaudioproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/wavpack/wavpackfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/wavpack/wavpackproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/xm/xmfile.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/xm/xmproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/audioproperties.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/fileref.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/tag.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/taglib_export.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/tagunion.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/tagutils.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/config.h \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/taglib_config.h

SOURCES += \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apefile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apefooter.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apeitem.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apeproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ape/apetag.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asfattribute.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asffile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asfpicture.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asfproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/asf/asftag.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacmetadatablock.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacpicture.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/flac/flacunknownmetadatablock.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/it/itfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/it/itproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modfilebase.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mod/modtag.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4atom.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4coverart.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4file.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4item.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4properties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mp4/mp4tag.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpc/mpcfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpc/mpcproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v1/id3v1genres.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v1/id3v1tag.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/attachedpictureframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/chapterframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/commentsframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/eventtimingcodesframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/generalencapsulatedobjectframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/ownershipframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/podcastframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/popularimeterframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/privateframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/relativevolumeframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/synchronizedlyricsframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/tableofcontentsframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/textidentificationframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/uniquefileidentifierframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/unknownframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/unsynchronizedlyricsframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/frames/urllinkframe.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2extendedheader.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2footer.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2frame.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2framefactory.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2header.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2synchdata.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/id3v2/id3v2tag.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/mpegfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/mpegheader.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/mpegproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/mpeg/xingheader.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/flac/oggflacfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/opus/opusfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/opus/opusproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/speex/speexfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/speex/speexproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/vorbis/vorbisfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/vorbis/vorbisproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/oggfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/oggpage.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/oggpageheader.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/ogg/xiphcomment.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/aiff/aifffile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/aiff/aiffproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/wav/infotag.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/wav/wavfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/wav/wavproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/riff/rifffile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/s3m/s3mfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/s3m/s3mproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tbytevector.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tbytevectorlist.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tbytevectorstream.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tdebug.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tdebuglistener.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tfilestream.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tiostream.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tpropertymap.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/trefcounter.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tstring.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tstringlist.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/tzlib.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/toolkit/unicode.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/trueaudio/trueaudiofile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/trueaudio/trueaudioproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/wavpack/wavpackfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/wavpack/wavpackproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/xm/xmfile.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/xm/xmproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/audioproperties.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/fileref.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/tag.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/tagutils.cpp \
        lib/taglib-e36a9cabb9882e61276161c23834d966d62073b7/taglib/tagunion.cpp

