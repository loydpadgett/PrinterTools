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
class UserAction {
    #action properties
    #use class for variable validation to determine what needs to be done
    [ValidateNotNullOrEmpty()][string]$Flag
    [string]$Action
    
    UserAction(
    [string]$f,
    [string]$a
    ){
        $this.Flag = $f
        $this.Action.Where({$_.Action -ilike "network|local"} -eq 0) = $a
    }
}