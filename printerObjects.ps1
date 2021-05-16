class Snapshot {
    #snapshot properties
    [string]$Server;
    [string]$Printer;
    [int]$Action
    [string]$Flag
    #use class for variable validation and error control 
    Snapshot(
    [string]$s,
    [string]$p,
    [int]$a,
    [string]$f
    ){
    $this.Server = $s
    $this.Printer = $p
    $this.Action = $a
    $this.Flag = $f
    }
