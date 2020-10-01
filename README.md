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
from cytolk import tolk

# load the library
tolk.load()

# detect the screenreader in use, in my case NVDA
print(f"screenreader detected is {tolk.detect_screen_reader()}")

# does this screenreader suport  speech and braille?
if tolk.has_speech():
    print("this screenreader supports speech")
if tolk.has_braille():
    print("this screenreader supports braille")

# let's speak some text
tolk.speak("hello")

# good, let's now output some text on the braille display, if any in use
tolk.braille("hello")

# now that we're done with the library, we can ust unload it
tolk.unload()
```

### Note
The library will not work if it can not interface to your current screen reader.
Therefore, you must place the appropriate DLL that interfaces to your screen reader in your working directory. Cytolk comes  already packed with the NVDA DLLS, and to place them in your working directory you can simply run the command

```
python -m cytolk --place_dll
```

## Functions
Note: some, if not all of the documentation, has been added following the already present documentation on the original tolk documentation, adapting it to the name of the functions present on this extension. 
Should you be interested on more detailed documentation,  you will be able to find so in the original tolk repository.
### tolk.load()
Initializes the  tolk library and sets the current screenreader driver, assuming that it's present in the list of supported  screenreaders. All the functions to interact with the screenreader driver  must be used after tolk is initialized. to verify whether tolk is initialized, call tolk.is_loaded()
### tolk.is_loaded()
Verifies whether tolk has been initialized
### tolk.unload()
deinitializes tolk.
### tolk.try_sapi(try_sapi)
Sets if Microsoft Speech API (SAPI) should be used in the screen reader auto-detection process. The function should be called before tolk is initialized
args:
* try_sapi (bool)
### tolk.prefer_sapi(prefer_sapi)
If auto-detection for SAPI has been turned on through tolk.try_sapi, sets if SAPI should be placed first (true) or last (false) in the screen reader detection list. Putting it last is the default and is good for using SAPI as a fallback option. Putting it first is good for ensuring SAPI is used even when a screen reader is running, but keep in mind screen readers will still be tried if SAPI is unavailable. This function triggers the screen reader detection process if needed. this function can be called before tolk is initialized
args:
* prefer_sapi (bool)
### tolk.detect_screen_reader()
Returns the common name for the currently active screen reader driver, if one is set. If none is set, tries to detect the currently active screen reader before looking up the name. If no screen reader is active, None is returned. tolk.load must be called before using this function.
### tolk.has_speech()
Returns true if the current screen reader driver supports speech output. This function must be called after tolk is initialized.
### tolk.has_braille()
Returns true if the current screen reader  driver supports braille output. This function must be called after tolk is initialized.
### tolk.output(text,  interrupt)
Outputs text through the current screen reader driver. Tolk.output uses both speech and braille if supported. Returns True on success False if otherwise. This function must be called after tolk is initialized.
args:
* text (str) the text to output
* interrupt (bool)  interrupts any previous speech.
### tolk.speak(text, interrupt)
speaks the text through the current screen reader driver. Returns True on success False if otherwise. This function must be called after tolk is initialized.
args:
* text (str) the text to speak
* interrupt (bool)  interrupts any previous speech.
### tolk.braille(text)
Brailles text through the current screen reader driver. Returns True on success False if otherwise. This function must be called after tolk is initialized.
args:
* text (str) text to braille
### tolk.is_speaking()
Returns True if the current  screen reader driver is speaking. This function must be called after tolk is initialized.
### tolk.silence()
Silences the current screen reader driver. Returns True on success False if otherwise. This function must be called after tolk is initialized.