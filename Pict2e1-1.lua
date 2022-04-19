-- This file:
--     http://angg.twu.net/LUA/Pict2e1-1.lua.html
--     http://angg.twu.net/LUA/Pict2e1-1.lua
--             (find-angg "LUA/Pict2e1-1.lua")
--   http://angg.twu.net/LATEX/Pict2e1-1.lua.html
--   http://angg.twu.net/LATEX/Pict2e1-1.lua
--           (find-angg "LATEX/Pict2e1-1.lua")
--       (find-tkdiff   "~/LUA/Pict2e1-1.lua" "~/LATEX/Pict2e1-1.lua")
--      (find-sh0 "cp -v ~/LUA/Pict2e1-1.lua   ~/LATEX/Pict2e1-1.lua")
--
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 2022apr18
--
-- Tests for Pict2e1.lua that use functions that don't need to be in
-- the core.
--
-- (defun a  () (interactive) (find-angg "LUA/Pict2e1.lua"))
-- (defun b  () (interactive) (find-angg "LUA/Pict2e1-1.lua"))
-- (defun ab () (interactive) (find-2b '(a) '(b)))
-- (defun et () (interactive) (find-angg "LATEX/2022pict2e.tex"))
-- (defun eb () (interactive) (find-angg "LATEX/2022pict2e-body.tex"))
-- (defun ao () (interactive) (find-angg "LATEX/2022pict2e.lua"))
-- (defun v  () (interactive) (find-pdftools-page "~/LATEX/2022pict2e.pdf"))
-- (defun tb () (interactive) (find-ebuffer (eepitch-target-buffer)))
-- (defun etv () (interactive) (find-wset "13o2_o_o" '(tb) '(v)))
-- (setenv "PICT2ELUADIR" "~/LATEX/")
--
-- (code-c-d "pict2elua" "/tmp/pict2e-lua/" :anchor)
-- (defun a  () (interactive) (find-pict2elua "Pict2e1.lua"))
-- (defun b  () (interactive) (find-pict2elua "Pict2e1-1.lua"))
-- (defun ab () (interactive) (find-2b '(a) '(b)))
-- (defun et () (interactive) (find-pict2elua "2022pict2e.tex"))
-- (defun eb () (interactive) (find-pict2elua "2022pict2e-body.tex"))
-- (defun v  () (interactive) (find-pdftools-page "/tmp/pict2e-lua/2022pict2e.pdf"))
-- (defun tb () (interactive) (find-ebuffer (eepitch-target-buffer)))
-- (defun etv () (interactive) (find-wset "13o2_o_o" '(tb) '(v)))
-- (setenv "PICT2ELUADIR" "/tmp/pict2e-lua/")

-- «.Plot2D»		(to "Plot2D")
-- «.Plot2D-test1»	(to "Plot2D-test1")
-- «.Plot2D-test2»	(to "Plot2D-test2")

require "Pict2e1"      -- (find-angg "LUA/Pict2e1.lua")

pi, sin, cos = math.pi, math.sin, math.cos

seqn = function (a, b, n)
    local f = function (k) return a + (b-a)*(k/n) end
    return map(f, seq(0, n))
  end




--  ____  _       _   ____  ____  
-- |  _ \| | ___ | |_|___ \|  _ \ 
-- | |_) | |/ _ \| __| __) | | | |
-- |  __/| | (_) | |_ / __/| |_| |
-- |_|   |_|\___/ \__|_____|____/ 
--                                
-- «Plot2D»  (to ".Plot2D")

Plot2D = Class {
  type  = "Plot2D",
  new   = function (tbl)
      if type(tbl.P)  == "string" then tbl.P  = Code.ve(tbl.P)  end
      if type(tbl.Pt) == "string" then tbl.Pt = Code.ve(tbl.Pt) end
      if tbl.ts then tbl.ts = HTable(tbl.ts) end
      return Plot2D(tbl)
    end,
  from  = function (P, ts)
      return Plot2D.new({P=P, ts=ts})
    end,
  __tostring = function (p) return p:tostring() end,
  __index = {
    tostring = function (p)
        return pformat("P:  %s\nPt: %s\nts: %s", p.P, p.Pt, p:tstostring())
      end,
    tstostring = function (p)
        if not p.ts then return "nil" end
        local f = function (t) return pformat("%s", t) end
        local pts = "{"..mapconcat(f, p.ts, ", ").."}"
        return pts
      end,
    topts = function (p)
        return myunpack(map(p.P, p.ts))
      end,
    toline = function (p)
        return Pict2e.line(p:topts())
      end,
    tovector = function (p, t)
        return Pict2eVector.fromwalk(p.P(t), p.Pt(t))
      end,
    tovectors = function (p, ts)
        local f = function (t) return p:tovector(t) end
        return PictList(map(f, ts))
      end,
  },
}

-- «Plot2D-test1»  (to ".Plot2D-test1")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
= Plot2D.from("x =>     sin(x) ")
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4))
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4)).ts
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4)):tstostring()
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4))
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4)):topts()
= Plot2D.from("x => v(x,sin(x))", seq(0, pi, pi/4)):topts()
= Plot2D.from("x => v(x,sin(x))", seq(0, pi, pi/4)):toline()
= Plot2D.from("x => v(x,sin(x))", seqn(0, pi,   4)):toline():Color("Red")

--]==]



-- «Plot2D-test2»  (to ".Plot2D-test2")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
PradClass.__index.bshow0 = function (p)
    return p:pgat("pgat"):d():tostringp()
  end
Pict2e.bounds = PictBounds.new(v(-3,-3), v(3,3))
Show.preamble = [[
  \unitlength=25pt
]]

_P  = function (t) return v(   cos(t),       sin(t)) end
_Pt = function (t) return v(  -sin(t),       cos(t)) end
_Q  = function (t) return v(   cos(4*t)/2,   sin(4*t)/2) end
_Qt = function (t) return v(-2*sin(4*t),   2*cos(4*t)  ) end
_R  = function (t) return _P(t)+_Q(t) end
_Rt = function (t) return _Pt(t)+_Qt(t) end

ts   = seqn(0, 2*pi, 64)
r = Plot2D.new {
      P  = "t => _R (t)",
      Pt = "t => _Rt(t)",
      ts = ts
  }

ts_v = seqn(0, 2*pi, 6)
= r:tovectors(ts_v)

p = PictList {
      r:toline():Color("Orange"),
      r:tovectors(ts_v):Color("Red")
    }:prethickness("2pt")
= p
= p:bshow()
 (etv)

--]==]





















--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"

from("t => _R(t)", seq(0, 2*pi, pi/64)):toline():Color("Red"):bshow()

= myplot("_Q(t)", "Green") 
= myplot("_Q(t)", "Green"):bshow()
p = PictList {
    myplot("_P(t)", "Red"),
    myplot("_Q(t)", "Orange"),
    myplot("_R(t)", "Green")
  }
= p
p:bshow()
 (etv)

= Plot2D.from("t => _R(t)", seq(0, 2*pi, pi/64)):toline():Color("Red"):bshow()

--]==]



--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
Show.preamble = [[
  \unitlength=25pt
  \celllower=3pt
  \def\nodesize{0.9}
  \def\nodecolor{AntiqueWhite1}
  \def\nodecolor{Orange!50!white}
  \def\nodeify#1{%
      {\color{\nodecolor}\circle*{\nodesize}}%
      \circle{\nodesize}%
      \cell{#1}%
    }
  \def\putnode(#1,#2)#3{\put(#1,#2){\nodeify{#3}}}
  \def\Sone{[\mathrm{S1}]}
  \def\Stwo{[\mathrm{S2}]}
]]

nodes = { }

Pict2e.bounds = PictBounds.new(v(-1,-1), v(4,4))


p = PictList {
  [[ \Line(0,0)(3,3) ]],
  [[ \Line(2,2)(3,1) ]],
  [[ \putnode(0,0){a} ]],
  [[ \putnode(1,1){\Stwo} ]],
  [[ \putnode(2,2){+} ]],
  [[ \putnode(3,3){\Stwo} ]],
  [[ \putnode(3,1){b} ]],
}
= p:bshow()
 (etv)

PradClass.__index.bshow0 = function (p)
    -- return p:pgat("pgat"):dd():tostringp()
    return p:pgat("p"):dd():tostringp()
  end
= p:bshow()
 (etv)

--]==]






-- Local Variables:
-- coding:  utf-8-unix
-- End:
