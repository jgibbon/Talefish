#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
#include <QProcess>

class Launcher : public QObject
{
    Q_OBJECT

public:
    explicit Launcher(QObject *parent = 0);
    ~Launcher();
    Q_INVOKABLE QString launch(const QString &program);

    Q_INVOKABLE bool fileExists(const QString &path);
    Q_INVOKABLE bool folderExists(const QString &path);
    Q_INVOKABLE void launchAndForget(const QString &program, const QStringList &arguments);
public slots:

protected:
    QProcess *m_process;
};

#endif // LAUNCHER_H
