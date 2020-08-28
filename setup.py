import glob
import platform

from setuptools import setup, Extension
from Cython.Distutils import build_ext
 
def get_nvda_dll():
    if "32" in platform.architecture()[0]:
        return "nvdaControllerClient32.dll"
    return "nvdaControllerClient64.dll"

glob_files = glob.glob("tolk/src/*.cpp")
glob_files.extend(glob.glob("tolk/src/*.c"))
sources = ["cytolk.pyx"]+glob_files

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
    version = "0.1.1",
    cmdclass = {"build_ext": build_ext},
    ext_modules = extensions,
)