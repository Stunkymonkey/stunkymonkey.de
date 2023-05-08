+++
title = "Powershell is stupid"
description = "on work I have to deal with powershell and i start hating it."
tags = [
  "windows",
  "powershell",
]
date = 2022-12-03T13:11:50Z
author = "Felix Bühler"
+++

Due to work I have to find installation solutions where I can not except anything beeing preinstalled. Therefore I have to use bash & powershell. Bash is ok, but with powershell... See yourself:

- **`GET`-Web-Requests** are cached by default:\
  there is the option to disable caching via http-header, but it does not work for all methods
- **Unicode** interpretation:\
  based on the language setting of the system each character can be interpreted differently. On a english system a unicode minus can get interpreted as a normal ascii minus. On a Chinese system, this unicode character is interpreted differently and the process can not be executed. Please disable BOM (byte-order-mark) on all files to prevent this issue.
- **Escape-character**:\
  is a backtick(`` ` ``), which is not easily distinquished by other ticks and therefore easily produces errors.
- **Function-returns**:\
  if a single command has an stdout and is not captured to `Out-Null` it will return it as well. All Printing will be returned.
- **Function-calls** can be used with and without parantheses:\
  The parameters then have to be passed differently.
- **Strings** with quotes:\
  When declaring the string before hand can be interpreted differently to passing the string directly to a function call.
  If using double-quotes in strings you should always use them in combination of single-quotes. Using doulbe-quotes in combination with themself and escaping the inner ones does not produce what you want. 
- **Scopes** of variables:\
  is not clear after a function call (only by using modules it is).
- **Documentation**:\
  exists, but is very bad. It assumes you know the whole history of DOS.
- **Strings-equality**:\
  can only truly be tested with ancient `-eq` but the `==` can sometimes work. same as in `bash`
- **Case-insensitivity**:\
  is everywhere. Renaming files with a different casing can not be done due to "File already exists."
- **Loading of Modules**:\
  `Import-Module` loads a module, but if it has been loaded before it will be ignored. You always have to specify `--force` so the overload takes place.
- **`Write-Host`** should be removed:\
  [It never does what you want it to do](https://www.jsnover.com/blog/2013/12/07/write-host-considered-harmful/). Most of the time `Write-Verbose` is what you want.
- **@-symbol** can cause weird behaviours:\
  It is for example not allowed to be in the module description. It simply terminates the description string. The Highlighters of most programms do not respect this termination.
- **`Get-Credential`-dialog**:\
  Any enter press will close the windows even if you want to select the value of a dropdown menu
- **Folder-Auto-Completion**:\
  When changing the directory with `Set-Location` it iterates through all folders instead of showing all matching folder, so i can type the correct one.

If you have explanations for any of the claimed points.
Please contact me and explain them.
Otherwise I will keep them up for other people to know how much "fun" you can have with powershell.
