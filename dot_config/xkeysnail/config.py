from xkeysnail.transform import *

define_multipurpose_modmap({
    Key.SPACE: [Key.SPACE, Key.LEFT_SHIFT],
    Key.LEFT_ALT: [Key.MUHENKAN, Key.LEFT_ALT],
    Key.RIGHT_ALT: [Key.HENKAN, Key.RIGHT_ALT]
})
define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL,
})
