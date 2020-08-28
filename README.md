# cytolk
A cython wrapper over the tolk library.
## Installation
You can install cytolk with

```
pip install cytolk
```
## building
make sure to clone this repository recursively, as this repository depends on the original tolk repo

```
git clone --recursive https://github.com/pauliyobo/cytolk
```

once that's done, to build use the following command

```
python setup.py build_ext --inplace
```

Note: this will build the extension using the generated c code present in the repository.
By doing so you are not required to have cython installed  in your machine.
If you would like to build directly from the .pyx file, you will have to install cython

```
pip install cython
```

and set the environment variable BUILD_CYTOLK

```
set BUILD_CYTOLK=1
```

## Usage
The API is fully compatible with the python tolk bindings, therefore, transitioning should be straight forward

```python
import cytolk as Tolk

# load the library
Tolk.load()

# detect the screenreader in use, in my case NVDA
print(f"screenreader detected is {Tolk.detect_screen_reader()}")

# does this screenreader suport  speech and braille?
if Tolk.has_speech():
    print("this screenreader supports speech")
if Tolk.has_braille():
    print("this screenreader supports braille")

# let's speak some text
Tolk.speak("hello")

# good, let's now output some text on the braille display, if any in use
Tolk.braille("hello")

# now that we're done with the library, we can ust unload it
Tolk.unload()
```
