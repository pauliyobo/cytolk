# cython: language_level=3
cimport cytolk


def load():
    cytolk.Tolk_Load()

def unload():
    cytolk.Tolk_Unload()

def is_loaded():
    return cytolk.Tolk_IsLoaded()

def detect_screen_reader():
    sr = cytolk.Tolk_DetectScreenReader()
    if not sr:
        sr = "no screenreader detected"
    return sr

def try_sapi(try_sapi):
    cytolk.Tolk_TrySAPI(try_sapi)

def prefer_sapi(prefer_sapi):
    cytolk.Tolk_PreferSAPI(prefer_sapi)

def output(text, interrupt=False):
    return cytolk.Tolk_Output(text, interrupt)

def speak(text, interrupt=False):
    return cytolk.Tolk_Speak(text, interrupt)

def braille(text):
    return cytolk.Tolk_Braille(text)

def has_speech():
    return cytolk.Tolk_HasSpeech()

def has_braille():
    return cytolk.Tolk_HasBraille()

def is_speaking():
    return cytolk.Tolk_IsSpeaking()

def silence():
    return cytolk.Tolk_Silence()