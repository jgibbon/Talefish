#include "launcher.h"
#include <QFile>
#include <QDir>
#include <QFileInfo>

Launcher::Launcher(QObject *parent) :
    QObject(parent),
    m_process(new QProcess(this))
{

}

QString Launcher::launch(const QString &program)
{
    m_process->start(program);
    m_process->waitForFinished(-1);
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}
void Launcher::launchAndForget(const QString &program, const QStringList &arguments)
{
    QProcess *forgettable = new QProcess(this);

    forgettable->startDetached(program, arguments);
}

QString Launcher::fileAbsolutePath(const QString &path)
{
    QFileInfo fileinfo(path);
    return fileinfo.absoluteFilePath();
}

bool Launcher::fileExists(const QString &path)
{
    QFile file(path);
    return file.exists();
}

bool Launcher::folderExists(const QString &path)
{
    QDir folder(path);
    return folder.exists();
}
Launcher::~Launcher() {

}
