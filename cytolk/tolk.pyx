# cython: language_level=3
# distutils: language="c++"

from contextlib import contextmanager
from functools import wraps
import os
from pathlib import Path
import sys
from typing import Optional

from . cimport tolk


try:
    dir: Optional[str] = str(Path(__file__).parent) + os.pathsep
except TypeError:
    # When using libraries like nuitka to link cytolk to the executable we do not have access to __file__ due to the fact that cytolk is a c extension
    dir = None

class TolkNotLoadedError(BaseException):
    pass

@contextmanager
def tolk(extended_search_path: bool = True):
    load(extended_search_path)
    try:
        yield
    except BaseException as e:
        raise e
    finally:
        unload()


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
    """
    this function adds the dll directory in order to allow tolk to properly find the dlls it needs without having to place them manually.
    """   
    os.environ['PATH'] = dir + os.environ['Path']


def remove_dll_path():
    # forgive me for the really really not elegant way
    os.environ['PATH'] = os.environ['PATH'].replace(dir, "")


def load(extended_search_path: bool = True) -> None:
    if not is_loaded():
        if extended_search_path:
            if dir is not None:
                add_dll_path()
            else:
                raise RuntimeError("Could not determine cytolk's current location.\n\nIf you are using nuitka set `extended_search_path` to False and use the plugin instead.")
        tolk.Tolk_Load()


def unload() -> None:
    if is_loaded():
        tolk.Tolk_Unload()
        if dir is not None:
            remove_dll_path()

def is_loaded() -> bool:
    return tolk.Tolk_IsLoaded()


@check_if_loaded
def detect_screen_reader()-> Optional[str]:
    cdef const wchar_t* c_sr = tolk.Tolk_DetectScreenReader()
    if c_sr == NULL:
        return None
    cdef PyObject * sr = PyUnicode_FromWideChar(c_sr, -1)
    return <object> sr


def try_sapi(try_sapi: bool) -> None:
    tolk.Tolk_TrySAPI(try_sapi)


def prefer_sapi(prefer_sapi: bool):
    tolk.Tolk_PreferSAPI(prefer_sapi)

@check_if_loaded
def output(text: str, interrupt: bool=False) -> bool:
    cdef wchar_t* txt = PyUnicode_AsWideCharString(<PyObject*> text, NULL)
    ret =  tolk.Tolk_Output(txt, interrupt)
    PyMem_Free(txt)
    return ret


@check_if_loaded
def speak(text: str, interrupt: bool=False) -> bool:
    cdef wchar_t* txt = PyUnicode_AsWideCharString(<PyObject*> text, NULL)
    ret =  tolk.Tolk_Speak(txt, interrupt)
    PyMem_Free(txt)
    return ret


@check_if_loaded
def braille(text: str) -> bool:
    cdef wchar_t* txt = PyUnicode_AsWideCharString(<PyObject*> text, NULL)
    ret =  tolk.Tolk_Braille(txt)
    PyMem_Free(txt)
    return ret


@check_if_loaded
def has_speech() -> bool:
    return tolk.Tolk_HasSpeech()


@check_if_loaded
def has_braille() -> bool:
    return tolk.Tolk_HasBraille()


@check_if_loaded
def is_speaking() -> bool:
    return tolk.Tolk_IsSpeaking()


@check_if_loaded
def silence() -> bool:
    return tolk.Tolk_Silence()
