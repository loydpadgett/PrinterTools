class Printer {
    #printer properties
    [ValidatePattern('[\w\d].[\w].[\w]')][string]$Server
    [string]$Printer
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
    [ValidatePattern('^list$|^install$|^delete$|^test$')][string]$Flag
    [ValidatePattern('^net[wo?]|^loc[a?]')][string]$Action
    
    UserAction(
    [string]$f,
    [string]$a
    ){
        $this.Flag = $f
        $this.Action = $a
    }
}