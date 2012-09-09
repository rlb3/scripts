(defun math-fun (function &rest args)
  (format t "The ~A of~{~F~} is ~F.~%" function args (apply function args)))

(defun main-math-demo (a b c d)
  (mapcar #'(lambda (args)
              (apply #'math-fun args))
          `((abs ,a)
            (ceiling ,b)
            (floor ,b)
            (round ,c)
            (max ,c ,d)
            (min ,c ,d))))

(main-math-demo -191.635 43.74 16 45)
