
C:
CD "\Program Files\GnuWin32\bin"
BARCODE -E -b %1 -o d:\inetpub\orms\tmp\%1.eps
CD "\Program Files\gs\gs9.01\bin"
gswin32c -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -dGraphicsAlphaBits=4 -sOutputFile=d:\inetpub\orms\tmp\%1.png d:\inetpub\orms\tmp\%1.eps

COPY d:\inetpub\orms\tmp\%1.png "%2"
ERASE d:\inetpub\orms\tmp\%1.eps
ERASE d:\inetpub\orms\tmp\%1.png
D:
