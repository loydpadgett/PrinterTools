﻿<# 
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
        .\printConfigurator.ps1 -SERVER <serverName> -printer <printerName> -action display -flag <install> <list> <delete>
#>
param(
        [string]$server = 'local',       
        [string]$printer,
        [string]$action = 'list',
        [string]$conn = 'local'
)
. .\printerObjects.ps1
#create objects and apply attributes
$uAct = [UserAction]::new($action)
$uPrinter = [Printer]::new($server,$printer,$conn)    
$PrinterFormatted = $uPrinter.Printer.ToUpper()
function DisplayPrinters{
    #this pipeline moves over multiple lines, fyi
    function LocalPrinter {
        $printerlist = Get-Printer | Where-Object {$_.Type -notlike "Local"} | `
        Select-Object -Property Name, ComputerName, DriverName
        Write-Output $printerlist -ErrorAction Stop
    }
    function NetworkPrinter {
        $printerlist = Get-Printer -ComputerName $uPrinter.Server | Where-Object {$_.Name -notlike "*Microsoft*"} | `
        Select-Object -Property Name, ComputerName, DriverName
        Write-Output $printerlist -ErrorAction Stop
    }
   switch ($uPrinter.Network) {
        local { LocalPrinter }
        network { NetworkPrinter }
        Default { LocalPrinter }
    }  
}
    #perform specific action when 'display' keyword is used
function AddPrinter{
    #make sure case is capped
    [bool]$printerInstalled = $false
    #use a loop to verify the printer is either already installed/skip or 
    do {
        if(Get-Printer | Where-Object {$_.Name -ilike "*$printer*"} | Where-Object{$_.Name -notlike "Local"}){
            Write-Output "*******$uPrinter.printer has been successfully installed*******" -NoEnumerate
            $printerInstalled = $true
            Break
        }
        else
        {
            Add-Printer -ConnectionName "\\$SERVER\$PrinterFormatted" 
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
            $PrintMessage = "MESSAGE FROM OTIS: ****\\$SERVER\$PrinterFormatted has been installed, this is a test print to verify connectivity"
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
            Remove-Printer -Name "\\$SERVER\$PrinterFormatted"
            Write-Output "********$printer********* has been successfully Removed.  
            
            
            "
            $printerUninstalled = $true
        } 
    } until ($printerUninstalled = $true)
}
switch ($uAct.action) {
    install { AddPrinter }
    list { DisplayPrinters }
    delete { DeletePrinter }
    test { TestPrinter }
    Default { DisplayPrinters }
}