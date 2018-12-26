import pathlib, urllib.parse, socket
from computeGitHash import computeGitHashUtf8

class Catalog(object):
    def __init__(self, catalogPath):
        if isinstance(catalogPath, str):
            catalogPath = pathlib.Path(catalogPath)
        if not catalogPath.is_absolute():
            catalogPath = catalogPath.absolute()
        self.catalogPath = catalogPath
        fileurl = self.catalogPath.as_uri()
        hostname = socket.gethostname()
        parsedFileUrl = urllib.parse.urlparse(fileurl)
        parseResult = urllib.parse.ParseResult(scheme=parsedFileUrl.scheme, netloc=hostname, path=parsedFileUrl.path, params=parsedFileUrl.params, query=parsedFileUrl.query, fragment=parsedFileUrl.fragment)
        self.catalogUrl = parseResult.geturl()
        hash = computeGitHashUtf8(self.catalogUrl)
        self.fileStem = "." + hash
