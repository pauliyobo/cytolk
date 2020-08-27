import glob
from setuptools import setup, Extension
from Cython.Distutils import build_ext
 
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
	name = 'cytolk',
	cmdclass = {'build_ext': build_ext},
	ext_modules = extensions
)