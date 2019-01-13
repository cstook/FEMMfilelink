module FEMMfilelink


import TOML

function getfemmfiles()
    config = joinpath(homedir(),"FEMMfilelinkconfig.toml")
    ~isfile(config) && cp("FEMMfilelinkconfig.toml",config)
    configdict = TOML.parsefile(config)
    (configdict["exe"], configdict["ifile"], configdict["ofile"])
end

const (exe,ifile,ofile) = getfemmfiles()

function clearfiles()
    rm(ifile,force=true)
    rm(ofile,force=true)
end

function startfemm()
    clearfiles()
    run(`$exe -filelink -windowhide`, wait=false)
end

function readofile(;delay=.1, retries=20)
    for i=1:retries
        wait(Timer(delay))
        isfile(ofile) && break
    end
    x = ""
    if isfile(ofile)
        open(ofile, read=true) do io
            x = read(io,String)
        end
    end
    rm(ofile,force=true)
    x
end

function writeifile(luastatment)
    open(ifile, create=true, write=true) do io
        write(io,luastatment)
    end
end

function filelink(luastatment; returntype::Type=Float64)
    writeifile(luastatment)
    x = readofile()
    parse(returntype,match(r"\[(.*)\]",x).captures[1])
end

function testfilelink()
    clearfiles()
    filelink("flput(2+2)") == 4.0
end

end # module
