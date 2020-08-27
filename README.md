# cytolk
A cython wrapper over the tolk library.
## building
To successfully build, you will need to install cython

```
pip install cython
```

Also, make sure to clone this repository recursively, as this repository depends on the original tolk repo

```
git clone --recursive https://github.com/pauliyobo/cytolk
```

once that's done, to build use the following command

```
python setup.py build_ext --inplace
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
    print("this library supports braille")

# let's speak some text
Tolk.speak("hello")

# good, let's now output some text on the braille display, if any in use
Tolk.braille("hello")

# now that we're done with the library, we can ust unload it
Tolk.unload()
```

## Known issues
For some reason, when calling the function detect_screen_reader(), if no library is present the library will just crash. I wasn't able to find a solution to this yet.
If you find any other issue, or would like to send a PR, feel free to do so