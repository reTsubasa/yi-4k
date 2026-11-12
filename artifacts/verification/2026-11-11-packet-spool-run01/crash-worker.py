import ctypes as C,sys
l=C.CDLL(sys.argv[1]);l.create_file.argtypes=[C.c_char_p,C.c_int];l.append_audio.argtypes=[C.POINTER(C.c_ubyte),C.c_uint32,C.c_uint32,C.c_uint64]
assert l.create_file(sys.argv[2].encode(),int(sys.argv[3]))==0
p=(C.c_ubyte*64)(*range(64));l.append_audio(p,64,0,0)
