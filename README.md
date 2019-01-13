# FEMMfilelink

[FEMM](http://www.femm.info/wiki/HomePage) [filelink](http://www.femm.info/wiki/FilelinkClient) interface.

## Example Usage
Assumes FEMM has been installed in default location.

```
> import FEMMfilelink

> femmprocess = FEMMfilelink.startfemm()
Process(`C:/femm42/bin/femm.exe -filelink -windowhide`, ProcessRunning)

> FEMMfilelink.testfilelink()
true

> FEMMfilelink.filelink("flput(2+2)")
4.0

> # use writeifile when no output is expected

> FEMMfilelink.writeifile("newdocument(1)");

> FEMMfilelink.readofile()
""

> kill(femmprocess)

>
```
