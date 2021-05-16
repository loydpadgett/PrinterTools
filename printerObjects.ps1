class Snapshot {
    #snapshot properties
    [string]$Server;
    [string]$Printer;
    [int]$action
    [string]$flag
    #use class for variable validation and error control 
    Snapshot(
    [string]$s,
    [string]$p,
    ){
    $this.Server = $s
    $this.Vm = $v
    }
