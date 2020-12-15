Function Read-HostTimeout {
###################################################################
##  Description:  Mimics the built-in "read-host" cmdlet but adds an expiration timer for
##  receiving the input.  Does not support -assecurestring
##
##  This script is provided as is and may be freely used and distributed so long as proper
##  credit is maintained.
##
##  Written by: thegeek@thecuriousgeek.org
##  Original Date:  10-24-14
##  
##  Accept null entry, better backspace handling, and escape handling
##  Modified by: evan@forevanyeung.com
##  Date Modified:  12-14-20
###################################################################

# Set parameters.
param(
    [Parameter(Mandatory=$false,Position=1)]
    [string]$prompt,
    
    [Parameter(Mandatory=$false,Position=2)]
    [int]$delayInSeconds
)
    
    # Do the math to convert the delay given into milliseconds
    # and divide by the sleep value so that the correct delay
    # timer value can be set
    $sleep = 250
    $delay = ($delayInSeconds*1000)/$sleep
    $count = 0
    $charArray = New-Object System.Collections.ArrayList
    If($prompt) {
        Write-host -nonewline "$($prompt):  "
    }
    
    # While loop waits for the first key to be pressed for input and
    # then exits.  If the timer expires it returns null
    While ( (!$host.ui.rawui.KeyAvailable) -and ($count -lt $delay) ){
        start-sleep -m $sleep
        $count++
        If ($count -eq $delay) { "`n"; return $null}
    }
    
    # This block is where the script keeps reading for a key.  Every time
    # a key is pressed, it checks if it's a carriage return.  If so, it exits the
    # loop and returns the string.  If not it stores the key pressed and
    # then checks if it's a backspace and does the necessary cursor 
    # moving and blanking out of the backspaced character, then resumes 
    # writing.

    $beginCursorPos = $host.ui.rawui.get_cursorPosition()

    $key = $host.ui.rawui.readkey("NoEcho,IncludeKeyUp")
    While ($key.virtualKeyCode -ne 13) {
        If ($key.virtualKeycode -eq 8) {
            # Backspace handling
            If ($host.ui.rawui.get_cursorPosition().X -gt $beginCursorPos.X) {
                $charArray.Add($key.Character) | out-null
                Write-host -nonewline $key.Character
                $cursor = $host.ui.rawui.get_cursorPosition()
                write-host -nonewline " "
                $host.ui.rawui.set_cursorPosition($cursor)
            }
        } ElseIf ($key.VirtualKeyCode -eq 27) {
            # Escape handling
            $count = $host.ui.rawui.get_cursorPosition().X - $beginCursorPos.X
            $host.ui.rawui.set_cursorPosition($beginCursorPos)
            1..$count | Foreach-Object { Write-Host -NoNewline " " }
            $host.ui.rawui.set_cursorPosition($beginCursorPos)
            $charArray.Clear()
        } Else {
            # Regular character handling
            $charArray.Add($key.Character) | out-null
            Write-host -nonewline $key.Character
        }
        $key = $host.ui.rawui.readkey("NoEcho,IncludeKeyUp")
    }
    Write-Host ""

    # Find the index of backspace char and pop the item to the left 
    # of it and the backspace char item. Repeat until no more backspace chars
    # exists
    while(($bpos = $charArray.IndexOf([char]"`b")) -ge 0) {
        $charArray.RemoveAt($bpos)
        $charArray.RemoveAt($bpos-1)
    }

    $finalString = -join $charArray
    return $finalString
}
