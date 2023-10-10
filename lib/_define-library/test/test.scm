;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2014-2023 by Marc Feeley and Frédéric Hamel, All Rights Reserved.

;;;============================================================================

(import _test)

(define (gsi . arguments)
  (let* ((port
          (open-process
           (list path: (path-expand "gsi-script" (path-expand "~~bin"))
                 arguments: arguments)))
         (output
          (read-line port #f)))
    (close-port port)
    output))

(define (search path)
  (string-append "search=" path))

(define (create-files-in-dir dir files)

  (define (create-files dir files)
    (create-directory dir)
    (for-each (lambda (tree) (create dir tree)) files))

  (define (create dir tree)
    (let ((name (car tree))
          (rest (cdr tree)))
      (if (and (pair? rest) (string? (car rest)))
          (with-output-to-file
              (path-expand name dir)
            (lambda ()
              (for-each display rest)))
          (create-files (path-expand name dir) rest))))

  (delete-dir dir)
  (create-files dir files))

(define (delete-dir path)
  (with-exception-catcher
   (lambda (e)
     #f)
   (lambda ()
     (delete-file-or-directory path #t))))

(define (create-common-files)
  (let* ((test-dir (create-temporary-directory))
         (lib-dir (path-expand "lib" test-dir)))
    (create-files-in-dir
      lib-dir
      '(("testing-env.sld"
         "(define-library (testing-env)\n"
         "  (export"
         "    define lambda\n"
         "    let let*\n"
         "    + - * /\n"
         "    display newline)\n"
         "  (namespace \"\"))")))
    (values test-dir lib-dir)))

(define (test1 dir lib-dir)
  (let ((test1-dir (path-expand "test1" dir)))
    (create-files-in-dir
      test1-dir
      '(("foo.scm"
         "(display \"hello!\\n\")")
        ("test1.sld"
         "(define-library (test1)\n"
         "  (import (scheme write))\n"
         "  (include \"foo.scm\"))\n")))

    (test-equal "hello!\n"
                (gsi (string-concatenate
                       (list "-:debug=-,search="
                             (search lib-dir)
                             (search dir)
                             (search (path-expand "~~lib")))
                       ",") "test1"))
    (delete-dir test1-dir)))

(define (test2 dir lib-dir)
  (let* ((root (path-expand "test2" dir))
         (userlib-dir (path-expand "userlib" root))
         (main-file (path-expand "test.scm" root)))

    (create-files-in-dir
      root
      '(("test.scm"
         "(import (A))\n"
         "(main)\n")
        ("userlib"
         ("A.sld"
          "(define-library (A)\n"
          "  (export main)\n"
          "  (import (testing-env))\n"
          "  (begin\n"
          "    (define (main)\n"
          "      (display \"[A] main\\n\"))))\n"))))
    (test-equal "[A] main\n"
                (gsi (string-concatenate
                       (list "-:debug=-,search="
                             (search lib-dir)
                             (search userlib-dir)
                             (search (path-expand "~~lib")))
                       ",") main-file))
    (delete-dir root)))

(define (test3 dir lib-dir)
  (let* ((root (path-expand "test3" dir))
         (userlib-dir (path-expand "userlib" root))
         (main-file (path-expand "test.scm" root)))
    (create-files-in-dir
      root
      '(("test.scm"
         "(import (A))\n"
         "(main)\n")
        ("userlib"
         ("A"
          ("B1"
           ("B1.sld"
            "(define-library (A/B1)\n"
            "  (export main)\n"
            "  (import (testing-env))\n"
            "  (begin\n"
            "    (define (main)\n"
            "      (display \"[A/B1] main\\n\"))))\n"))
          ("B2"
           ("B2.sld"
            "(define-library (A B2)\n"
            "  (export main)\n"
            "  (import (testing-env))\n"
            "  (begin\n"
            "    (define (main)\n"
            "      (display \"[A/B2] main\\n\"))))\n"))
          ("C"
           ("C.sld"
            "(define-library (A C)\n"
            "  (export main)\n"
            "  (import (testing-env)\n"
            "          (rename (.. B1)\n"
            "                  (main A/B1:main))\n"
            "          (prefix (.. B2)\n"
            "                  A/B2-))\n"
            "  (begin\n"
            "    (define (main)\n"
            "      (A/B1:main)\n"
            "      (A/B2-main)\n"
            "      (display \"[A/C] main\\n\"))))\n"))
          ("A.sld"
           "(define-library (A)\n"
           "  (export main)\n"
           "  (import (testing-env)\n"
           "          (prefix (. C) A/C-))\n"
           "  (begin\n"
           "    (define (main)\n"
           "      (A/C-main)\n"
           "      (display \"[A] main\\n\"))))\n")))))

    (test-equal "[A/B1] main\n[A/B2] main\n[A/C] main\n[A] main\n"
                (gsi (string-concatenate
                       (list "-:debug=-,search="
                             (search lib-dir)
                             (search userlib-dir)
                             (search (path-expand "~~lib")))
                       ",")
                     main-file))
    (delete-dir root)))

(define (test4 dir lib-dir)
  (let* ((root (path-expand "test4" dir))
         (userlib-dir (path-expand "userlib" root))
         (main-file (path-expand "test.scm" root)))
    (create-files-in-dir
      root
      '(("test.scm"
         "(import (Module-C))\n"
         "(main)\n")
        ("_setup_.scm"
         "(define-module-alias (Module-C) (A C))\n")
        ("userlib"
         ("A"
          ("B1"
           ("B1.sld"
            "(define-library (A/B1)\n"
            "  (export main)\n"
            "  (import (testing-env))\n"
            "  (begin\n"
            "    (define (main)\n"
            "      (display \"[A/B1] main\\n\"))))\n"))
          ("B2"
           ("B2.sld"
            "(define-library (A B2)\n"
            "  (export main)\n"
            "  (import (testing-env))\n"
            "  (begin\n"
            "    (define (main)\n"
            "      (display \"[A/B2] main\\n\"))))\n"))
          ("C"
           ("C.sld"
            "(define-library (A C)\n"
            "  (export main)\n"
            "  (import (testing-env)\n"
            "          (rename (.. B1)\n"
            "                  (main A/B1:main))\n"
            "          (prefix (.. B2)\n"
            "                  A/B2-))\n"
            "  (begin\n"
            "    (define (main)\n"
            "      (A/B1:main)\n"
            "      (A/B2-main)\n"
            "      (display \"[A/C] main\\n\"))))\n"))))))

    (test-equal "[A/B1] main\n[A/B2] main\n[A/C] main\n"
                (gsi (string-concatenate
                       (list "-:debug=-,search="
                             (search lib-dir)
                             (search userlib-dir)
                             (search (path-expand "~~lib")))
                       ",") main-file))
    (delete-dir root)))

(let-values (((test-dir lib-dir) (create-common-files)))
  (test1 test-dir lib-dir)
  (test2 test-dir lib-dir)
  (test3 test-dir lib-dir)
  (test4 test-dir lib-dir)
  (delete-dir test-dir))

;;;============================================================================
