# Copyright (c) 2024 by Macon Gambill, all rights reserved.
/^<dt class="deftypefnx\{0,1\}[" ].*<strong class="def-name">/ {
    s/\(<strong class="def-name"\)/<span class="def-paren">\&#x0028;<\/span>\1/
    s/\(<a class="copiable-link"\)/<span class="def-paren">\&#x0029;<\/span>\1/
}
