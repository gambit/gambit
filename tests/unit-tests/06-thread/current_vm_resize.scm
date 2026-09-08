(include "#.scm")

(let* ((initial-count (##current-vm-processor-count))
       (resized-count (if (= initial-count 1) 4 1)))
  (test-eqv 0 (##cvmr resized-count))
  (let ((actual-count (##current-vm-processor-count)))
    (test-assert (or (= actual-count initial-count)
                     (= actual-count resized-count)))
    (if (= actual-count resized-count)
        (begin
          (test-eqv 0 (##cvmr initial-count))
          (test-eqv initial-count (##current-vm-processor-count))))))
