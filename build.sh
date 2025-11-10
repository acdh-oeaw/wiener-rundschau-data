echo "converting legacy data into TEIs"
ant
echo "########"
echo "create listbibl.xml"
uv run pyscripts/titles.py
echo "########"
echo "adding next/prev issue/halbband/band"
uv run pyscripts/navigation.py
echo "########"
