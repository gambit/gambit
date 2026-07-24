(test-begin "pcre")

(test-assert (irregex-search "\\x41," "A,"))
(test-assert (irregex-search "\\x{0041}" "A,"))

(test-assert (irregex-search "<[[:alpha:]]+>" "<abc>"))
(test-assert (not (irregex-search "<[[:alpha:]]+>" "<ab7c>")))
(test-assert (irregex-search "<[[^:alpha:]]+>" "<123>"))
(test-assert (not (irregex-search "<[[^:alpha:]]+>" "<12a3>")))
(test-error (irregex-search "<[[=alpha=]]+>" "<abc>"))
(test-error (irregex-search "<[[.alpha.]]+>" "<abc>"))

(test-assert (irregex-match "\\Q.*\\+" ".*\\+"))
(test-assert (irregex-match "\\Q.*\\+\\E" ".*\\+"))
(test-assert (not (irregex-match "\\Q.*\\+\\E" "x*\\+")))
(test-assert (irregex-match "\\Q.*\\" ".*\\"))

;;;; not added until perl 5.10 - implementation is too ugly and this
;;;; is too silly of a feature to keep
;; (test-assert (irregex-search "(sens|respons)e and (?1)ibility" "sense and responsibility"))

(test-end)


