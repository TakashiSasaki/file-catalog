from unittest import TestCase
from Catalog import Catalog

class Catalog_test(TestCase):
    def test(self):
        catalog = Catalog(".")
        print(catalog.catalogPath)
        print(catalog.fileStem)
        print(catalog.catalogUrl)
