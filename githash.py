import sys, os, pathlib, json, hashlib
from computeGitHash import computeGitHash

class HashPath(type(pathlib.Path())):
    def __init__(self, p):
        pathlib.PurePath(self, p)
        self.gitHash = computeGitHash(p)
        self.size = self.stat().st_size
        self.mtime = self.stat().st_mtime
    

class PathList(object):
    def __init__(self, rootDir = "."):
        self.absRootDir = pathlib.Path(rootDir).resolve()
        self.gitDirList = []
        self.gitFileList = []
        self.nonGitDirList = []
        self.nonGitFileList = []

        count = 0
        for root, dirs, files in os.walk(self.absRootDir):
            for file in files:
                if files == ".git":
                    path = pathlib.Path(root) / pathlib.Path(file)
                    self.gitFileList.append(path)
                    count +=1
                    print(count, path)
                else:
                    hashPath = HashPath(pathlib.Path(root) / pathlib.Path(file))
                    self.nonGitFileList.append(hashPath)
                    count +=1
                    print(count, hashPath)
            for dir in dirs:
                if dir == ".git":
                    path = pathlib.Path(root) / pathlib.Path(dir)
                    self.gitDirList.append(path)
                    count += 1
                    print(count, path)
                else:
                    path = pathlib.Path(root) / pathlib.Path(dir)
                    self.nonGitDirList.append(path)
                    count += 1
                    print(count, path)

if __name__ == "__main__":
    pathList = PathList("..")
