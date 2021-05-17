class Printer {
    #printer properties
    [string]$Server
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
class Action {
    #action properties
    #use class for variable validation to determine what needs to be done
    [int]$Exec
    [string]$Flag
    Action(
        [int]$E = 0..2,
        [string]$F = @('add', 'delete', 'list')
    ){
    if($this.Exec -ge 3)
    {
      #this should limit error 
    } elseif ($this.Exec -le 2)
    {
        $this.Exec = $E
    }
    $this.Flag = $F
    }
}