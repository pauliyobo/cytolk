import argparse
import os
import pathlib
import site
import shutil

def get_dll_path():
    p = pathlib.Path(site.getsitepackages()[1])/"cytolk"
    return [str(x) for x in p.glob("*.dll")]

def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--place_dll", action="store_true", help="copies  the dlls required for the library to interface with the screenreader in the directory specified")
    args = parser.parse_args()
    if args.place_dll:
        dest = pathlib.Path(os.getcwd())
        if dest.exists() and dest.is_dir():
            shutil.copy(get_dll_path()[0], str(dest))

if __name__ == '__main__':
    cli()