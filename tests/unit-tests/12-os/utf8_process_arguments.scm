(include "../#.scm")

(check-eqv?
 (call-with-input-process '(path: "echo" arguments: ("♞")) read-char)
 #\♞)

(check-eqv?
 (call-with-input-process '(path: "echo" arguments: (#u8(#xE2 #x99 #x9E))) read-char)
 #\♞)
