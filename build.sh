echo "converting legacy data into TEIs"
ant
echo "########"

echo "create listbibl.xml"
uv run pyscripts/titles.py
echo "########"

echo "add dates to bibls"
uv run uv run pyscripts/add_dates_to_bibls.pys
echo "########"

echo "create listperson.xml"
uv run pyscripts/create_listperson.py
echo "########"

echo "adding next/prev issue/halbband/band"
uv run pyscripts/navigation.py
echo "########"
