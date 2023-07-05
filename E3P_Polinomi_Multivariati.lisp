;;;; -*- Mode: Lisp -*-
;;;; 866037 Aziani Riccardo
;;;; 869257 Castelli Luca

;;;; Progetto E3P Polinomi Multivariati

;; Funzione fornite dal .pdf

(defun is-varpower (vp)
  (and (listp vp)
       (eq 'v (first vp))
       (let ((p (second vp))
             (v (third vp)))
         (and (integerp p)
              (>= p 0)
              (symbolp v)))))

(defun is-monomial (m)
  (and (listp m)
       (eq 'm (first m))
       (let ((coeff (second m))
             (total-degree (third m))
             (vars-n-powers (fourth m)))
         (and (integerp coeff)
              (integerp total-degree)
              (>= total-degree 0)
              (listp vars-n-powers)
              (every #'is-varpower vars-n-powers)))))

(defun is-polynomial (p)
  (and (listp p)
       (eq 'poly (first p))
       (let ((ms (monomials p)))
         (and (listp ms)
              (every #'is-monomial ms)))))

;; FUNZIONE as-monomial/1

(defun as-monomial (expr)
  (cond ((integerp expr) (if (= expr 0) (list 'M 0 0 '())
                           (list 'M expr 0 nil)))
        ((symbol-letter-p expr) (list 'M 1 1 (list 'V 1 expr)))
        ((symbolp expr) (error "Invalid input. Expected: '(' '*' [coefficient ] var-expt * ')'"))
        (t 
  (if (eq (first expr) '*)
      (as-monomial (cdr expr))
    (cond ((integerp expr) (list 'M expr 0 nil))
          ((listp expr) (let ((coeff (if (integerp (first expr)) (first expr)
                                       1))
                           (vars-n-powers (order-vars-n-powers (get-vars-n-powers expr)))
                           (total-degree (get-total-degree (get-powers (get-vars-n-powers expr)))))
                        (list 'M coeff total-degree vars-n-powers)))
          (t (error "Invalid input. Expected: '(' '*' [coefficient ] var-expt * ')'")))))))
                                              
;; Funzioni di supporto a as-monomial
;; symbol-letter-p/1

(defun symbol-letter-p (letter)
  (if (and (symbolp letter) (= (length (string letter)) 1)) (alpha-char-p (char (string letter) 0))
    nil))

;; get-vars-n-powers/1

(defun get-vars-n-powers (to-parse)
  (if (null to-parse)
      nil
    (let ((head (car to-parse))
          (tail (get-vars-n-powers (cdr to-parse))))
      (cond ((listp head) (if (eq 'expt (first head))
                             (cons (list 'V (third head) (second head)) tail)
                           (cons (list 'V 1 head) tail)))
            ((symbolp head) (cons (list 'V 1 head) tail))
            (t tail)))))

;; get-total-degree/1

(defun get-total-degree (to-sum)
  (if (null to-sum)
      0
      (let ((first-element (car to-sum)))
        (if (integerp first-element)
            (+ first-element (get-total-degree (cdr to-sum)))
            (get-total-degree (cdr to-sum))))))

;; get-powers/1  -  ((V 1 X) (V 1 A) (V 2 Y) (V 3 A)) --> (1 1 2 3)

(defun get-powers (vars-n-powers)
  (mapcar (lambda (sottolista) (get-powers-helper sottolista)) vars-n-powers))


;; get-powers-helper/1

(defun get-powers-helper (sottolista)
  (if (and (listp sottolista) (= (length sottolista) 3))
      (car (cdr sottolista))
      0))

;; order-char/2

(defun order-char (a b)
  (char< (char (string (third a)) 0) (char (string (third b)) 0)))

;; order-char-v2/2

(defun order-char-v2 (a b)
  (char< (char (string a) 0) (char (string b) 0)))

;; order-vars-n-powers/1

(defun order-vars-n-powers (vars-n-powers)
  (sort vars-n-powers #'order-char))


;; FUNZIONE as-polynomial/1

(defun as-polynomial (expr)
 (if (eq expr 0) (cons 'POLY (list nil))
   (if (not (listp expr)) (error "Invalid input. Expected: '(' '+' monomial + ')')")
     (cond ((numberp expr) (as-monomial expr))
           ((symbol-letter-p expr) (as-monomial expr))
           ((eq (car expr) '+) (cons 'POLY (list (order-poly (build-poly expr)))))
           (t (error "Invalid input. Expected: '(' '+' monomial + ')')"))))))

;; Funzioni di supporto a as-polynomial
;; build-poly/1

(defun build-poly (input)
  (if (null input) nil
                  (let ((head (car input))
                        (tail (cdr input)))
                    (cond ((equal head '+) (build-poly tail))
                          (t (cons (as-monomial head) (build-poly tail)))))))

;; order-poly/1

(defun order-poly (to-order)
  (sort to-order #'order-poly-aux))

;; order-poly-aux/1

(defun order-poly-aux (a b)
  (< (third a) (third b)))

;; FUNZIONE pprint-polynomial/1

(defun pprint-polynomial (poly)
  (if (is-polynomial poly) (pprint-polynomial-aux (monomials poly))
    (error "Invalid input. Expected: polynomial")))

;; Funzioni di supporto a pprint-polynomial
;; pprint-polynomial-aux/1 

(defun pprint-polynomial-aux (poly)
  (format t "~a~%" (p-tostring poly)))

;; Funzioni di supporto a pprint-polynomial
;; p-tostring/1

(defun p-tostring (poly)
  (coerce (serialize-p poly) 'string))
                            
;; serialize-p/1 '((M 1 2 (vars-n-powers)) (M 2 5 (vars-n-powers)))

(defun serialize-p (p)
  (if (null p) nil
        (append (serialize-m (car p)) (serialize-p (cdr p)))))
  
;; serialize-m/1 (M 1 2 (vars-n-powers))

(defun serialize-m (m)
  (cond ((> (second m) 0) (if (> (second m) 1) (append (list '#\+ (digit-char (second m)) '#\Space) (coerce (vars-tostring (fourth m)) 'list))
                                               (append (list '#\+ '#\Space) (coerce (vars-tostring (fourth m)) 'list))))
        ((< (second m) 0) (append (list '#\- '#\Space (digit-char (abs (second m))) '#\Space) (coerce (vars-tostring (fourth m)) 'list)))))
  
;; vars-tostring/1 ((V 3 S) (V 3 T) (V 1 X))

(defun vars-tostring (vars-n-powers)
  (if (null vars-n-powers)
      ""
      (let ((head (car vars-n-powers))
            (tail (cdr vars-n-powers)))
        (let ((exponent (second head))
              (variable (third head)))
          (cond ((= exponent 1) (concatenate 'string (symbol-name variable) " " (vars-tostring tail)))
                (t (concatenate 'string (symbol-name variable) "^" (write-to-string exponent) " " (vars-tostring tail))))))))

;; FUNZIONE is-zero/1

(defun is-zero (x)
  (cond ((and (integerp x) (= x 0)) t)
        ((and (is-monomial x) (= (second x) 0) (= (third x) 0)) t)
        ((and (is-polynomial x) (= (length x) 2) (eq (second x) nil)) t)
        (t nil)))

;; FUNZIONE var-powers/1  -  (M 1 2 ((V 1 A) (V 2 B))) --> ((V 1 A) (V 2 B))

(defun var-powers (monomial) 
  (if (is-monomial monomial) (var-powers-aux monomial)
    (error "Invalid input. Expected: monomial")))

;; Funzione di supporto a var-powers
;; var-powers-aux/1

(defun var-powers-aux (monomial)
  (if (is-zero monomial) nil
    (cond ((null monomial) nil)
          ((symbolp (car monomial)) (var-powers-aux (cdr monomial)))
          ((integerp (car monomial)) (var-powers-aux (cdr monomial)))
          ((listp (car monomial)) (car monomial))
          (t nil))))
     
;; FUNZIONE vars-of/1  -  (M 1 2 ((V 1 A) (V 2 B))) --> (A B)

(defun vars-of (monomial)
  (if (is-monomial monomial)
      (cond ((null monomial) nil)
            (t (vars-of-aux (var-powers monomial))))
  (error "Invalid input. Expected: monomial")))
         

;; FUNZIONE vars-of-aux/1  -  ((V 1 A) (V 2 B)) --> (A B)

(defun vars-of-aux (vars-n-powers) 
  (cond ((null (car vars-n-powers)) nil)
        (t (append (list (third (car vars-n-powers))) (vars-of-aux (cdr vars-n-powers))))))

;; FUNZIONE monomial-degree/1  -  (M 1 2 ((V 1 A) (V 2 B))) --> 2

(defun monomial-degree (monomial)
  (if (is-monomial monomial) (third monomial)
    (error "Invalid input. Expected: monomial")))

;; FUNZIONE monomial-coefficient/1  -  (M 1 2 ((V 1 A) (V 2 B))) --> 1

(defun monomial-coefficient (monomial)
  (if (is-monomial monomial) (second monomial)
    (error "Invalid input. Expected: monomial")))

;; FUNZIONE monomials/1  -  (POLY ((M -4 0 NIL) (M 1 2 ((V 1 X) (V 1 Y))))) --> ((M -4 0 NIL) (M 1 2 ((V 1 X) (V 1 Y))))

;; Non faccio un controllo tramite is-polynomial perche con in input un monomio con
;; NIL come VP-list ottengo stack overflow, bypasso con l'if sotto
(defun monomials (poly)
  (if (and (listp poly) (eq (car poly) 'POLY) (= (length poly) 2)) (order-poly (car (cdr poly)))    
    (error "Invalid input. Expected: polynomial")))

;; FUNZIONE coefficients/1  -  (POLY ((M -4 0 NIL) (M 1 2 ((V 1 X) (V 1 Y))))) --> (-4 1)

(defun coefficients (poly)
  (if (is-polynomial poly) (coeff-aux (monomials poly))
    (error "Invalid input. Expected: polynomial")))

;; Funzione di supporto a coefficients
;; coeff-aux/1

(defun coeff-aux (ms)
  (cond ((null ms) nil)
        (t (append (list (second (car ms))) (coeff-aux (cdr ms))))))

;; FUNZIONE variables/1  -  (POLY ((M -4 0 NIL) (M 1 2 ((V 1 X) (V 1 Y))) (M 1 7 ((V 3 S) (V 3 T) (V 1 Y)))))  --> (X Y S T)

(defun variables (poly)
  (if (is-polynomial poly) (let ((result (remove-duplicates (variables-aux (monomials poly)))))
                             (sort result #'order-char-v2))
    (error "Invalid input. Expected: polynomial")))

;; Funzione di supporto a variables
;; variables-aux/1

(defun variables-aux (ms)
  (cond ((null ms) nil)
        (t (append (vars-of (car ms)) (variables-aux (cdr ms))))))

;;FUNZIONE max-degree/1  -  (POLY ((M -4 0 NIL) (M 1 2 ((V 1 X) (V 1 Y))) (M 1 7 ((V 3 S) (V 3 T) (V 1 Y))))) --> 7

(defun max-degree (poly)
  (if (is-polynomial poly)  (apply #'max (get-grades (monomials poly)))
    (error "Invalid input. Expected: polynomial")))

;;FUNZIONE min-degree/1  -  (POLY ((M -4 0 NIL) (M 1 2 ((V 1 X) (V 1 Y))) (M 1 7 ((V 3 S) (V 3 T) (V 1 Y))))) --> 0

(defun min-degree (poly)
  (if (is-polynomial poly) (apply #'min (get-grades (monomials poly)))
    (error "Invalid input. Expected: polynomial")))

;; Funzione di supporto a max-degree e min-degree
;; get-grades/1  -  ((M -4 0 NIL) (M 1 2 ((V 1 X) (V 1 Y))) (M 1 7 ((V 3 S) (V 3 T) (V 1 Y)))) --> (0 2 7)

(defun get-grades (ms)
  (cond ((null ms) nil)
        (t (append (list (third (car ms))) (get-grades (cdr ms))))))

                                                                                                        
;; FUNZIONE poly-plus/2

(defun poly-plus (poly1 poly2)
  (if (is-monomial poly1) (poly-plus (mono-to-poly poly1)  poly2)
    (if (is-monomial poly2) (poly-plus poly1 (mono-to-poly poly2))
      (if (and (is-polynomial poly1) (is-polynomial poly2)) (cons 'POLY (list (remove-zero (order-poly (poly-plus-aux (append (monomials poly1) (monomials poly2)))))))
        (error "Invalid input. Expected: monomials or polynomials")))))

;;FUNZIONE poly-minus/2

(defun poly-minus (poly1 poly2)
  (if (is-monomial poly1) (poly-minus (mono-to-poly poly1) poly2)
    (if (is-monomial poly2) (poly-minus poly1 (mono-to-poly poly2))
      (if (and (is-polynomial poly1) (is-polynomial poly2)) (cons 'POLY (list (remove-zero (order-poly (poly-plus-aux (append (monomials poly1) (change-sign (monomials poly2))))))))
        (error "Invalid input. Expected: monomials or polynomials")))))

;; Funzioni di supporto a poly-plus e poly-minus
;; poly-plus-aux/1

(defun mono-to-poly (monomial)
  (list 'POLY (list monomial)))

(defun poly-plus-aux (ms)
  (cond ((null ms) nil)
        ((null (cdr ms)) ms)
        (t   (cond ((null (car ms)) (poly-plus-aux (cdr ms)))
                   ((null (second (car ms))) (poly-plus-aux (cdr ms)))
                   (t (if (check-vars (car ms)  (cdr ms))
                          (cons (sum-ms (car ms) (cdr ms)) (poly-plus-aux (remove-ms (first ms) (cdr ms))))
                          (cons (car ms) (poly-plus-aux (cdr ms)))))))))

;; change-sign/1

(defun change-sign (ms)
  (cond ((null ms) nil)
        (t (append (list (list 'M (* -1 (second (car ms))) (third (car ms)) (fourth (car ms)))) (change-sign (cdr ms))))))

;; check-vars/2

(defun check-vars (m1 ms2)
  (cond ((null ms2) nil)
        ((equal (var-powers m1) (var-powers (car ms2))) t)
        (t (check-vars m1 (cdr ms2)))))

;; sum-ms/2

(defun sum-ms (m1 ms2)
  (cond ((equal (var-powers m1) (var-powers (car ms2))) (list 'M (+ (second m1) (second (car ms2))) (third m1) (var-powers m1)))
        (t (sum-ms m1 (cdr ms2)))))

;; remove-ms/2

(defun remove-ms (m1 ms2)
  (remove-element (find-monomial-by-vars (var-powers m1) ms2) ms2))

;; remove-element/2

(defun remove-element (element list)
  (cond ((null list) nil)
        ((equal element (car list)) (remove-element element (cdr list)))
        (t (cons (car list) (remove-element element (cdr list))))))
          
;; find-monomial-by-vars/2

(defun find-monomial-by-vars (vp ms)
  (cond ((equal vp (var-powers (car ms))) (car ms))
        (t (find-monomial-by-vars vp (cdr ms)))))

;; remove-zero/1

(defun remove-zero (ms)
  (cond ((null ms) nil)
        ((= (second (car ms)) 0) (remove-zero (cdr ms)))
        (t (cons (car ms) (remove-zero (cdr ms))))))

;; FUNZIONE poly-times/2

(defun poly-times (poly1 poly2)
  (if (and (is-polynomial poly1) (is-polynomial poly2)) (list 'POLY (order-poly (poly-times-aux (monomials poly1) (monomials poly2))))
    nil))

;; Funzioni di supporto a poly-times
;; poly-times-aux/2

(defun poly-times-aux (ms1 ms2)
  (cond ((null ms1) nil)
        ((null (car ms1)) nil)
        (t (append (multiply-one-with-others (car ms1) ms2) (poly-times-aux (cdr ms1) ms2)))))

;; multiply-one-with-others/2

(defun multiply-one-with-others (m1 ms2)
  (cond ((null ms2) nil)
        (t (append (multiply-monos m1 (car ms2)) (multiply-one-with-others m1 (cdr ms2))))))

;; multiply-monos/2

(defun multiply-monos (m1 m2)
  (let ((c1 (second m1))
        (c2 (second m2))
        (td1 (third m1))
        (td2 (third m2))
        (vp1 (fourth m1))
        (vp2 (fourth m2)))
    (if (or (= c1 0) (= c2 0)) (list (list 'M 0 0 nil))
      (list (list 'M (* c1 c2) (+ td1 td2) (build-vars (order-vars-n-powers (append vp1 vp2))))))))

;; build-vars/1

(defun build-vars (vp)
  (cond ((null vp) nil)
        (t (let ((current (car vp))
                 (next (car (cdr vp))))
             (if (equal (third current) (third next)) (append (list (list 'V (+ (second current) (second next)) (third current))) (build-vars (cdr (cdr vp))))
               (append (list current) (build-vars (cdr vp))))))))

;; FUNZIONE poly-val/2

(defun poly-val (poly variable-values)
  (if (is-polynomial poly) (if (= (length (variables poly)) (length variable-values)) (sum-list (poly-val-aux (monomials poly) (vars-n-values (variables poly) variable-values)))
                             (error "Invalid variable values"))
    (error "Invalid poly")))

;; Funzioni di supporto a poly-val
;; poly-val-aux/2 | output list to sum

(defun poly-val-aux (monos vars-values)
  (cond ((null monos) nil)
        (t (let* ((head (car monos))
                  (tail (cdr monos))
                  (current-vp (fourth head)))
             (append (list (* (second head) (calculate-mono current-vp vars-values))) (poly-val-aux tail vars-values))))))

;; calculate-mono/2 | output to multiply with coeff
;; (calculate-mono '((V 2 W) (V 4 X)) '((W 3) (X 2))) --> 144

(defun calculate-mono (vp vars-values)
  (multiply-list (calculate-mono-aux vp vars-values)))

;; calculate-mono-aux/2 | output list to multiply

(defun calculate-mono-aux (vp vars-values) 
  (cond ((null vp) nil)
        (t (let ((head (car vp))
                 (tail (cdr vp)))
             (append (calculate-vars head vars-values) (calculate-mono-aux (cdr vp) vars-values))))))

;; calculate-vars/2
;; (calculate-vars '(V 2 A) '((T 1) (A 3) (X 3) (Y 4))) --> (9)

(defun calculate-vars (var vars-values)
  (cond ((null vars-values) nil)
        (t (if (equal (third var) (first (car vars-values))) (append (list (power (second (car vars-values)) (second var))) (calculate-vars var (cdr vars-values)))
             (calculate-vars var (cdr vars-values))))))

;; vars-n-values/2  -  (vars-n-values '(T W X Y) '(1 2 3 4)) --> ((T 1) (W 2) (X 3) (Y 4))
                                           
(defun vars-n-values (vars values)
  (cond ((null vars) nil)
        (t (append (list (list (car vars) (car values))) (vars-n-values (cdr vars) (cdr values))))))

;; power/2

(defun power (base exponent)
  (cond ((zerop exponent) 1)        
        (t (* base (power base (- exponent 1))))))

;; sum-list/1

(defun sum-list (list)
  (if (null list)
      0
      (+ (car list) (sum-list (cdr list)))))

;; multiply-list/1

(defun multiply-list (list)
  (if (null list)
      1
      (* (car list) (multiply-list (cdr list)))))
