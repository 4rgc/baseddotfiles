pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    property string keybindParserPath: FileUtils.trimFileProtocol(`${Directories.scriptPath}/hyprland/get_keybinds.py`)
    property string userKeybindConfigPath: FileUtils.trimFileProtocol(`${Directories.config}/hypr/custom/keybinds.conf`)
    property var userKeybinds: {"children": []}
    property var keybinds: buildKeybinds(userKeybinds)

    function buildKeybinds(user) {
        var userChildren = user.children || [];
        var userColumns = [];
        var sectionsPerColumn = 3;
        
        for (var i = 0; i < userChildren.length; i += sectionsPerColumn) {
            var columnSections = userChildren.slice(i, i + sectionsPerColumn);
            var nonEmpty = [];
            for (var j = 0; j < columnSections.length; j++) {
                if (columnSections[j].keybinds && columnSections[j].keybinds.length > 0) {
                    nonEmpty.push(columnSections[j]);
                }
            }
            if (nonEmpty.length > 0) {
                userColumns.push({name: "", keybinds: [], children: nonEmpty});
            }
        }
        return {children: userColumns};
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name == "configreloaded") {
                getUserKeybinds.running = true
            }
        }
    }

    Process {
        id: getUserKeybinds
        running: true
        command: [root.keybindParserPath, "--path", root.userKeybindConfigPath]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.userKeybinds = JSON.parse(data)
                } catch (e) {
                    console.error("[HyprlandKeybinds] Error parsing keybinds:", e)
                }
            }
        }
    }
}
