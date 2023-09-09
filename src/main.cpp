#include <QApplication>
#include <QtCore>
#include "MainWindow.h"

using namespace std;

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QMainWindow* mainWindow = new QMainWindow;
    Ui::MainWindow ui;
    ui.setupUi(mainWindow);
    mainWindow->show();

    return app.exec();
}
