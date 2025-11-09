import lxml.etree as ET
import pandas as pd

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


def create_bibl_node(row):
    bibl_node = ET.Element("{http://www.tei-c.org/ns/1.0}bibl")
    bibl_node.attrib["{http://www.w3.org/XML/1998/namespace}id"] = row["text_id"]

    title_node_a = ET.SubElement(
        bibl_node, "{http://www.tei-c.org/ns/1.0}title", level="a"
    )
    title_node_a.text = row["title"]

    title_node_j = ET.SubElement(
        bibl_node, "{http://www.tei-c.org/ns/1.0}title", level="j"
    )
    title_parts = ["Wiener Rundschau"]
    if row.get("volume"):
        title_parts.append(f"Bd. {int(row['volume'])}")
    if row.get("halbband") and pd.notna(row["halbband"]):
        title_parts.append(f"Halbbd. {int(row['halbband'])}")
    if row.get("issue"):
        title_parts.append(f"Nr. {int(row['issue'])}")
    title_node_j.text = ", ".join(title_parts)

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

    return bibl_node
