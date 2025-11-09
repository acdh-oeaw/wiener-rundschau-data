import glob
import os
import shutil

import lxml.etree as ET
import pandas as pd
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm
from utils import create_bibl_node, tei_dummy

files = sorted(glob.glob("legacy-data/WR*/*_cis_*.xml"))
indices_dir = os.path.join("data", "indices")
listbibl_path = os.path.join(indices_dir, "listbibl.xml")

shutil.rmtree(indices_dir, ignore_errors=True)
os.makedirs(indices_dir, exist_ok=True)

print("creating listbibl.xml")
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


doc = TeiReader(tei_dummy)
title = doc.any_xpath(".//tei:title[@level='a']")[0]
title.text = "Textverzeichnis"
body = doc.any_xpath(".//tei:body")[0]
root_list = ET.SubElement(body, "{http://www.tei-c.org/ns/1.0}listBibl")
for i, row in df.iterrows():
    bibl_node = create_bibl_node(row)
    root_list.append(bibl_node)

ET.indent(doc.any_xpath(".")[0], space="   ")
doc.tree_to_file(listbibl_path)

print("Updating edition XML files...")
listbibl_doc = TeiReader(listbibl_path)
edition_files = sorted(glob.glob("data/editions/*/*.xml"))

for edition_file in tqdm(edition_files, total=len(edition_files)):
    filename = os.path.basename(edition_file)
    page_id = filename.replace(".xml", "")

    matching_text_ids = []
    for i, row in df.iterrows():
        start_page = row.get("start_page", "").replace(".xml", "")
        end_page = row.get("end_page", "").replace(".xml", "")

        if start_page:
            if end_page and start_page <= page_id <= end_page:
                matching_text_ids.append(row["text_id"])
            elif not end_page and start_page == page_id:
                matching_text_ids.append(row["text_id"])

    if matching_text_ids:
        try:
            edition_doc = TeiReader(edition_file)
            bibl_elements = edition_doc.any_xpath('.//tei:bibl[@n="current text"]')
            if bibl_elements:
                parent = bibl_elements[0].getparent()
                for old_bibl in bibl_elements:
                    parent.remove(old_bibl)

                for text_id in matching_text_ids:
                    text_idx = df[df["text_id"] == text_id].index[0]

                    if text_idx > 0:
                        prev_text_id = df.iloc[text_idx - 1]["text_id"]
                        prev_bibl = listbibl_doc.any_xpath(
                            f'.//tei:bibl[@xml:id="{prev_text_id}"]'
                        )[0]
                        prev_copy = ET.fromstring(ET.tostring(prev_bibl))
                        prev_copy.attrib["n"] = "previous text"
                        prev_copy.attrib["corresp"] = f"#{prev_text_id}"
                        prev_copy.attrib.pop(
                            "{http://www.w3.org/XML/1998/namespace}id", None
                        )
                        parent.append(prev_copy)

                    source_bibl = listbibl_doc.any_xpath(
                        f'.//tei:bibl[@xml:id="{text_id}"]'
                    )[0]
                    bibl_copy = ET.fromstring(ET.tostring(source_bibl))
                    bibl_copy.attrib["n"] = "current text"
                    bibl_copy.attrib["corresp"] = f"#{text_id}"
                    bibl_copy.attrib.pop(
                        "{http://www.w3.org/XML/1998/namespace}id", None
                    )
                    parent.append(bibl_copy)

                    if text_idx < len(df) - 1:
                        next_text_id = df.iloc[text_idx + 1]["text_id"]
                        next_bibl = listbibl_doc.any_xpath(
                            f'.//tei:bibl[@xml:id="{next_text_id}"]'
                        )[0]
                        next_copy = ET.fromstring(ET.tostring(next_bibl))
                        next_copy.attrib["n"] = "next text"
                        next_copy.attrib["corresp"] = f"#{next_text_id}"
                        next_copy.attrib.pop(
                            "{http://www.w3.org/XML/1998/namespace}id", None
                        )
                        parent.append(next_copy)

                ET.indent(edition_doc.any_xpath(".")[0], space="   ")
                edition_doc.tree_to_file(edition_file)

        except Exception as e:
            print(f"Error processing {edition_file}: {e}")

print(f"Updated {len(edition_files)} edition files.")
