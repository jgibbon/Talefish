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
QT += concurrent

# using mimer works without this
# opendesktopfile.files = harbour-talefish-open-file.desktop
# opendesktopfile.path = /usr/share/harbour-talefish

# INSTALLS += opendesktopfile

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += \
    translations/*.ts

DISTFILES += \
    harbour-talefish.desktop \
    qml/harbour-talefish.qml \
    qml/pages/AboutPage.qml \
    qml/pages/OpenPage.qml \
    qml/pages/OptionsPage.qml \
    qml/pages/PlayerPage.qml \
    qml/pages/PlaylistPage.qml \
    qml/visual/FadeImage.qml \
    qml/visual/ProgressCassette.qml \
    qml/visual/silica/MarqueeLabel.qml \
    qml/visual/silica/OptionArea.qml \
    qml/visual/silica/OptionComboBox.qml \
    qml/visual/silica/OptionsAppearance.qml \
    qml/visual/silica/OptionsCommands.qml \
    qml/visual/silica/OptionsFiles.qml \
    qml/visual/silica/OptionsMisc.qml \
    qml/visual/silica/OptionsPlayback.qml \
    qml/visual/silica/OptionsSleepTimer.qml \
    qml/visual/silica/PlacesDirectoryListItem.qml \
    qml/visual/silica/PlacesDirectoryListItemDirectory.qml \
    qml/visual/silica/PlacesDirectoryListView.qml \
    qml/visual/silica/PlacesDirectoryProgressBar.qml \
    qml/visual/silica/PlacesModelComponent.qml \
    qml/visual/silica/PlacesModels.qml \
    qml/visual/silica/PlayerPageContent.qml \
    qml/visual/silica/PlayerPageProgressArea.qml \
    qml/visual/silica/PlayerPageSeekButton.qml \
    qml/visual/silica/PlaylistView.qml \
    qml/cover/CoverPage.qml \
    qml/lib/Jslib.js \
    qml/lib/Options.qml \
    qml/lib/PersistentObject.qml \
    qml/lib/PersistentObjectStore.js \
    qml/lib/PlayerCommands.qml \
    qml/lib/RemoteControl.qml \
    qml/lib/TalefishAudio.qml \
    qml/lib/TalefishPlaylist.qml \
    qml/lib/TalefishState.qml \
    qml/assets/icon-l-ffwd.svg \
    qml/assets/icon-l-fwd.svg \
    qml/assets/wheel_1.png \
    qml/assets/icon-cover-dark-frwd.png \
    qml/assets/icon-cover-dark-rwd.png \
    qml/assets/icon-cover-dark-fwd.png \
    qml/assets/icon-cover-dark-ffwd.png \
    qml/assets/icon-cover-light-frwd.png \
    qml/assets/icon-cover-light-rwd.png \
    qml/assets/icon-cover-light-fwd.png \
    qml/assets/icon-cover-light-ffwd.png \
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
    src/taglibplugin.h \
    src/taglibimageprovider.h

DEFINES += MAKE_TAGLIB_LIB
DEFINES += TAGLIB_STATIC=1

DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/3rdparty
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/it
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpc
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v1
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/flac
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/opus
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/speex
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/vorbis
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/aiff
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/wav
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/s3m
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/trueaudio
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/wavpack
DEPENDPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/xm

INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/3rdparty
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/it
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpc
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v1
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/flac
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/opus
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/speex
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/vorbis
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/aiff
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/wav
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/s3m
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/trueaudio
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/wavpack
INCLUDEPATH += lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/xm
HEADERS += \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/3rdparty/utf8-cpp/checked.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/3rdparty/utf8-cpp/core.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/audioproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/taglib_export.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/fileref.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asfutils.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asfproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asftag.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asffile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asfattribute.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asfpicture.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/it/itfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/it/itproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tdebug.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/trefcounter.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tstring.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tiostream.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tbytevectorlist.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/taglib.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tbytevectorstream.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tpropertymap.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tdebuglistener.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tfilestream.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tbytevector.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tmap.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tstringlist.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tzlib.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tutils.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tlist.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/tagunion.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/oggpage.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/vorbis/vorbisproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/vorbis/vorbisfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/flac/oggflacfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/opus/opusproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/opus/opusfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/xiphcomment.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/speex/speexfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/speex/speexproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/oggpageheader.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/oggfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modtag.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modfileprivate.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modfilebase.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/wavpack/wavpackfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/wavpack/wavpackproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacpicture.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacmetadatablock.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacunknownmetadatablock.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/riffutils.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/wav/wavfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/wav/infotag.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/wav/wavproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/rifffile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/aiff/aifffile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/aiff/aiffproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/s3m/s3mproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/s3m/s3mfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/tag.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/trueaudio/trueaudioproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/trueaudio/trueaudiofile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/tagutils.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpc/mpcproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpc/mpcfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/xm/xmproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/xm/xmfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4file.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4tag.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4coverart.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4atom.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4properties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4item.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/mpegutils.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v1/id3v1tag.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v1/id3v1genres.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/mpegproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/xingheader.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2header.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/attachedpictureframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/urllinkframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/uniquefileidentifierframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/unsynchronizedlyricsframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/tableofcontentsframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/podcastframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/ownershipframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/popularimeterframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/commentsframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/generalencapsulatedobjectframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/synchronizedlyricsframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/privateframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/eventtimingcodesframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/unknownframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/textidentificationframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/chapterframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/relativevolumeframe.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2synchdata.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2tag.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2frame.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2framefactory.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2extendedheader.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2footer.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/mpegfile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/mpegheader.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apetag.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apeitem.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apefile.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apeproperties.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apefooter.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/3rdparty/utf8-cpp/checked.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/3rdparty/utf8-cpp/core.h \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/bindings/c/tag_c.h

SOURCES += \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asffile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asfpicture.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asfattribute.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asftag.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/asf/asfproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/it/itfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/it/itproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/tagunion.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/trefcounter.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tfilestream.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tbytevector.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tdebuglistener.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tzlib.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tiostream.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tstring.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tdebug.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tstringlist.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tbytevectorstream.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tpropertymap.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/toolkit/tbytevectorlist.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/oggpageheader.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/oggfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/vorbis/vorbisfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/vorbis/vorbisproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/flac/oggflacfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/opus/opusproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/opus/opusfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/speex/speexfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/speex/speexproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/oggpage.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ogg/xiphcomment.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/audioproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modtag.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modfilebase.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mod/modfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/fileref.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/wavpack/wavpackfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/wavpack/wavpackproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacunknownmetadatablock.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacmetadatablock.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacpicture.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/flac/flacfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/rifffile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/wav/infotag.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/wav/wavproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/wav/wavfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/aiff/aifffile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/riff/aiff/aiffproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/s3m/s3mfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/s3m/s3mproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/trueaudio/trueaudioproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/trueaudio/trueaudiofile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/tag.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpc/mpcfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpc/mpcproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/tagutils.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/xm/xmfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/xm/xmproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4file.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4coverart.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4tag.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4properties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4atom.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mp4/mp4item.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/mpegproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/xingheader.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v1/id3v1tag.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v1/id3v1genres.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/mpegheader.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2footer.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2extendedheader.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/uniquefileidentifierframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/popularimeterframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/relativevolumeframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/podcastframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/attachedpictureframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/unknownframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/commentsframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/generalencapsulatedobjectframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/ownershipframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/textidentificationframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/privateframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/unsynchronizedlyricsframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/chapterframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/synchronizedlyricsframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/tableofcontentsframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/eventtimingcodesframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/frames/urllinkframe.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2synchdata.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2frame.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2tag.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2header.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/id3v2/id3v2framefactory.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/mpeg/mpegfile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apefile.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apetag.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apeitem.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apefooter.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/taglib/ape/apeproperties.cpp \
    lib/taglib-54508df30bc888c4d2359576ceb0cc8f2fa8dbdf/bindings/c/tag_c.cpp
