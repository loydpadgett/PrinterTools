class Snapshot {
    #snapshot properties
    [string]$Server;
    [string]$Printer;
    [string]$

    Snapshot(
    [string]$s,
    [string]$p,
    [string]$vf
    ){
    $this.Server = $s
    $this.Vm = $v
    $this.Vmfolder = $vf
    }
