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
#ifndef TAGLIBIMAGEPROVIDER_H
#define TAGLIBIMAGEPROVIDER_H


#include <QQmlEngine>
#include <QQuickImageProvider>
#include <QFileInfo>
#include <QImage>
#include <QPainter>
#include <QDir>

class taglibImageprovider : public QQuickImageProvider
{
public:
    explicit taglibImageprovider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);

    static int levenshteinDistance(const QString &source, const QString &target);
    QString nearestName(const QString& actual, const QStringList& candidates);
private:
    QString appDataLocationString;
    QDir appDataLocation;

};

#endif // TAGLIBIMAGEPROVIDER_H
