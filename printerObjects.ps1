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
    #use assoc array to match user selections
    $Exec = @{'0'='display';'1'='create';'2'='remove'}
    [string]$Flag
    UserAction(
        $e,
        [string]$f
    ){
        $this.Flag = $e
        $this.Exec = $f
    } 
    [string]GetExecMethod(){
        return @($this.Exec.0..2 | Where-Object -eq $this.Flag)
    }

}