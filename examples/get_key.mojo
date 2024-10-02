import termios
from termios import Termios, tcsetattr, tcgetattr, set_raw
from motty import TTY, raw


fn get_key_unix() raises -> String:
    var key: String = ""
    with open("/dev/tty", "r") as stdin:
        var bytes = stdin.read_bytes(1)
        key = chr(int(bytes[0]))

    return key


fn get_key_tty() raises -> String:
    print("Press c to exit.")
    var k: String = ""
    with TTY[raw]() as tty:
        while True:
            k = get_key_unix()
            if k == "c":
                break

    return k

fn main() raises:
    print(get_key_tty())
