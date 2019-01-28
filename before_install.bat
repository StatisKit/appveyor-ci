echo ON

git -C .. describe --tags
python before_install.py

echo OFF