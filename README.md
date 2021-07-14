# Cytolk
A cython wrapper over the tolk library.
## Installation
You can install cytolk with

```
pip install cytolk
```

## Building from source
make sure to clone this repository recursively, as this repository depends on the original tolk repo

```
git clone --recursive https://github.com/pauliyobo/cytolk
```

once that's done, to build use the following command

```
python setup.py bdist_wheel
```

You will then find the wheel generated in your dist folder. To install it, simply do the following

```
pip install cytolk-<version number>-<python dist>.whl
```

Where version number is the version you're installing, such as 0.1.6, and python dist is the python distribution you're using such as cp39-cp39-win_amd64.
Note: this will build the extension using the generated c code present in the repository.
By doing so you are not required to have cython installed  in your machine.
If you would like to build directly from the .pyx file, you will have to install the requirements which as of now are only cython and setuptools

```
pip install -r requirements.txt
```

And set the environment variable BUILD_CYTOLK

```
set BUILD_CYTOLK=1
```

## Usage
As of 0.1.7 it is now possible to use a context manager to utilize tolk's functionality. Using tolk.load() and tolk.unload() is still possible, but not preferred.

```python
# This  example makes use of tolk's context manager
# The old example can be found in the examples directory in the file named tolk_example.py
# They are exactly the same, only difference being that the old one does not use the context manager

from cytolk import tolk

# No need to load or unload anything, let the manager handle it for us
with tolk.tolk():
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

```

### Note
The library will not work if it can not interface to your current screen reader.
Therefore, you must place the appropriate DLL that interfaces to your screen reader in your working directory. Cytolk comes  already packed with the NVDA DLLS, and to place them in your working directory you can simply run the command

## Placing required DLLS
Note: as of cytolk 0.1.6 placing the DLLS is no longer required, as the library automatically modifies the search path to detect the DLLS that are packaged with the extension it's self
Cytolk needs to find the required DLLS so that the wrapped c library can interface to your current screen reader. For this to work, the libraries ned to be placed in the directory where your program is running.
Finding those libraries can be annoying some times, and so, the wheel you install already comes packaged with the libraries you will need based on your architecture. This means that if you are using a 32 bit version of python, the libraries you will find in the wheel you install will be only 32 bit.
But how do we go about doing this? Easy.
Cytolk provides also a command line interface, which allows you to just do that.
What you are looking for is this:

```
python -m cytolk --place_dll
```

This command will just place the required libraries you will need in your current directory, avoiding you to have to copy them manually. Suggestion to make this process easier are welcome.
## Functions
Note: some, if not all of the documentation, has been added following the already present documentation on the original tolk documentation, adapting it to the name of the functions present on this extension. 
Should you be interested on more detailed documentation,  you will be able to find so in the original tolk repository.
Second note: in version 0.1.7, calling functions will raise an exception if cytolk hasn't been loaded. only exceptions are
* tolk.load()
* tolk.is_loaded()
* tolk.unload()
### tolk.load()
Initializes the  tolk library and sets the current screenreader driver, assuming that it's present in the list of supported  screenreaders. All the functions to interact with the screenreader driver  must be used after tolk is initialized. to verify whether tolk is initialized, call tolk.is_loaded()
### tolk.is_loaded() -> bool
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