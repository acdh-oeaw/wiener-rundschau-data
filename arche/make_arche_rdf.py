import glob
import os
import shutil

from rdflib import RDF, Graph, Literal, Namespace, URIRef
from tqdm import tqdm

to_ingest = "to_ingest"
shutil.rmtree(to_ingest, ignore_errors=True)
os.makedirs(to_ingest, exist_ok=True)
g = Graph().parse("arche/arche_constants.ttl")
g_repo_objects = Graph().parse("arche/repo_objects_constants.ttl")
TOP_COL_URI = URIRef("https://id.acdh.oeaw.ac.at/wiener-rundschau")

ACDH = Namespace("https://vocabs.acdh.oeaw.ac.at/schema#")
COLS = [ACDH["TopCollection"], ACDH["Collection"], ACDH["Resource"]]
COL_URIS = set()

for x in COLS:
    for s in g.subjects(None, x):
        COL_URIS.add(s)

for x in COL_URIS:
    for p, o in g_repo_objects.predicate_objects():
        g.add((x, p, o))


files_to_ingest = glob.glob("./images/*/*.tif")[50:55]

for x in tqdm(files_to_ingest):
    f_name = os.path.basename(x)
    subj = URIRef(f"{TOP_COL_URI}/{f_name}")
    for p, o in g_repo_objects.predicate_objects():
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
print("writing graph to file")
g.serialize("to_ingest/arche.ttl")

print(f"copying {len(files_to_ingest)} into {to_ingest}")
for x in files_to_ingest:
    _, tail = os.path.split(x)
    new_name = os.path.join(to_ingest, tail)
    shutil.copy(x, new_name)
