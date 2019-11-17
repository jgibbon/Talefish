#include "resourcehandler.h"
#include <dlfcn.h>
#include <QDebug>

void grant_callback(resource_set_t *, uint32_t, void *) {}

static resource_set_t *(*create_set)(const char*,uint32_t,uint32_t, uint32_t, resource_callback_t, void *);
static int (*acquire_set)(resource_set_t*);
static int (*release_set)(resource_set_t*);

ResourceHandler::ResourceHandler(QObject *parent) :
    QObject(parent)
{
    m_handle = dlopen ("/usr/lib/libresource-glib.so.0", RTLD_LAZY);

    if (m_handle) {
        create_set = (resource_set_t* (*)(const char*, uint32_t, uint32_t, uint32_t, resource_callback_t, void*))dlsym(m_handle, "resource_set_create");
        if (!create_set) {
            qDebug() << dlerror();
        }
        acquire_set = (int (*)(resource_set_t*))dlsym(m_handle, "resource_set_acquire");
        if (!acquire_set) {
            qDebug() << dlerror();
        }
        release_set = (int (*)(resource_set_t*))dlsym(m_handle, "resource_set_release");
        if (!release_set) {
            qDebug() << dlerror();
        }
        if (!create_set || !acquire_set || !release_set) {
            qDebug() << "Error in dlsym to one of the functions";
        } else {
            m_resource = create_set("player", RESOURCE_AUDIO_PLAYBACK|RESOURCE_HEADSET_BUTTONS, 0, 0, &grant_callback, nullptr);
        }
    }
}

void ResourceHandler::acquire()
{
    qDebug() << "aquire";
    if (acquire_set){
        acquire_set(m_resource);
    }
}

void ResourceHandler::release()
{
    qDebug() << "release";
    if (release_set) {
        release_set(m_resource);
    }
}

void ResourceHandler::handleFocusChange(QObject *focus)
{
    if (focus == nullptr) {
        release();
    } else {
        acquire();
    }
}
