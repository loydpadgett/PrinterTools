<# 
    .Synopsis
        Add whatever printer is added per argument 
        or print installed printers
        based on input from user.
        ***PRINTER MUST EXIST ON REMOTE SERVER***
    .Description
        Installs, Lists, and Deletes printer from remote Windows print server. 
        TODO: Add print driver list function and a choose protocol for add function
        Author: Loyd Padgett
        Date:   August 31st, 2020
    .Example
    The Printer Configurator can do the following tasks to install printers. 

        List Local Installed Printers
        .\printConfigurator.ps1 -server <serverName> -flag <list> -conn <local>

        List Network Installed Printers
        .\printConfigurator.ps1 -server <serverName> -flag <list> -conn <network>

        Install Network Printers
        .\printConfigurator.ps1 -server <serverName> -printer <printerName> -flag <install>

        Delete Local Printers
        .\printConfigurator.ps1 -server <serverName> -printer <printerName> -flag <delete>


#>
param(
        [string]$server,       
        [string]$printer,
        [string]$flag = 'list',
        #[string]$action = 'local',
        [string]$conn = 'local'
)
. .\printerObjects.ps1
#create objects and apply attributes
$uAct = [UserAction]::new($flag,$conn)
$uPrinter = [Printer]::new($Server,$printer)    
$PrinterFormatted = $uPrinter.Printer.ToUpper()
function DisplayPrinters{
    #what do you want to display? local or network?
    function LocalPrinter {
        $printerlist = Get-Printer | Where-Object {$_.Type -notlike "Local"} | `
        Select-Object -Property Name, ComputerName, DriverName
        Write-Output $printerlist
    }
    function NetworkPrinter {
        $printerlist = Get-Printer -ComputerName $server | Where-Object {$_.Name -notlike "*Microsoft*"} | `
        Select-Object -Property Name, ComputerName, DriverName
        Write-Output $printerlist
    }
   switch ($uAct.Action) {
        local { LocalPrinter }
        network { NetworkPrinter }
        Default { LocalPrinter }
    }  
}
function AddPrinter{
    #make sure case is capped
    [bool]$printerInstalled = $false
    # use a loop to verify the printer is either already installed/skip or 
    do {
        # verify printer isn't locally installed. 
        if(Get-Printer | Where-Object {$_.Name -ilike "*$printer*"} | Where-Object{$_.Name -notlike "Local"}){
            Write-Output "***************************************************************" -NoEnumerate
            Write-Output "*******$uPrinter.printer has been successfully installed*******" -NoEnumerate
            Write-Output "***************************************************************" -NoEnumerate
            $printerInstalled = $true
        }
        else
        {
            Add-Printer -ConnectionName "\\$server\$PrinterFormatted" 
            $printerInstalled = $false
            Continue 
        }
    } until ($printerInstalled = $true)
}
function TestPrinter{
    #make sure case is capped
    [bool]$printSent = $false
    #use a loop to verify the printer is either already installed/skip or 
    do {
        if(Get-Printer | Where-Object {$_.Name -ilike "*$printer*"}){
            $PrintMessage = "MESSAGE FROM OTIS: ****\\$server\$PrinterFormatted has been installed, this is a test print to verify connectivity"
            $PrintMessage | Out-Printer -Name "\\$Server\$PrinterFormatted"
            $printSent = $true
        Break
        }
        else
        {
            Write-Output "No printer found by that name!"
            $printSent = $false
        Break
        }
    } until ($printSent = $true)
}
function DeletePrinter{
    #make sure case is capped
    [bool]$printerUninstalled = $false
    #printer should be installed by default
    do {
        if(Get-Printer | Where-Object {$_.Name -ilike "*$printer*"}){
            Remove-Printer -Name "\\$server\$PrinterFormatted"
            Write-Output "********$printer********* has been successfully Removed.
            
            
            "
            $printerUninstalled = $true
        } 
    } until ($printerUninstalled = $true)
}
switch ($uAct.Flag) {
    install { AddPrinter }
    list { DisplayPrinters }
    delete { DeletePrinter }
    test { TestPrinter }
    Default { DisplayPrinters }
}