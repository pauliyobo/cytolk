@echo off
py setup.py bdist_wheel
set BUILD_CYTOLK=1
cd dist
pip install --force-reinstall cytolk-0.1.5-cp39-cp39-win_amd64.whl
cd ..
pause