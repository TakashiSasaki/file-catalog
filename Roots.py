import pathlib, time, urllib.parse
from computeGitHash import computeGitHashUtf8

class Roots(dict):
    def __init__(self):
        self.now = time.time()

    def add(self, rootPath: pathlib.Path):
        if isinstance(rootPath, str):
            rootPath = pathlib.Path(rootPath)
        if not rootPath.is_absolute():
            rootPath = rootPath.absolute()
        rootPathUrl = rootPath.as_uri()
        rootPathHash = computeGitHashUtf8(rootPathUrl)
        if self.get(rootPathHash) is None:
            self[rootPathHash] = {}
        self[rootPath] = [self.now, rootPathHash]
