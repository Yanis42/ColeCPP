#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "UiMainWindow.h"

#define CONNECT(sender, action, callback) QObject::connect(sender, SIGNAL(action), SLOT(callback))

using namespace std;

class MainWindow: public QMainWindow {
    Q_OBJECT

    public:
        explicit MainWindow(QWidget* parent = nullptr);
        ~MainWindow();
    
    private slots:
        void onOpenActorFileClicked();
    
    private:
        Ui::MainWindow* ui;
        void setupConnections();
};

#endif // MAINWINDOW_H
