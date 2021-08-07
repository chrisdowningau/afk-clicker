param(
[Parameter(Position=0)]
[ValidateSet("Left", "Right")]
$MouseButton="Left"
#$KBButton ##https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes
)

begin{

Read-Host "Make sure the game is running first and you are at the AFK spot then press Enter or Ctrl+C to exit"

}
process{
$processes = get-process -Name *java* | ?{$_.MainWindowTitle -ne ""}

if ($processes.count -gt 1) {

    $list = @()
    for ($i = 1; $i -lt $processes.Count ; $i++) { 
    
        $list += "$i - $($processes[$i].MainWindowTitle)"
    }

    $selection = Read-Host "Select the window by number: $list"
    $process = $processes[$selection].Id
}
else{
$process = $processes.id
}

write-host "Running for $($process.MainWindowTitle)"
python .\Main.py -p $process.id -m $MouseButton

}

end{
        
}