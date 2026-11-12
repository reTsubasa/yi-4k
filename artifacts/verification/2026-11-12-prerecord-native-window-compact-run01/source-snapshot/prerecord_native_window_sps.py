"""Bounded H.264 SPS geometry parser for native mux track configuration."""
class Bits:
    def __init__(self,data):self.data=data;self.pos=0
    def read(self,count):
        if count<0 or self.pos+count>len(self.data)*8:raise ValueError('truncated SPS')
        value=0
        for _ in range(count):value=(value<<1)|((self.data[self.pos//8]>>(7-self.pos%8))&1);self.pos+=1
        return value
    def ue(self):
        zeros=0
        while self.read(1)==0:
            zeros+=1
            if zeros>31:raise ValueError('SPS Exp-Golomb exceeds bound')
        return (1<<zeros)-1+self.read(zeros)
    def se(self):
        value=self.ue();return (value+1)//2 if value&1 else -(value//2)

def geometry(sps):
    if not sps or sps[0]&31!=7:raise ValueError('not an SPS NAL')
    rbsp=bytearray();zeros=0
    for value in sps[1:]:
        if zeros>=2 and value==3:zeros=0;continue
        rbsp.append(value);zeros=zeros+1 if value==0 else 0
    b=Bits(rbsp);profile=b.read(8);constraints=b.read(8);level=b.read(8);sps_id=b.ue()
    if profile not in (66,77,88,100,110,122,244,44,83,86,118,128,138,139,134,135):raise ValueError('unsupported SPS profile')
    chroma=1;separate=0
    if profile in (100,110,122,244,44,83,86,118,128,138,139,134,135):
        chroma=b.ue()
        if chroma>3:raise ValueError('invalid chroma format')
        if chroma==3:separate=b.read(1)
        bit_luma=b.ue()+8;bit_chroma=b.ue()+8
        if bit_luma>14 or bit_chroma>14:raise ValueError('unsupported sample depth')
        b.read(1)
        if b.read(1):
            for i in range(12 if chroma==3 else 8):
                if b.read(1):
                    last=8;next_scale=8
                    for _ in range(16 if i<6 else 64):
                        if next_scale:next_scale=(last+b.se()+256)%256
                        last=next_scale or last
    b.ue();poc=b.ue()
    if poc==0:b.ue()
    elif poc==1:
        b.read(1);b.se();b.se();count=b.ue()
        if count>255:raise ValueError('excessive SPS POC cycle')
        for _ in range(count):b.se()
    elif poc!=2:raise ValueError('invalid SPS POC type')
    b.ue();b.read(1)
    mbs_w=b.ue()+1;map_h=b.ue()+1;frame_only=b.read(1)
    if not frame_only:b.read(1)
    b.read(1);crop=[b.ue() for _ in range(4)] if b.read(1) else [0,0,0,0]
    array_type=0 if separate else chroma
    sub_w=2 if array_type in (1,2) else 1
    sub_h=2 if array_type==1 else 1
    unit_x=sub_w if array_type else 1;unit_y=sub_h*(2-frame_only) if array_type else 2-frame_only
    coded_w=mbs_w*16;coded_h=map_h*16*(2-frame_only)
    width=coded_w-(crop[0]+crop[1])*unit_x;height=coded_h-(crop[2]+crop[3])*unit_y
    if width<=0 or height<=0 or width>16384 or height>16384:raise ValueError('invalid/out-of-contract SPS dimensions')
    if not frame_only:raise ValueError('interlaced stream not in native window contract')
    return dict(profile_idc=profile,constraint_flags=constraints,level_idc=level,sps_id=sps_id,
        chroma_format_idc=chroma,frame_mbs_only_flag=frame_only,coded_width=coded_w,coded_height=coded_h,
        crop_offsets=crop,crop_unit_x=unit_x,crop_unit_y=unit_y,width=width,height=height)
