import QtQuick 2.1
import QtWebEngine 1.1
import Qt.labs.settings 1.0

QtObject {
    id: application

    property var bookmarks: []
    signal bookmarks_changed()

    property QtObject settings: Settings {
        property var bookmarks
    }


    property QtObject default_profile: WebEngineProfile {
        storageName: "Default"
    }

    property Component browser_window_component: BrowserWindow {
        app: application
    }

    function createWindow (){
        var newWindow = browser_window_component.createObject(application)
        return newWindow
    }
    function createDialog(request) {
        var newDialog = browser_window_component.createObject(application)
        var tab = newDialog.add_tab("about:blank")
        request.openIn(tab.webview)
        return newDialog
    }
    function load() {
        var browserWindow = createWindow()
    }

    Component.onCompleted: {
        console.log("Locale name: " + Qt.locale().name)
        application.bookmarks = settings.bookmarks;
    }

    Component.onDestruction: {
        settings.bookmarks = application.bookmarks;
    }

}
