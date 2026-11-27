// Shared helpers first (used by several hook files), then every hook file.
::include("bombs/grenadier_helper.nut");
::includeFiles(::IO.enumerateFiles("bombs/hooks"));
