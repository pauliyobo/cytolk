# cython: language_level=3
# distutils: language="c++"

import os
from pathlib import Path

from . cimport tolk

# TODO: change the implementation to utilize os.add_dll_path for python versions above 3.8

dir = str(Path(__file__).parent) + os.pathsep

def add_dll_path():
    """this function adds the dll directory in order to allow tolk to properly find the dlls it needs without having to place them manually."""   
    os.environ['PATH'] = dir + os.environ['Path']

def remove_dll_path():
    # forgive me for the really really not elegant way
    os.environ['PATH'] = os.environ['PATH'].replace(dir, "")

def load():
    add_dll_path()
    tolk.Tolk_Load()

def unload():
    tolk.Tolk_Unload()
    remove_dll_path()

def is_loaded():
    return tolk.Tolk_IsLoaded()

def detect_screen_reader():
    cdef const wchar_t* sr = tolk.Tolk_DetectScreenReader()
    if sr == NULL:
        return None
    return sr

def try_sapi(try_sapi):
    tolk.Tolk_TrySAPI(try_sapi)

def prefer_sapi(prefer_sapi):
    tolk.Tolk_PreferSAPI(prefer_sapi)

def output(text, interrupt=False):
    return tolk.Tolk_Output(text, interrupt)

def speak(text, interrupt=False):
    return tolk.Tolk_Speak(text, interrupt)

def braille(text):
    return tolk.Tolk_Braille(text)

def has_speech():
    return tolk.Tolk_HasSpeech()

def has_braille():
    return tolk.Tolk_HasBraille()

def is_speaking():
    return tolk.Tolk_IsSpeaking()

def silence():
    return tolk.Tolk_Silence()
