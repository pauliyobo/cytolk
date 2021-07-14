# cython: language_level=3
# distutils: language="c++"

from functools import wraps
import os
from pathlib import Path
from typing import Optional

from . cimport tolk

# TODO: change the implementation to utilize os.add_dll_path for python versions above 3.8

dir: str = str(Path(__file__).parent) + os.pathsep


class TolkNotLoadedError(BaseException):
    pass


def check_if_loaded(fn):
    """
    This decorator takes care of calling the function supplied
    raising a TolkNotLoadedError if tolk was not loaded
    """
    @wraps(fn)
    def wrapper(*args, **kwargs):
        if not is_loaded():
            raise TolkNotLoadedError(f"tolk must be loaded to call {fn.__name__}")
        return fn(*args, **kwargs)
    return wrapper


def add_dll_path():
    """this function adds the dll directory in order to allow tolk to properly find the dlls it needs without having to place them manually."""   
    os.environ['PATH'] = dir + os.environ['Path']


def remove_dll_path():
    # forgive me for the really really not elegant way
    os.environ['PATH'] = os.environ['PATH'].replace(dir, "")


def load():
    if not is_loaded():
        add_dll_path()
        tolk.Tolk_Load()


def unload():
    if is_loaded():
        tolk.Tolk_Unload()
        remove_dll_path()

def is_loaded() -> bool:
    return tolk.Tolk_IsLoaded()


def detect_screen_reader()-> Optional[str]:
    cdef const wchar_t* sr = tolk.Tolk_DetectScreenReader()
    if sr == NULL:
        return None
    return sr


def try_sapi(try_sapi: bool):
    tolk.Tolk_TrySAPI(try_sapi)


def prefer_sapi(prefer_sapi: bool):
    tolk.Tolk_PreferSAPI(prefer_sapi)

@check_if_loaded
def output(text: str, interrupt: bool=False) -> bool:
    return tolk.Tolk_Output(text, interrupt)


def speak(text: str, interrupt: bool=False) -> bool:
    return tolk.Tolk_Speak(text, interrupt)


def braille(text: str):
    return tolk.Tolk_Braille(text)


def has_speech() -> bool:
    return tolk.Tolk_HasSpeech()


def has_braille() -> bool:
    return tolk.Tolk_HasBraille()


def is_speaking() -> bool:
    return tolk.Tolk_IsSpeaking()


def silence() -> bool:
    return tolk.Tolk_Silence()
