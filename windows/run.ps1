param(
[Parameter(Position=0)]
[ValidateSet("Left", "Right")]
$MouseButton="Left"
#$KBButton ##https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes
)

begin{

    Read-Host "Make sure the game is running first and you are at the AFK spot then press Enter or Ctrl+C to exit"

switch ($MouseButton) {
    "Left" {$MouseButtonInt = 1}
    "Right" {$MouseButtonInt = 2}
}

}

process{
    $processes = get-process -Name *java* | ?{[string]::IsNullOrEmpty($_.MainWindowTitle) -eq $false} | sort CPU -descending


    if ($processes.count -gt 1) {

        $list = @()

        foreach($proc in $processes){
            
            $list += "$($proc.Id) - $($proc.MainWindowTitle)"
            
        }
        $list
        $selection = Read-Host "Select the window by Id"
        $process = $processes | ?{$_.id -eq $selection}
    }
    else{
        $process = $processes
    }

$targetprocess = $process

try{
    pip install -r .\requirements.txt
    
    write-host "$($targetprocess.MainWindowTitle) - press Ctrl+C or close the window to exit"
    $host.ui.RawUI.WindowTitle = "AFK $MouseButton Clicker - $($targetprocess.MainWindowTitle) - press Ctrl+C to exit"

    $start = get-date
    
    #run python process in the background \ minimized
    $pythonproc = Start-Process -FilePath python -ArgumentList ".\Main.py -p $($targetprocess.id) -m $MouseButtonInt" -Wait:$false -PassThru -WindowStyle minimized

    do {
        $process = get-process -id $targetprocess.id
        cls
        Write-host "Start:" $Start
        write-host "AFK Time:"
        (get-date) - $start | select Seconds,Minutes,Hours,Days | ft
        Write-host "Press Ctrl+C to exit"
        start-sleep -seconds 5
    }
        until ($process -eq $null)
    }
        catch{write-error $_}
        
        finally {
            #ensure python process closes when script exits    
            stop-process -id $pythonproc.id;
            cls
            #AFK time summary
            # date displays mm/dd for some reason
            Write-Host "Total AFK Time: `n$((get-date) - $start | select Seconds,Minutes,Hours,Days | ft | out-string)"
            

            }
    }

end{}