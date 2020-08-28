import glob
import os
import platform

from setuptools import setup, Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext
 
def get_nvda_dll():
    if "32" in platform.architecture()[0]:
        return "nvdaControllerClient32.dll"
    return "nvdaControllerClient64.dll"

# the source variable will have an extension appended to it dynamically
# that way, we can just decide to build using the generated c code or using the .pyx file with ease
source = "cytolk"

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
    "cytolk", 
    sources, 
    define_macros=macros, 
    language="C++", 
    libraries = "User32 Ole32 OleAut32".split(" "),
)]

setup(
    name = "cytolk",
    cmdclass  = {"build_ext": build_ext},
    version = "0.1.2",
    ext_modules = cythonize(extensions),
)