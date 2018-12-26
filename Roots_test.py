from Roots import Roots
import unittest
class RootsTestCase(unittest.TestCase):
    def test(self):
        roots = Roots()
        roots.add("file:///xyz")
