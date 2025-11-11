import glob
import os
import shutil

from rdflib import RDF, Graph, Literal, Namespace, URIRef
from tqdm import tqdm

to_ingest = "to_ingest"
shutil.rmtree(to_ingest, ignore_errors=True)
os.makedirs(to_ingest, exist_ok=True)
g = Graph().parse("arche/arche_constants.ttl")
facs_constants = Graph().parse("arche/facs_constants.ttl")
xml_constants = Graph().parse("arche/xml_constants.ttl")
TOP_COL_URI = URIRef("https://id.acdh.oeaw.ac.at/wiener-rundschau")

ACDH = Namespace("https://vocabs.acdh.oeaw.ac.at/schema#")


print("processing images")

files_to_ingest = glob.glob("./images/*/*.tif")

for x in tqdm(files_to_ingest):
    f_name = os.path.basename(x)
    subj = URIRef(f"{TOP_COL_URI}/{f_name}")
    for p, o in facs_constants.predicate_objects():
        g.add((subj, p, o))
    g.add((subj, RDF.type, ACDH["Resource"]))
    try:
        page = f"{int(f_name.split('_')[-1].replace('.tif', '').replace('i', '').replace('n', '').replace('a', ''))}"
    except ValueError:
        page = False
    title = (
        f_name.split("_")[0].replace("WR-", "Wiener Rundschau, ").replace("-", " / ")
    )
    if page:
        title = f"{title}, Seite {page}"
    g.add((subj, ACDH["hasTitle"], Literal(title, lang="de")))
    g.add(
        (
            subj,
            ACDH["hasCategory"],
            URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/image"),
        )
    )
    g.add(
        (
            subj,
            ACDH["isPartOf"],
            URIRef("https://id.acdh.oeaw.ac.at/wiener-rundschau/facsimiles"),
        )
    )

print(f"copying {len(files_to_ingest)} into {to_ingest}")
for x in files_to_ingest:
    _, tail = os.path.split(x)
    new_name = os.path.join(to_ingest, tail)
    shutil.copy(x, new_name)


print("processing XMLs")

files_to_ingest = glob.glob("./legacy-data/WR-*/WR-*.xml")
files_to_ingest = files_to_ingest + glob.glob("./legacy-data/WR-*/_cis_WR-*.xml")

for x in tqdm(files_to_ingest):
    f_name = os.path.basename(x)
    subj = URIRef(f"{TOP_COL_URI}/{f_name}")
    for p, o in xml_constants.predicate_objects():
        g.add((subj, p, o))
    g.add((subj, RDF.type, ACDH["Resource"]))
    try:
        page = f"{int(f_name.split('_')[-1].replace('.tif', '').replace('i', '').replace('n', '').replace('a', ''))}"
    except ValueError:
        page = False
    g.add((subj, ACDH["hasTitle"], Literal(f_name, lang="de")))
    g.add(
        (
            subj,
            ACDH["hasCategory"],
            URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text"),
        )
    )
    g.add(
        (
            subj,
            ACDH["isPartOf"],
            URIRef("https://id.acdh.oeaw.ac.at/wiener-rundschau/aac-xml"),
        )
    )
print("writing graph to file")
g.serialize("to_ingest/arche.ttl")

print(f"copying {len(files_to_ingest)} into {to_ingest}")
for x in files_to_ingest:
    _, tail = os.path.split(x)
    new_name = os.path.join(to_ingest, tail)
    shutil.copy(x, new_name)
