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
        .\printConfigurator.ps1 -printer <printerName> -action display -flag <install> <list> <delete>
#>
param(
        [string]$SERVER,       
        $printer = [string]'0',
        [string]$flag = 'list'
)
. .\printerObjects.ps1
#create objects and apply attributes
$uAct = [UserAction]::new($flag)
$uPrinter = [Printer]::new($Server,$printer)
function DisplayPrinters{
    $printerlist=Get-Printer
    $printerlist | Where-Object {$_.Type -notlike "Local"} | `
    Select-Object -Property Name, ComputerName, DriverName
    }
    #perform specific action when 'display' keyword is used
function AddPrinter{
    #make sure case is capped
    $PrinterFormatted = "$uPrinter.printer".ToUpper()
    [bool]$printerInstalled = $false
    #use a loop to verify the printer is either already installed/skip or 
    do {
        if(Get-Printer | Where-Object {$_.Name -ilike "*$uPrinter.printer*"}){
            Write-Output "*******$uPrinter.printer has been successfully installed*******" -NoEnumerate
            $printerInstalled = $true
            Break
        }
        else{
            #logic-set $printerInstalled to false and then loop to the above
            #to check that the printer is installed, rather than making
            #redundant code.
            Add-Printer -ConnectionName "\\$SERVER\$PrinterFormatted"
            Get-Printer | Where-Object {$_.Name -ilike "*$uPrinter.printer*"}
            $printerInstalled = $false
            Continue 
        }
    } until ($printerInstalled = $true)
}
function DeletePrinter{
    if ($printer -is [string]){
            #make sure case is capped
                $PrinterFormatted = "$uPrinter.printer".ToUpper()
            [bool]$printerInstalled = $true
            #printer should be installed by default
        do {
            if(Get-Printer | Where-Object {$_.Name -ilike "*$printer*"}){
                Remove-Printer -Name "\\$SERVER\$PrinterFormatted"
                Write-Output "\\$SERVER\$printer has been successfully Removed."
                $printerInstalled = $fals
                Break
            }
            else{
                Write-Output "*******$printer is not installed*******"
                $printerInstalled = $false
                Break
            }
        } until ($printerInstalled = $false)
    }     
}
switch ($uAct.Flag) {
    install {AddPrinter}
    #printers, drivers, ports
    list {DisplayPrinters}
    #printers, drivers, ports, Type connection, ip?
    delete {DeletePrinter}
    Default {DisplayPrinters}
}
