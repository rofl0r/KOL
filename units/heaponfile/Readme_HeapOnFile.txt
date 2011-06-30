THeapOnFile (C) by Kladov Vladimir, 2001
Key Objects Library required, http://xcl.cjb.net
------------------------------------------------

This object was created in result of some my investigations. When I solved a task, which required a huge amount of memory blocks of several different sizes. When amount of memory, got by the application, became so big, than system (Windows2000) crashed, and I decided to create this small memory allocation tool. It allowed me to continue working under the task, because all the memory was allocated not from Windows virtual memory, which size can be restricted, but on a file, which can grow while disk space is available. And only restricted number of allocated records, locked by the application, are located at the memory at the moment. This reduces a bit performance, but provides a solution for case when Windows system can not provide sufficient memory for an application. To compare results with previous situation, when memory is allocated directly from heap, just replace reference in 'uses' clause from HeapOnFile.pas to HeapOnFileDummy.pas, and recompile the application. (But first You should therefore write code to use THeapOnFile objects to allocate memory by the way it allows).

--------------------------------------------------------------------
http://xcl.cjb.net
bonanzas@xcl.cjb.net