import pathlib, time
from computeGitHash import computeGitHashUtf8

class Roots(dict):
    def __init__(self):
        self.now = time.time()

    def add(self, rootPath: pathlib.Path):
        if isinstance(rootPath, str):
            rootPath = pathlib.Path(rootPath)
        rootPathUrl = rootPath.as_uri()
        rootPathHash = computeGitHashUtf8(rootPathUrl)
        if self.get(rootPathHash) is None:
            self[rootPathHash] = {}
        self[rootPath] = [self.now, rootPathHash]

