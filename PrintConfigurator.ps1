﻿<# 
    .Synopsis
        Add whatever printer is added per argument 
        or print installed printers
        based on input from user.
    .Description
        Uses Add-Printer and WSD protocol to add from print01.ua.lan 
        Author: Loyd Padgett
        Date:   August 31st, 2020
    .Example
        .\printConfigurator.ps1 -printer <printerName> -action display -flag all, install,
#>
param(
        [string]$SERVER,       
        $printer = [string]'0',
        [string]$flag = 'list'
)
. .\printerObjects.ps1
#$NewSnap = [Snapshot]::new($server,$vm,$vmFolder)
$uAct = [UserAction]::new($flag)
#$uAct.Flag = $uAct.Exec
#try catch after this for error control  
function DisplayPrinters{
    $printerlist=Get-Printer
    if($uAct.Flag="list"){
        switch($uAct.Flag)
        {
            list
            #default is to search all printers
            {
                $printerlist | Where-Object {$_.Type -notlike "Local"} | `
                Select-Object -Property Name, ComputerName, DriverName
            }    
        }
    }
}
    #perform specific action when 'display' keyword is used
function AddPrinter{
    if ($printer -is [string]){
        #make sure case is capped
        $PrinterFormatted = "$printer".ToUpper()
        #is printer installed?
        [bool]$printerInstalled = $false
        do {
            if(Get-Printer | Where-Object {$_.Name -ilike "*$printer*"}){
                Write-Output "*******$printer is already installed********" -NoEnumerate
                $printerInstalled = $true
                Break
            }
            else{
                Add-Printer -ConnectionName "\\$SERVER\$PrinterFormatted"
                Get-Printer | Where-Object {$_.Name -ilike "*$printer*"}
                Write-Output "$printer has been successfully installed."
                $printerInstalled = $true
                Break
            }
        } until ($printerInstalled = $true)
        
    } 
    else {
        Write-Output "Please enter a correctly formatted printer."
    }
}
function AddServerPrinter{
    
}
function DeletePrinter{
    if ($printer -is [string]){
        #make sure case is capped
        $PrinterFormatted = "$printer".ToUpper()
        [bool]$printerInstalled = $true
        #printer should be installed by default
        do {
            if(Get-Printer | Where-Object {$_.Name -ilike "*$printer*"}){
                Remove-Printer -Name "\\$SERVER\$PrinterFormatted"
                Write-Output "\\$SERVER\$printer has been successfully Removed."
                $printerInstalled = $false
                Break
            }
            else{
                Write-Output "*******$printer is not installed*******"
                $printerInstalled = $false
                Break
            }
        } until ($printerInstalled = $false)
        
    } 
    else {
        Write-Output "Please enter a correctly formatted printer."
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
