"""Numerically check the identities in README.md at random points.

Run with: python3 check_identities.py
Prints the name of any identity that fails, with a few failing points.
"""
import random, cmath
from math import *
random.seed(1)
sg=lambda v:(v>0)-(v<0)
def close(a,b): return abs(a-b)<1e-9
bad={}
def chk(name,ok,pt):
    if not ok: bad.setdefault(name,[]).append(pt)
pts=[(random.uniform(-3,3),random.uniform(-3,3)) for _ in range(20000)]
pts+=[(x,0.0) for x in (-2,-0.5,0.5,2)]+[(0.0,y) for y in (-2,2)]
for x,y in pts:
    r=hypot(x,y); A=atan2(y,x)
    if y!=0 or x>0: chk('p1 half-angle',close(A,2*atan(y/(x+r))),(x,y))
    chk('atan sum',close(atan(x)+atan(y),atan2(x+y,1-x*y)),(x,y))
    chk('atan sum 2atan',close(atan(x)+atan(y),2*atan((x+y)/(1-x*y+sqrt((x*x+1)*(y*y+1))))),(x,y))
    if x!=0:
        chk('atan quot',close(atan(y/x),2*atan(y/(x+sg(x)*r))),(x,y))
        if y!=0: chk('atan quot pi',close(atan(y/x),2*atan(y/(x-sg(x)*r))+sg(y/x)*pi),(x,y))
    for a in (2.0,-0.7):
        if y!=0 or x/a>0: chk('scaled',close(atan2(y/a,x/a),2*atan(y/(x+sg(a)*r))),(x,y,a))
    a1,b1,a2,b2=x,y,random.uniform(-3,3),random.uniform(-3,3)
    if b1!=0 and b2!=0:
        chk('quot sum',close(atan(a1/b1)+atan(a2/b2),2*atan((a1*b2+a2*b1)/(b1*b2-a1*a2+sg(b1*b2)*sqrt((a1*a1+b1*b1)*(a2*a2+b2*b2))))),(a1,b1,a2,b2))
    if (y!=0 or x>=0) and r>0: chk('neg',close(-atan2(-y,x),A),(x,y))
    chk('2atan',close(2*atan(x),atan2(2*x,1-x*x)),(x,))
    chk('sin',close(sin(A),y/r),(x,y)); chk('cos',close(cos(A),x/r),(x,y))
    chk('2atan2 sum',close(2*atan2(x+y,1-x*y),atan2(2*x,1-x*x)+atan2(2*y,1-y*y)),(x,y))
    if not (x==0 and abs(y)==1): chk('atan2 pair',close(atan2(x,1-y)+atan2(x,1+y),atan2(2*x,1-x*x-y*y)),(x,y))
    D=4-4*x-y*y
    if D>=0 and r>0:
        s=sqrt(D); ok=close(A,atan2(y/2,(2+s)/2)+atan2(y/2,(2-s)/2)) if not (y==0 and s==2) else True
        chk('split D>=0',ok,(x,y))
    if D<=0:
        t=sqrt(-D)
        chk('split D<=0',close(A,.5*atan2(y+t,(4-y*y-2*x-y*t)/2)+.5*atan2(y-t,(4-y*y-2*x+y*t)/2)),(x,y))
    if r>0:
        t=cmath.sqrt(y*y+4*x-4)
        v=cmath.atan((y+t)/2)+cmath.atan((y-t)/2)
        chk('atan form (complex)',abs(v-A)<1e-9,(x,y))
    if x>0: chk('half x>0',close(.5*atan2(y,(x*x-y*y)/(2*x)),A),(x,y))
    if x<0: chk('half x<0',close(.5*atan2(y,(x*x-y*y)/(2*x)),atan2(y,-y*y/x) if y!=0 else pi/2),(x,y))
    if y!=0 or x>0: chk('2atan2 form',close(A,2*atan2(y,x+r)),(x,y))
    z=complex(x,y)
    if x!=0: chk('complex atan pair',abs(cmath.atan(z)+cmath.atan(z.conjugate())-atan2(2*x,1-x*x-y*y))<1e-9,(x,y))
for k,v in bad.items(): print(k,len(v),v[:4])
print('done')
