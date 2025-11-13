::logInfo("Bombs Loading");
::includeFiles(::IO.enumerateFiles("bombs/hooks"));		// This will load and execute all hooks
::logInfo("loaded " + ::IO.enumerateFiles("bombs/hooks"))
