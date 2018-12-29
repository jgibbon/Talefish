#ifndef TAGLIBIMAGEPROVIDER_H
#define TAGLIBIMAGEPROVIDER_H


#include <QQmlEngine>
#include <QQuickImageProvider>
#include <QFileInfo>
#include <QImage>
#include <QPainter>

class taglibImageprovider : public QQuickImageProvider
{
public:
    explicit taglibImageprovider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
};

#endif // TAGLIBIMAGEPROVIDER_H
