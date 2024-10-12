# Copyright (c) 2024 by Macon Gambill, All Rights Reserved.
/^<dt class="deftypefnx\{0,1\}[" ].*<strong class="def-name">/ {
    s/\(<strong class="def-name"\)/<span class="sexp-paren">(<\/span>\1/
    s/\(<a class="copiable-link"\)/<span class="sexp-paren">)<\/span>\1/
}
