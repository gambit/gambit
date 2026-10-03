(include "#.scm")

;; The second pair of bounds selects the needle, not just its length.
;; Results are absolute indices in the first string.

(test-eqv 3 (string-contains "banana" "-ana-" 2 6 1 4))
(test-eq #f (string-contains "abc" "abcXYZ" 0 3 3 6))
(test-eqv 2 (string-contains "--abc" "__abc" 2 5 2 5))
(test-eq #f (string-contains "--abc" "__abc" 2 4 2 5))
(test-eqv 5 (string-contains "--abc" "__abc" 5 5 2 2))
(test-eqv 3 (string-contains-ci "bANana" "-AnA-" 2 6 1 4))
(test-eq #f (string-contains-ci "ABC" "abcXYZ" 0 3 3 6))
(test-eqv 2 (string-contains-ci "--aBc" "__AbC" 2 5 2 5))
(test-eq #f (string-contains-ci "--aBc" "__AbC" 2 4 2 5))
(test-eqv 5 (string-contains-ci "--aBc" "__AbC" 5 5 2 2))
