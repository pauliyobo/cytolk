from pathlib import Path
import shutil

def get_libraries():
    src: Path = Path(__file__).parent
    return src.glob("*.dll")

def copy_dlls(dest: Path, verbose: bool=False):
    for lib in get_libraries():
        shutil.copy(str(lib), str(dest))
        if verbose:
            print(f"copied {lib.name}")


