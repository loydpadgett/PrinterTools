class Printer {
    #printer properties
    [string]$Server
    [ValidateNotNullOrEmpty()][string]$Printer
    [string]$ConnType
    #use method for variable validation and error control 
    Printer(
    [string]$s,
    [string]$p,
    [string]$c 
    ){
        $this.Server = $s
        $this.Printer = $p
        $this.ConnType = $c 
    }
}
class UserAction {
    #action properties
    #use class for variable validation to determine what needs to be done
    #use assoc array to match user selections
    [string]$Exec
    [string]$Flag
    UserAction(
        $e,
        [string]$f
    ){
        $this.Exec = $e
        $this.Flag = $f
    } 
    [string]GetExecMethod(){
        return $this.Flag
    }

}