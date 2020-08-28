# cython: language_level=3
# distutils: language="c++"
from libcpp cimport bool

cdef extern from "tolk/src/Tolk.h":
    ctypedef Py_UNICODE wchar_t

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
