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
    [int]$Exec
    [string]$Flag
    UserAction(
        [int]$eXEC = 0..2, 
        [string]$fLAG
    ){
        $this.Flag = $eXEC
        $this.Exec = $fLAG
    }
}