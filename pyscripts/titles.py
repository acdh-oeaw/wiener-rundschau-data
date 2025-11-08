import glob
import os
import shutil

import lxml.etree as ET
import pandas as pd
from acdh_tei_pyutils.tei import TeiReader

files = sorted(glob.glob("legacy-data/WR*/*_cis_*.xml"))
indices_dir = os.path.join("data", "indices")
listbibl_path = os.path.join(indices_dir, "listbibl.xml")

shutil.rmtree(indices_dir, ignore_errors=True)
os.makedirs(indices_dir, exist_ok=True)


data = []
counter = 1
for x in files:
    doc = TeiReader(x)
    for y in doc.any_xpath(".//ci"):
        item = {"author": y.xpath("./author")[0].text}
        item["title"] = y.xpath("./title")[0].text
        try:
            item["start_page"] = y.xpath("./target")[0].text.split("#")[0]
        except AttributeError:
            continue
        try:
            item["end_page"] = y.xpath("./divEndPtr")[0].text.split("#")[0]
        except AttributeError:
            continue
        if item.get("start_page"):
            try:
                item["start_page_number"] = str(
                    int(item["start_page"].split("_n")[1].split(".xml")[0])
                )
            except (IndexError, ValueError):
                pass
            parts = item["start_page"].replace(".xml", "").split("-")
            if len(parts) == 4:
                item["volume"] = parts[1]
                item["halbband"] = parts[2]
                item["issue"] = parts[3].split("_")[0]
            elif len(parts) == 3:
                item["volume"] = parts[1]
                item["halbband"] = None
                item["issue"] = parts[2].split("_")[0]
        if item.get("end_page"):
            try:
                item["end_page_number"] = str(
                    int(item["end_page"].split("_n")[1].split(".xml")[0])
                )
            except (IndexError, ValueError):
                pass
        data.append(item)
        counter += 1
df = pd.DataFrame(data)
df = df.sort_values(by="start_page")
df["text_id"] = [f"wr-text-{i:04d}" for i in range(1, len(df) + 1)]

unique_authors = df["author"].dropna().unique()
authors_df = pd.DataFrame(
    {
        "author": unique_authors,
        "author_id": [f"wr-person-{i:04d}" for i in range(1, len(unique_authors) + 1)],
    }
)
df = df.merge(authors_df, on="author", how="left")
df.to_csv("foo.csv", index=False)


tei_dummy = """
<TEI xmlns="http://www.tei-c.org/ns/1.0"
   xml:id="listbibl.xml">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title level="a"></title>
            <title level="j">Wiener Rundschau</title>
         </titleStmt>
         <publicationStmt>
            <publisher>
               <orgName ref="https://d-nb.info/gnd/1226158307">Austrian Centre for Digital Humanities and Cultural Heritage</orgName>
            </publisher>
            <availability>
               <licence target="https://creativecommons.org/licenses/by/4.0/deed.de"/>
            </availability>
         </publicationStmt>
         <sourceDesc>
            <ab>born digital</ab>
         </sourceDesc>
      </fileDesc>
   </teiHeader>
   <text>
      <body/>
   </text>
</TEI>
"""  # noqa


doc = TeiReader(tei_dummy)
title = doc.any_xpath(".//tei:title[@level='a']")[0]
title.text = "Textverzeichnis"
body = doc.any_xpath(".//tei:body")[0]
root_list = ET.SubElement(body, "{http://www.tei-c.org/ns/1.0}listBibl")
for i, row in df.iterrows():
    bibl_node = ET.SubElement(root_list, "{http://www.tei-c.org/ns/1.0}bibl")
    bibl_node.attrib["{http://www.w3.org/XML/1998/namespace}id"] = row["text_id"]
    title_node_a = ET.SubElement(
        bibl_node, "{http://www.tei-c.org/ns/1.0}title", level="a"
    )
    title_node_a.text = row["title"]
    title_node_j = ET.SubElement(
        bibl_node, "{http://www.tei-c.org/ns/1.0}title", level="j"
    )
    if row.get("volume"):
        volume_scope = ET.SubElement(
            bibl_node, "{http://www.tei-c.org/ns/1.0}biblScope"
        )
        volume_scope.attrib["unit"] = "volume"
        volume_scope.attrib["n"] = row["volume"]
        volume_scope.text = str(int(row["volume"]))
    if row.get("halbband") and pd.notna(row["halbband"]):
        halbband_scope = ET.SubElement(
            bibl_node, "{http://www.tei-c.org/ns/1.0}biblScope"
        )
        halbband_scope.attrib["unit"] = "halbband"
        halbband_scope.attrib["n"] = row["halbband"]
        halbband_scope.text = str(int(row["halbband"]))
    if row.get("issue"):
        issue_scope = ET.SubElement(bibl_node, "{http://www.tei-c.org/ns/1.0}biblScope")
        issue_scope.attrib["unit"] = "issue"
        issue_scope.attrib["n"] = row["issue"]
        issue_scope.text = str(int(row["issue"]))
    if row.get("start_page"):
        bibl_scope = ET.SubElement(bibl_node, "{http://www.tei-c.org/ns/1.0}biblScope")
        bibl_scope.attrib["unit"] = "page"
        bibl_scope.attrib["from"] = row["start_page_number"]
        if row.get("end_page"):
            bibl_scope.attrib["to"] = row["end_page_number"]
        idno = ET.SubElement(bibl_node, "{http://www.tei-c.org/ns/1.0}idno", type="fn")
        idno.text = f"{row['start_page']}"
    author_node = ET.SubElement(bibl_node, "{http://www.tei-c.org/ns/1.0}author")
    author_node.attrib["ref"] = f"#{row['author_id']}"
    author_node.text = row["author"]
    title_parts = ["Wiener Rundschau"]
    if row.get("volume"):
        title_parts.append(f"Bd. {int(row['volume'])}")
    if row.get("halbband") and pd.notna(row["halbband"]):
        title_parts.append(f"Halbbd. {int(row['halbband'])}")
    if row.get("issue"):
        title_parts.append(f"Nr. {int(row['issue'])}")
    title_node_j.text = ", ".join(title_parts)

# Pretty print the XML with proper indentation
ET.indent(doc.any_xpath(".")[0], space="   ")
doc.tree_to_file(listbibl_path)
