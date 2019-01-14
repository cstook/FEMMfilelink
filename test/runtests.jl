import FEMMfilelink
using Test

femmprocess = FEMMfilelink.startfemm()
@test FEMMfilelink.testfilelink(timeout_s=3)
kill(femmprocess)
