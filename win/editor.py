import ctypes
import os
import sys
from subprocess import run
from typing import List, Optional
from urllib.parse import parse_qs, urlparse


def alert(text):
    if os.name == "nt":
        ctypes.windll.user32.MessageBoxW(0, str(text), "hi", 0)
    else:
        print(text)


# url is editor://open/?repo=%r&file=%f&line=%l
# `repo` may be replaced with `root` (Drive letter)
# or with `remote` (SSH name, for vscode)
# %f ==unix filename

#  TODO vscode supports dirs.


class EditorCommandBuilder:
    exe: str
    file: Optional[str]
    line: Optional[int]
    flags: List[str]
    isVscode: bool

    def __init__(
        self, exe="C:/Users/Aviv/AppData/Local/Programs/Microsoft VS Code/code.exe"
    ) -> None:
        self.exe = exe
        self.file = None
        self.line = None
        self.flags = list()

        self.isVscode = True

    def build(self) -> List[str]:
        cmd = [
            self.exe,
            *self.flags,
        ]

        file = self.file
        if not file:
            raise

        if self.line:
            if self.isVscode:
                cmd.append("--goto")
                cmd.append(str(self.line))
            else:
                file = f"{file}:{self.line}"

        if self.isVscode:
            cmd.append("--file-uri")
        cmd.append(file)

        return cmd


repo = None
root = None
files = None
line = None

input = sys.argv[1]
parsed = urlparse(input)

assert parsed.scheme == "editor"
assert parsed.netloc == "open"
query = parsed.query

# matches = re.match('^editor:\/\/open\/\?(.*)$/', input)

query = parse_qs(query)

for arg, values in query.items():
    value = values[0]

    if arg == "repo":
        repo = value

    elif arg == "root":
        root = value + ":"

    elif arg == "file":
        files = value

    elif arg == "line":
        line = value

    elif arg == "remote":
        root = "vscode-remote://ssh-remote+" + value


base = ""


if repo:
    # TODO this is long dead
    base = "v:/by-repo/" + repo + "/"
elif root:
    base = root


if not files or not base:
    alert("bad URL: " + input)
    sys.exit(2)

files = files.split(" ")
for file in files:
    file = file.replace("\\+", " ")
    file = base + file

    builder = EditorCommandBuilder()
    # builder.flags.append("--verbose")
    builder.file = file
    if line:
        builder.line = int(line)

    # alert(builder.build())

    result = run(builder.build(), text=True, capture_output=True)
    if result.returncode:
        result = [
            f"exit: {result.returncode}",
            f"stdout: {result.stdout}",
            f"stderr: {result.stderr}",
        ]
        result = "\n".join(result)
        alert(result)
