# Read-HostTimeout

Original code from http://thecuriousgeek.org/2014/10/powershell-read-host-with-timeout/.

* Improved backspace handling, before if your new characters were not longer than the previous text, it would not overwrite. Also prevented backspacing over the prompt.
* Added escape handling to reset cursor to begining
* Fix accepting a null input
