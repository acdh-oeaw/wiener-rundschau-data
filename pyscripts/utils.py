import lxml.etree as ET
import pandas as pd
from acdh_xml_pyutils.xml import NSMAP

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


def format_citation(bibl_elem):
    """Format a citation string from a bibl element."""
    parts = []

    author = bibl_elem.xpath("./tei:author", namespaces=NSMAP)
    if author and author[0].get("ref") != "#nan":
        author_text = author[0].text.strip() if author[0].text else ""
        if author_text:
            parts.append(author_text)

    title_a = bibl_elem.xpath("./tei:title[@level='a']", namespaces=NSMAP)
    if title_a and title_a[0].text:
        parts.append(title_a[0].text.strip())

    title_j = bibl_elem.xpath("./tei:title[@level='j']", namespaces=NSMAP)
    if title_j and title_j[0].text:
        journal_part = "in: " + title_j[0].text.strip()
    else:
        journal_part = ""

    date = bibl_elem.xpath("./tei:date[@when-iso]/@when-iso", namespaces=NSMAP)
    date_str = date[0] if date else ""

    page_scope = bibl_elem.xpath("./tei:biblScope[@unit='page']", namespaces=NSMAP)
    page_str = ""
    if page_scope:
        page_from = page_scope[0].get("from")
        page_to = page_scope[0].get("to")
        if page_from and page_to:
            page_str = f"S. {page_from}–{page_to}"
        elif page_from:
            page_str = f"S. {page_from}"

    citation = ", ".join(parts)
    if journal_part:
        citation += ", " + journal_part

    if date_str or page_str:
        date_page_parts = []
        if date_str:
            date_page_parts.append(f"({date_str})")
        if page_str:
            date_page_parts.append(page_str)
        citation += ", " + ", ".join(date_page_parts)

    citation += "."

    return citation
