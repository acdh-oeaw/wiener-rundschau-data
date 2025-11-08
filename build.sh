echo "converting legacy data into TEIs"
ant
echo "create listbibl.xml"
uv run pyscripts/titles.py 