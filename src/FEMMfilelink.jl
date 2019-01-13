module FEMMfilelink

import TOML
configdict = TOML.parsefile("../FEMMfilelinkconfig.toml")
const exe = configdict["exe"]
const ifile = configdict["ifile"]
const ofile = configdict["ofile"]

function clearfiles()
    rm(ifile,force=true)
    rm(ofile,force=true)
    (ifile,ofile)
end

function setup()
    clearfiles()
    run(`$exe -filelink -windowhide`, wait=false)
end

function readofile()
    for i=1:20
        wait(Timer(.1))
        isfile(ofile) && break
    end
    x = ""
    if isfile(ofile)
        open(ofile, read=true) do io
            x = read(io,String)
        end
    end
    x
end

function writeifile(luastatment)
    open(femm_files.ifile, create=true, write=true) do io
        write(io,luastatment)
    end
end

function filelink(luastatment; returntype::Type=Float64)
    writeifile(luastatment)
    x = readofile()
    parse(returntype,match(r"\[(.*)\]",x).captures[1])
end

testfilelink() = filelink("2+2") == 4.0

end # module
