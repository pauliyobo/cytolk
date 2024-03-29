import glob
import os
from pathlib import Path
import platform
import shutil

from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize
from Cython.Distutils import build_ext
 
# just a function to retrieve the readme data
def get_readme():
    with open("README.md") as f:
        return f.read()


# the source variable will have an extension appended to it dynamically
# that way, we can just decide to build using the generated c code or using the .pyx file with ease
source = "cytolk/tolk"

if "BUILD_CYTOLK" in os.environ:
    source += ".pyx"    
else:
    source += ".c"


glob_files = glob.glob("tolk/src/*.cpp")
glob_files.extend(glob.glob("tolk/src/*.c"))
sources = [source]+glob_files

macros = [
    ('UNICODE', "1"),
    ('_WIN32', None),
    ('_EXPORTING', None),
]

extensions=[Extension(
    "cytolk.tolk", 
    sources, 
    define_macros=macros, 
    language="C++", 
    libraries = "User32 Ole32 OleAut32".split(" "),
)]

print("copying DLLS")
libs = Path("tolk/libs") / ("x86" if "32" in platform.architecture()[0] else "x64")
for lib in libs.glob("*.dll"):
    shutil.copy(str(lib), "cytolk")
    print(f"copied {lib.name}")


setup(
    name = "cytolk",
    cmdclass  = {"build_ext": build_ext},
    version = "0.1.13",
    description = "A cython wrapper over the tolk library",
    long_description_content_type='text/markdown', 
    long_description = get_readme(),
    ext_modules = cythonize(extensions),
    packages = find_packages(),
    package_data = {
        "": ["*.dll"],
    },
    entry_points = {
        "console_scripts":  [
            "cytolk = cytolk.main:cli"
        ]
    }
)

dll_glob = glob.glob("cytolk/*.dll")
print("cleaning dlls")
for dll in dll_glob:
    os.remove(dll)
    print(f"{dll} removed")