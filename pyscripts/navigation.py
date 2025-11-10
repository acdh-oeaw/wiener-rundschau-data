import glob
import os
from collections import defaultdict

import lxml.etree as ET
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

files = sorted(glob.glob("./data/editions/*/WR*.xml"))

volumes = defaultdict(list)
halbbands = defaultdict(list)
issues = defaultdict(list)

for f in files:
    f_name = os.path.basename(f)
    parts = f_name.replace(".xml", "").split("-")

    if len(parts) == 4:
        volume = parts[1]
        halbband = parts[2]
        issue = parts[3].split("_")[0]

        vol_key = volume
        hb_key = f"{volume}-{halbband}"
        issue_key = f"{volume}-{halbband}-{issue}"

    elif len(parts) == 3:
        volume = parts[1]
        halbband = None
        issue = parts[2].split("_")[0]

        vol_key = volume
        hb_key = None
        issue_key = f"{volume}-{issue}"
    else:
        continue

    volumes[vol_key].append(f)
    if hb_key:
        halbbands[hb_key].append(f)
    issues[issue_key].append(f)

navigation_lookup = {}

for f in files:
    f_name = os.path.basename(f)
    parts = f_name.replace(".xml", "").split("-")

    nav_info = {
        "prev_volume": None,
        "next_volume": None,
        "prev_halbband": None,
        "next_halbband": None,
        "prev_issue": None,
        "next_issue": None,
        "volume": None,
        "halbband": None,
        "issue": None,
    }

    if len(parts) == 4:
        volume = parts[1]
        halbband = parts[2]
        issue = parts[3].split("_")[0]

        nav_info["volume"] = volume
        nav_info["halbband"] = halbband
        nav_info["issue"] = issue

        vol_key = volume
        hb_key = f"{volume}-{halbband}"
        issue_key = f"{volume}-{halbband}-{issue}"

    elif len(parts) == 3:
        volume = parts[1]
        halbband = None
        issue = parts[2].split("_")[0]

        nav_info["volume"] = volume
        nav_info["issue"] = issue

        vol_key = volume
        hb_key = None
        issue_key = f"{volume}-{issue}"
    else:
        navigation_lookup[f_name] = nav_info
        continue

    vol_keys = sorted(volumes.keys())
    vol_idx = vol_keys.index(vol_key)
    if vol_idx > 0:
        prev_vol_key = vol_keys[vol_idx - 1]
        nav_info["prev_volume"] = (
            prev_vol_key,
            os.path.basename(volumes[prev_vol_key][0]),
        )
    if vol_idx < len(vol_keys) - 1:
        next_vol_key = vol_keys[vol_idx + 1]
        nav_info["next_volume"] = (
            next_vol_key,
            os.path.basename(volumes[next_vol_key][0]),
        )

    if hb_key:
        hb_keys = sorted(halbbands.keys())
        hb_idx = hb_keys.index(hb_key)
        if hb_idx > 0:
            prev_hb_key = hb_keys[hb_idx - 1]
            nav_info["prev_halbband"] = (
                prev_hb_key,
                os.path.basename(halbbands[prev_hb_key][0]),
            )
        if hb_idx < len(hb_keys) - 1:
            next_hb_key = hb_keys[hb_idx + 1]
            nav_info["next_halbband"] = (
                next_hb_key,
                os.path.basename(halbbands[next_hb_key][0]),
            )

    issue_keys = sorted(issues.keys())
    issue_idx = issue_keys.index(issue_key)
    if issue_idx > 0:
        prev_issue_key = issue_keys[issue_idx - 1]
        nav_info["prev_issue"] = (
            prev_issue_key,
            os.path.basename(issues[prev_issue_key][0]),
        )
    if issue_idx < len(issue_keys) - 1:
        next_issue_key = issue_keys[issue_idx + 1]
        nav_info["next_issue"] = (
            next_issue_key,
            os.path.basename(issues[next_issue_key][0]),
        )

    navigation_lookup[f_name] = nav_info


def format_title(key_parts, nav_type):
    parts = key_parts.split("-")
    if nav_type in ["prev_volume", "next_volume"]:
        volume = int(parts[0])
        return f"Bd. {volume}"
    elif nav_type in ["prev_halbband", "next_halbband"]:
        volume = int(parts[0])
        halbband = int(parts[1])
        return f"Bd. {volume}, Halbbd. {halbband}"
    elif nav_type in ["prev_issue", "next_issue"]:
        if len(parts) == 3:
            volume = int(parts[0])
            halbband = int(parts[1])
            issue = int(parts[2])
            return f"Bd. {volume}, Halbbd. {halbband}, Nr. {issue}"
        elif len(parts) == 2:
            volume = int(parts[0])
            issue = int(parts[1])
            return f"Bd. {volume}, Nr. {issue}"
    return ""


print("Updating XML files with navigation information...")
for f in tqdm(files):
    f_name = os.path.basename(f)
    nav = navigation_lookup.get(f_name)

    if not nav:
        continue

    try:
        doc = TeiReader(f)
        listbibl = doc.any_xpath(".//tei:sourceDesc/tei:listBibl")

        if not listbibl:
            continue

        parent = listbibl[0]

        nav_attrs = (
            '[@n="previous issue" or @n="next issue" or '
            '@n="previous volume" or @n="next volume" or '
            '@n="previous halbband" or @n="next halbband"]'
        )
        existing_nav = doc.any_xpath(f".//tei:bibl{nav_attrs}")
        for elem in existing_nav:
            parent.remove(elem)

        nav_types = [
            ("prev_volume", "previous volume"),
            ("next_volume", "next volume"),
            ("prev_halbband", "previous halbband"),
            ("next_halbband", "next halbband"),
            ("prev_issue", "previous issue"),
            ("next_issue", "next issue"),
        ]

        for nav_key, nav_label in nav_types:
            if nav[nav_key]:
                key_parts, filename = nav[nav_key]
                title_text = format_title(key_parts, nav_key)

                bibl = ET.Element("{http://www.tei-c.org/ns/1.0}bibl")
                bibl.attrib["n"] = nav_label

                title = ET.SubElement(bibl, "{http://www.tei-c.org/ns/1.0}title")
                title.text = title_text

                idno = ET.SubElement(bibl, "{http://www.tei-c.org/ns/1.0}idno")
                idno.text = filename

                parent.append(bibl)

        ET.indent(doc.any_xpath(".")[0], space="   ")
        doc.tree_to_file(f)

    except Exception as e:
        print(f"Error processing {f}: {e}")

print(f"Updated {len(files)} files.")
