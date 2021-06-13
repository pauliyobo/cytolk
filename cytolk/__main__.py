import argparse
import glob
import os
from pathlib import Path

from .util import copy_dlls

def cli():
    parser: argparse.ArgumentParser = argparse.ArgumentParser()
    parser.add_argument("-p", "--place_dll", action="store_true", help="copies  the dlls required for the library to interface with the screenreader in the directory specified")
    parser.add_argument("-v", "--verbose", action="store_true", help="gives more information about where the DLLS are being copied from")
    args: argparse.Namespace = parser.parse_args()
    if args.place_dll:
        dest: Path = Path(os.getcwd())
        if dest.exists() and dest.is_dir():
            if args.verbose:
                print(f"copying required DLLS from: {str(src)}")
            copy_dlls(dest, args.verbose)
            if args.verbose:
                print(f"done. All required DLLS have been copied to your current directory: {str(dest)}")
            

if __name__ == '__main__':
    cli()