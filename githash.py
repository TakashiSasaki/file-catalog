import sys, os, pathlib, json, hashlib

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

def computeGitHash(path):
    path = pathlib.Path(path)
    if not path.is_file:
        raise "Given path is not a file."
    sha1 = hashlib.sha1()
    sha1.update(b'blob ')
    sha1.update(str(path.stat().st_size).encode("ascii"))
    sha1.update(b'\0')
    with open(path, "rb") as file:
        for chunk in iter(lambda: file.read(4096 * sha1.block_size), b''):
            sha1.update(chunk)
    return sha1.hexdigest()

if __name__ == "__main__":
    pathList = PathList("..")
