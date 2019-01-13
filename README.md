# FEMMfilelink


## Example Usage
```
> import FEMMfilelink

> femmprocess = FEMMfilelink.startfemm()
Process(`C:/femm42/bin/femm.exe -filelink -windowhide`, ProcessRunning)

> FEMMfilelink.testfilelink()
true

> FEMMfilelink.filelink("flput(2+2)")
4.0

> kill(femmprocess)

>
```
