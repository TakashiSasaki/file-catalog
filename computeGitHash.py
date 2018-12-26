import pathlib, hashlib

def computeGitHash(path: pathlib.Path) -> str:
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

def computeGitHashUtf8(s: str) -> str:
    utf8 = s.encode("utf8")
    sha1 = hashlib.sha1()
    sha1.update(b'blob')
    sha1.update(str(len(utf8)).encode("ascii"))
    sha1.update(b'\0')
    sha1.update(utf8)
    return sha1.hexdigest()
