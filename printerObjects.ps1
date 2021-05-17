class Printer {
    #printer properties
    [ValidateNotNullOrEmpty()][string]$Server
    [ValidateNotNullOrEmpty()][string]$Printer
    #use method for variable validation and error control 
    Printer(
    [string]$s,
    [string]$p
    ){
        $this.Server = $s
        $this.Printer = $p
    }
}
class Action {
    #action properties
    #use class for variable validation to determine what needs to be done
    [int]$Exec
    [string]$Flag
    Action(
        [int]$f = 0..2, 
        [string]$e
    ){
        $this.Flag = $f
        $this.Exec = $e
    }
}