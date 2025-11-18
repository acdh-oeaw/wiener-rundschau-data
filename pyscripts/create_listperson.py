import glob
import os

import lxml.etree as ET
import pandas as pd
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash
from acdh_xml_pyutils.xml import NSMAP
from utils import tei_dummy

df = pd.read_csv("wr-rundschau-authors.csv")
gnd_lookup = {}
sameas_lookup = {}

for gnd_url, group in df.groupby("gnd"):
    if pd.notna(gnd_url) and gnd_url.strip():
        gnd_url_clean = gnd_url.strip()
        person_ids = group["id"].tolist()

        for person_id in person_ids:
            gnd_lookup[person_id] = gnd_url_clean

        if len(person_ids) > 1:
            for person_id in person_ids:
                other_ids = [pid for pid in person_ids if pid != person_id]
                sameas_lookup[person_id] = f"#{'|'.join(other_ids)}"

files = glob.glob("data/editions/*/*.xml")

lookup = {}
for x in files:
    lookup[os.path.basename(x)] = x


listbibl_file = os.path.join("data", "indices", "listbibl.xml")
listbibl_doc = TeiReader(listbibl_file)

listperson_file = os.path.join("data", "indices", "listperson.xml")
doc = TeiReader(tei_dummy)


lookup_dict = {}
for x in listbibl_doc.any_xpath(".//tei:bibl[./tei:author/text()]"):
    author = x.xpath("./tei:author", namespaces=NSMAP)[0]
    author_name = author.text
    author_id = author.attrib["ref"]
    try:
        lookup_dict[author_id]["name"] = author_name
        lookup_dict[author_id]["texts"].append(x)
    except KeyError:
        lookup_dict[author_id] = {"name": author_name, "texts": [x]}


title_node = doc.any_xpath(".//tei:title[@level='a']")[0]
title_node.text = "Personenverzeichnis"

doc.tree.attrib["{http://www.w3.org/XML/1998/namespace}id"] = "listperson.xml"

body = doc.any_xpath(".//tei:body")[0]
body = doc.any_xpath(".//tei:body")[0]
root_list = ET.SubElement(body, "{http://www.tei-c.org/ns/1.0}listPerson")

for key, value in lookup_dict.items():
    person = ET.SubElement(
        root_list, "{http://www.tei-c.org/ns/1.0}person", n=value["name"]
    )
    person_id = check_for_hash(key)
    person.attrib["{http://www.w3.org/XML/1998/namespace}id"] = person_id

    if person_id in sameas_lookup:
        person.attrib["sameAs"] = sameas_lookup[person_id]

    pers_name = ET.SubElement(person, "{http://www.tei-c.org/ns/1.0}persName")
    pers_name.text = value["name"]

    if person_id in gnd_lookup:
        idno = ET.SubElement(person, "{http://www.tei-c.org/ns/1.0}idno")
        idno.attrib["type"] = "gnd"
        idno.text = gnd_lookup[person_id]

    list_bible = ET.SubElement(person, "{http://www.tei-c.org/ns/1.0}listBibl")
    for x in value["texts"]:
        list_bible.append(x)


ET.indent(doc.any_xpath(".")[0], space="   ")
doc.tree_to_file(listperson_file)
