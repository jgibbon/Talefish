TARGET  = qmlfolderlistmodelplugin
TARGETPATH = it/mardy/folderlistmodel
DESTDIR = $${TARGETPATH}
TEMPLATE = lib

QT += quick

CONFIG += plugin

SOURCES += qquickfolderlistmodel.cpp plugin.cpp \
    fileinfothread.cpp
HEADERS += qquickfolderlistmodel.h \
    fileproperty_p.h \
    fileinfothread_p.h

QTDIR_build:DESTDIR = $$QT_BUILD_TREE/imports/$$TARGETPATH
target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

qmldir.files += $$DESTDIR/qmldir
qmldir.path +=  $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += target qmldir
