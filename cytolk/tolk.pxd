# cython: language_level=3
# distutils: language="c++"
from cpython.ref cimport PyObject 
from libcpp cimport bool
from cpython.ref cimport PyObject 
from libc.stddef cimport wchar_t


cdef extern from "Python.h":
    PyObject *PyUnicode_FromWideChar(wchar_t *w, Py_ssize_t size)
    void PyMem_Free(void *p)
    wchar_t *PyUnicode_AsWideCharString(PyObject *unicode, Py_ssize_t *size)



cdef extern from "../tolk/src/Tolk.h":

    cdef void Tolk_Load()
    cdef bool Tolk_IsLoaded()
    cdef void Tolk_Unload()
    cdef void Tolk_TrySAPI(bool trySAPI)
    cdef void Tolk_PreferSAPI(bool preferSAPI)
    cdef const wchar_t* Tolk_DetectScreenReader()
    cdef bool Tolk_HasSpeech()
    cdef bool Tolk_HasBraille()
    cdef bool Tolk_Output(const wchar_t *text, bool interrupt)
    cdef bool Tolk_Speak(const wchar_t *text, bool interrupt)
    cdef bool Tolk_Braille(const wchar_t *text)
    cdef bool Tolk_IsSpeaking()
    cdef bool Tolk_Silence()
