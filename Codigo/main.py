# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from Backend import *

from PySide6 import QtGui
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QtGui.QIcon('./qml/icons/dice.png'))
    engine = QQmlApplicationEngine()

    # Get the context
    backend = Backend()
    engine.rootContext().setContextProperty('backend',backend)

    # Load QML File
    engine.load(os.fspath(Path(__file__).resolve().parent / "qml/main.qml"))
    
    if not engine.rootObjects():
        sys.exit(-1)
    app.exec()
