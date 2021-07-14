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
