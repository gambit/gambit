;; 'define-type'-like functionality for Termite
;;
;; Mutable record created with this are implemented as processes.

(define-macro (define-termite-type type id tag . fields)

  (define (symbol-append . symbols)
    (string->symbol
     (apply
      string-append
      (map symbol->string symbols))))
  
  (define (make-maker type)
    (symbol-append 'make '- type))
  
  (define (make-getter type field)
    (symbol-append type '- field))
  
  (define (make-setter type field)
    (symbol-append type '- field '-set!))
  
  (if (not (eq? id id:))
      (error "id: is mandatory in define-termite-type"))
  
  (let* ((maker (make-maker type))
         (getters (map (lambda (field) 
                         (make-getter type field)) 
                       fields))
         (setters (map (lambda (field) 
                         (make-setter type field)) 
                       fields))
         
         (internal-type (gensym type))
         (internal-maker (make-maker internal-type))
         (internal-getters (map (lambda (field) 
                                  (make-getter internal-type field))
                                fields))
         (internal-setters (map (lambda (field)
                                  (make-setter internal-type field))
                                fields))
         
         (facade-maker (gensym maker))
         (plugin (gensym (symbol-append type '-plugin)))
         
         (pid (gensym 'pid)))
    
    `(begin
       (define-type ,type
         id: ,tag
         constructor: ,facade-maker
         unprintable:
         ,pid)
       
       (define-type ,internal-type
         ,@fields)
       
       (define ,plugin
         (make-server-plugin
          ;; init
          (lambda (args)
            (apply ,internal-maker args))
          ;; call
          (lambda (term state)
            (match term
              ,@(map (lambda (getter internal-getter)
                       `(',getter (values (,internal-getter state) state)))
                     getters
                     internal-getters)))
          ;; cast
          (lambda (term state)
            (match term
              ,@(map (lambda (setter internal-setter)
                       `((',setter x) (,internal-setter state x) state))
                     setters
                     internal-setters)))
          ;; terminate
          (lambda (reason state)
            (void))))
       
       (define (,maker ,@fields)
         (,facade-maker (server:start ,plugin (list ,@fields) name: ',type)))
       
       ,@(map (lambda (getter)
                `(define (,getter x)
                   (server:call (,(make-getter type pid) x) 
                                ',getter)))
              getters)

       ,@(map (lambda (setter)
                `(define (,setter x value)
                   (server:cast (,(make-getter type pid) x) 
                                (list ',setter value))))
              setters))))
