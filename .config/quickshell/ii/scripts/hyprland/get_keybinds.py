#!/usr/bin/env python3
import argparse
import re
import os
from typing import Dict, List

TITLE_REGEX = "#+!"
MOD_SEPARATORS = ['+', ' ']
COMMENT_BIND_PATTERN = "#/#"
HYPER_MODS = {"Ctrl", "Shift", "Alt", "Super"}

parser = argparse.ArgumentParser(description='Hyprland keybind reader')
parser.add_argument('--path', type=str, default="$HOME/.config/hypr/hyprland.conf")
args = parser.parse_args()
content_lines = []
reading_line = 0
unbinds_list = []

class KeyBinding(dict):
    def __init__(self, mods, key, dispatcher, params, comment) -> None:
        self["mods"] = mods
        self["key"] = key
        self["dispatcher"] = dispatcher
        self["params"] = params
        self["comment"] = comment

class Section(dict):
    def __init__(self, children, keybinds, name) -> None:
        self["children"] = children
        self["keybinds"] = keybinds
        self["name"] = name

def read_content(path: str) -> str:
    expanded = os.path.expanduser(os.path.expandvars(path))
    if not os.access(expanded, os.R_OK):
        return "error"
    with open(expanded, "r") as file:
        return file.read()

def autogenerate_comment(dispatcher: str, params: str = "") -> str:
    match dispatcher:
        case "resizewindow": return "Resize window"
        case "movewindow":
            if params == "": return "Move window"
            return "Move window {}".format({"l": "left", "r": "right", "u": "up", "d": "down"}.get(params, params))
        case "movefocus":
            return "Focus {}".format({"l": "left", "r": "right", "u": "up", "d": "down"}.get(params, params))
        case "pin": return "Pin window"
        case "togglefloating": return "Float/tile"
        case "killactive": return "Close window"
        case "fullscreen":
            return {"0": "Fullscreen", "1": "Maximize"}.get(params, "Fullscreen")
        case "workspace":
            if params == "+1": return "Next workspace"
            elif params == "-1": return "Prev workspace"
            return f"Workspace {params}"
        case "movetoworkspacesilent":
            return f"Send to workspace {params}"
        case "togglespecialworkspace": return "Toggle scratchpad"
        case _: return ""

def simplify_mods(mods_list):
    """Convert Ctrl+Shift+Alt+Super to Hyper"""
    mods_set = set(mods_list)
    if HYPER_MODS.issubset(mods_set):
        # All 4 hyper mods present - replace with Hyper
        remaining = mods_set - HYPER_MODS
        return ["Hyper"] + list(remaining)
    return mods_list

def get_keybind_at_line(line_number, line_start=0):
    global content_lines
    line = content_lines[line_number][line_start:]
    
    if "=" not in line:
        return None
    _, keys = line.split("=", 1)
    keys, *comment = keys.split("#", 1)

    parts = list(map(str.strip, keys.split(",", 4)))
    if len(parts) < 2:
        return None
    mods = parts[0]
    key = parts[1]
    dispatcher = parts[2] if len(parts) > 2 else ""
    params = parts[3] if len(parts) > 3 else ""

    comment = list(map(str.strip, comment))
    if comment:
        comment = comment[0]
        if comment.startswith("[hidden]"):
            return None
    else:
        comment = autogenerate_comment(dispatcher, params)

    if mods:
        modstring = mods + MOD_SEPARATORS[0]
        mods_list = []
        p = 0
        for index, char in enumerate(modstring):
            if char in MOD_SEPARATORS:
                if index - p > 0:
                    mods_list.append(modstring[p:index])
                p = index + 1
        mods = simplify_mods(mods_list)
    else:
        mods = []

    return KeyBinding(mods, key, dispatcher, params, comment)

def get_binds_recursive(current_content, scope):
    global content_lines, reading_line, unbinds_list
    
    while reading_line < len(content_lines):
        line = content_lines[reading_line]
        heading_search_result = re.search(TITLE_REGEX, line)
        
        if heading_search_result and heading_search_result.start() == 0:
            heading_scope = line.find('!')
            if heading_scope <= scope:
                reading_line -= 1
                return current_content
            section_name = line[(heading_scope+1):].strip()
            reading_line += 1
            current_content["children"].append(get_binds_recursive(Section([], [], section_name), heading_scope))
        elif line.startswith(COMMENT_BIND_PATTERN):
            keybind = get_keybind_at_line(reading_line, line_start=len(COMMENT_BIND_PATTERN))
            if keybind:
                current_content["keybinds"].append(keybind)
        elif line.lstrip().startswith("unbind"):
            try:
                _, keys = line.split("=", 1)
                unbinds_list.append(keys.split("#")[0].strip())
            except:
                pass
        elif line == "" or not line.lstrip().startswith("bind"):
            pass
        else:
            keybind = get_keybind_at_line(reading_line)
            if keybind:
                current_content["keybinds"].append(keybind)
        reading_line += 1
    return current_content

def parse_keys(path: str):
    global content_lines, reading_line, unbinds_list
    unbinds_list = []
    reading_line = 0
    content_lines = read_content(path).splitlines()
    if not content_lines or content_lines[0] == "error":
        return {"children": [], "unbinds": []}
    result = get_binds_recursive(Section([], [], ""), 0)
    result["unbinds"] = unbinds_list
    return result

if __name__ == "__main__":
    import json
    print(json.dumps(parse_keys(args.path)))
