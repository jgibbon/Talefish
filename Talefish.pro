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
TARGET = Talefish

CONFIG += sailfishapp

SOURCES += src/Talefish.cpp \
    lib/folderlistmodel/qquickfolderlistmodel.cpp \
    lib/folderlistmodel/plugin.cpp \
    lib/folderlistmodel/fileinfothread.cpp \
    src/launcher.cpp \
    src/taglibplugin.cpp \
    src/taglibimageprovider.cpp

OTHER_FILES += qml/Talefish.qml \
    qml/cover/CoverPage.qml \
    rpm/Talefish.changes.in \
    rpm/Talefish.spec \
    rpm/Talefish.yaml \
    translations/*.ts \
    Talefish.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
QT += dbus

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += \
    translations/talefishts_de.ts \
    translations/talefishts_en.ts \
    translations/talefishts_es.ts \
    translations/talefishts_fi.ts \
    translations/talefishts_hu_HU.ts \
    translations/talefishts_it.ts \
    translations/talefishts_nl.ts \
    translations/talefishts_nl_BE.ts \
    translations/talefishts_pl.ts \
    translations/talefishts_ru.ts \
    translations/talefishts_sl_SI.ts \
    translations/talefishts_sv.ts \
    translations/talefishts_zh_CN.ts

DISTFILES += \
    qml/lib/TalefishPlayer.qml \
    qml/pages/PlayerPage.qml \
    qml/lib/Options.qml \
    qml/lib/PersistentObjectStore.js \
    qml/lib/PersistentObject.qml \
    qml/lib/Appstate.qml \
    qml/lib/Playlist.qml \
    qml/lib/PlaylistView.qml \
    qml/lib/InlineNotification.qml \
    qml/lib/ProgressCassette.qml \
    qml/assets/wheel_1.png \
    qml/icon-l-ffwd.png \
    qml/icon-l-frwd.png \
    qml/icon-l-fwd.png \
    qml/icon-l-rwd.png \
    qml/icon-m-clock.png \
    qml/pages/PlaylistPage.qml \
    qml/pages/OptionsPage.qml \
    qml/lib/OptionComboBox.qml \
    qml/lib/StringScore.js \
    qml/pages/AboutPage.qml \
    qml/lib/ColorIconButton.qml \
    qml/pages/OpenFileDialog.qml \
    qml/pages/OpenFileScanInfosDialog.qml \
    qml/lib/CoverImage.qml \
    qml/pages/OptionsPage_SleepTimer.qml

SUBDIRS += \
    lib/folderlistmodel/folderlistmodel.pro

HEADERS += \
    lib/folderlistmodel/qquickfolderlistmodel.h \
    lib/folderlistmodel/fileproperty_p.h \
    lib/folderlistmodel/fileinfothread_p.h \
    src/launcher.h \
    src/taglibplugin.h \
    src/taglibimageprovider.h

unix: PKGCONFIG += taglib
