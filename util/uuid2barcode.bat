@ECHO OFF

REM
REM $Id$
REM 
REM Copyright (C) 2011 John Willis
REM  
REM This file is part of Prefiniti.
REM 
REM Prefiniti is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version.
REM 
REM Prefiniti is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.
REM 
REM You should have received a copy of the GNU General Public License
REM along with Prefiniti.  If not, see <http://www.gnu.org/licenses/>.
REM 

C:
CD "\Program Files\GnuWin32\bin"
BARCODE -E -b %1 -o d:\inetpub\orms\tmp\%1.eps
CD "\Program Files\gs\gs9.01\bin"
gswin32c -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -dGraphicsAlphaBits=4 -sOutputFile=d:\inetpub\orms\tmp\%1.png d:\inetpub\orms\tmp\%1.eps

COPY d:\inetpub\orms\tmp\%1.png "%2"
ERASE d:\inetpub\orms\tmp\%1.eps
ERASE d:\inetpub\orms\tmp\%1.png
D:
