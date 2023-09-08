#include <QApplication>
#include <QUiLoader>
#include <QtCore>
#include <QtWidgets>

using namespace std;

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QUiLoader loader;
    QWidget* widget;
    QFile file("res/MainWindow.ui");

    file.open(QFile::ReadOnly);
    widget = loader.load(&file, nullptr);
    file.close();

    widget->show();

    return app.exec();
}
