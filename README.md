# Read-HostTimeout

Original code from http://thecuriousgeek.org/2014/10/powershell-read-host-with-timeout/.

* Improved backspace handling, before if your new characters were not longer than the previous text, it would not overwrite. Also prevented backspacing over the prompt.
* Added escape handling to reset cursor to begining
* Fix accepting a null input

## Example
```powershell
# Prompts for name, if 60 seconds goes by with no input, return null. Set default name to John Doe.

$namePrompt = Read-HostTimeout -Prompt "Enter your name" -delayInSeconds 60

If( ($null -eq $namePrompt) -or ($namePrompt -eq "")) {
    $name = "John Doe"
} Else {
    $name = $namePrompt
}
```
