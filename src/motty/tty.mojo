from collections import Optional
from termios import Termios, tcgetattr, tcsetattr, set_raw, set_cbreak, STDIN, TCSADRAIN

# TTY State modes
alias raw = "RAW"
alias cbreak = "CBREAK"


@value
@register_passable("trivial")
struct TTY[mode: Optional[StringLiteral] = None]():
    var fd: Int32
    var original_state: Termios

    fn __init__(inout self) raises:
        self.fd = STDIN
        self.original_state = tcgetattr(self.fd)
        if not mode:
            return
        
        constrained[
            mode.value() == raw or
            mode.value() == cbreak,
            "Invalid mode, must be RAW or CBREAK. Received: " + mode.value()
        ]()
        if mode.value() == raw:
            _ = set_raw(self.fd)
        elif mode.value() == cbreak:
            _ = set_cbreak(self.fd)
        else:
            raise Error(String("Invalid mode: ") + mode.value())
    
    fn close(inout self) raises:
        tcsetattr(self.fd, TCSADRAIN, self.original_state)
    
    fn __enter__(self) -> Self:
        return self

    fn __exit__(inout self) raises:
        self.close()
