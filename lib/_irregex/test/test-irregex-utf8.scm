(test-begin "utf8")

(test-assert (irregex-search "(?u:<..>)" "<漢字>"))
(test-assert (irregex-search "(?u:<.*>)" "<漢字>"))
(test-assert (irregex-search "(?u:<.+>)" "<漢字>"))
(test-assert (not (irregex-search "(?u:<.>)" "<漢字>")))
(test-assert (not (irregex-search "(?u:<...>)" "<漢>")))

(test-assert (irregex-search "(?u:<[^a-z]*>)" "<漢字>"))
(test-assert (not (irregex-search "(?u:<[^a-z]*>)" "<漢m字>")))
(test-assert (irregex-search "(?u:<[^a-z][^a-z]>)" "<漢字>"))
(test-assert (irregex-search "(?u:<あ*>)" "<あ>"))
(test-assert (irregex-search "(?u:<あ*>)" "<ああ>"))
(test-assert (not (irregex-search "(?u:<あ*>)" "<あxあ>")))

(test-assert (irregex-search "(?u:<[あ-ん]*>)" "<あん>"))
(test-assert (irregex-search "(?u:<[あ-ん]*>)" "<ひらがな>"))
(test-assert (not (irregex-search "(?u:<[あ-ん]*>)" "<ひらgがな>")))
(test-assert (not (irregex-search "(?u:<[^あ-ん語]*>)" "<語>")))

(test-assert (irregex-search "(?u:<[^あ-ん]*>)" "<abc>"))
(test-assert (not (irregex-search "(?u:<[^あ-ん]*>)" "<あん>")))
(test-assert (not (irregex-search "(?u:<[^あ-ん]*>)" "<ひらがな>")))
(test-assert (irregex-search "(?u:<[^あ-ん語]*>)" "<abc>"))
(test-assert (not (irregex-search "(?u:<[^あ-ん語]*>)" "<あん>")))
(test-assert (not (irregex-search "(?u:<[^あ-ん語]*>)" "<ひらがな>")))
(test-assert (not (irregex-search "(?u:<[^あ-ん語]*>)" "<語>")))

(test-assert (irregex-search "(?u:[é])" "é"))
(test-assert (not (irregex-search "(?u:[é])" "e")))
(test-assert (not (irregex-search "(?u:[一二])" "三四")))

(test-end)
