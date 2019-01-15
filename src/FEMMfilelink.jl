module FEMMfilelink


import TOML
using FileWatching

function getfemmfiles()
    config = joinpath(homedir(),"FEMMfilelinkconfig.toml")
    ~isfile(config) && cp("FEMMfilelinkconfig.toml",config)
    configdict = TOML.parsefile(config)
    (configdict["exe"], configdict["ifile"], configdict["ofile"], configdict["femmbindir"])
end

const (exe,ifile,ofile,femmbindir) = getfemmfiles()

function clearfiles()
    rm(ifile,force=true)
    rm(ofile,force=true)
end

function startfemm()
    clearfiles()
    run(`$exe -filelink -windowhide`, wait=false)
end

function readofile(;timeout_s::Real=-1)
    while ~isfile(ofile)
        (file,event) = watch_folder(femmbindir,timeout_s)
        event.timedout && throw(ErrorException("readofile timeout"))
    end
    unwatch_folder(femmbindir)
    x = ""
    open(ofile, read=true) do io
        x = read(io,String)
    end
    rm(ofile,force=true)
    x
end

function writeifile(luastatment)
    open(ifile, create=true, write=true) do io
        write(io,luastatment)
    end
end

function filelink(luastatment; returntype::Type=Float64, timeout_s::Real=-1)
    writeifile(luastatment)
    x = readofile(timeout_s=timeout_s)
    parse(returntype,match(r"\[(.*)\]",x).captures[1])
end

function testfilelink(;timeout_s::Real=1.0)
    clearfiles()
    filelink("flput(2+2)",timeout_s=timeout_s) == 4.0
end

end # module
