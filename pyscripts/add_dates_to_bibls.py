import glob
import os

import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from acdh_xml_pyutils.xml import NSMAP
from tqdm import tqdm
from utils import format_citation

files = glob.glob("data/editions/*/*.xml")

lookup = {}
for x in files:
    lookup[os.path.basename(x)] = x


listbibl_file = os.path.join("data", "indices", "listbibl.xml")
listbibl_doc = TeiReader(listbibl_file)
for to_delete in listbibl_doc.any_xpath(".//tei:bibl/tei:date"):
    parent = to_delete.getparent()
    parent.remove(to_delete)
for x in tqdm(listbibl_doc.any_xpath(".//tei:bibl[@xml:id]")):
    f_name = x.xpath("./tei:idno", namespaces=NSMAP)[0].text
    tei_file = lookup[f_name]
    doc = TeiReader(tei_file)
    date = doc.any_xpath(".//tei:date[@when-iso]/@when-iso")[0]
    bibl_date_node = ET.SubElement(x, "{http://www.tei-c.org/ns/1.0}date")
    bibl_date_node.attrib["when-iso"] = date
    bibl_date_node.text = date
    citation = format_citation(x)
    x.attrib["n"] = citation

ET.indent(doc.any_xpath(".")[0], space="   ")
listbibl_doc.tree_to_file(listbibl_file)
