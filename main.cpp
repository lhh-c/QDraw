#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    // 1. 最基本的应用程序初始化
    QGuiApplication app(argc, argv);

    // 2. 创建QML引擎
    QQmlApplicationEngine engine;

    // 3. 加载QML文件（假设Main.qml与可执行文件同目录）
    engine.load(QUrl("/run/media/root/study/大二下课程设计/test/Window.qml"));

    // 4. 简单错误检查
    if (engine.rootObjects().isEmpty()) return -1;

    // 5. 运行程序
    return app.exec();
}
