class Printer {
    #printer properties

    [ValidateNotNullOrEmpty()][string]$Server
    [string]$Printer
    [string]$Network
    #use method for variable validation and error control 
    Printer(
    [string]$s,
    [string]$p,
    [string]$n
    ){
        $this.Server = $s,
        $this.Printer = $p,
        $this.Network = $n
    }
}
class UserAction {
    #action properties
    #use class for variable validation to determine what needs to be done
    [ValidatePattern('^[Ll]|^[Ii]|^[Dd]|^[Tt]')][string]$Action
    #[ValidatePattern('^net[wo?]|^loc[a?]')][string]$Action
    
    UserAction(
    #[string]$f,
    [string]$a
    ){
    #    $this.Flag = $f
        $this.Action = $a
    }
}