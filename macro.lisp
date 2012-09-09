(defun primep (n)
  (when (> n 1)
    (loop for fac from 2 to (isqrt n) never (zerop (mod n fac)))))

(defun next-prime (n)
  (loop for i from n when (primep i) return i))

(defmacro do-primes ((var start end) &body body)
  (let ((ending-value-name (gensym)))
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
	  (,ending-value-name ,end))
      ((> ,var ,ending-value-name))
      ,@body)))

(defmacro once-only ((&rest names) &body body)
  (let ((gensyms (loop for n in names collect (gensym))))
    `(let (,@(loop for g in gensyms collect `(,g (gensym))))
      `(let (,,@(loop for g in gensyms for n in names collect ``(,,g ,,n)))
	,(let (,@(loop for n in names for g in gensyms collect `(,n ,g)))
	      ,@body)))))



(do-primes (x 1 1000000)
  (print x))