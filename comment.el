(defvar *comment* nil)

(defun comment-set (arg)
  (setq *comment* arg))

(defmacro comment (&optional sym &rest body)
  (let ((arg (if (not (null *comment*)) *comment* sym)))
    (cond 
     ((and (symbolp arg)
           (eq :run arg)) `(progn ,@body))
     ((integerp arg)
      (nth arg `(,@body))))))

(comment 1
 (message "test1")
 (message "test2"))

(comment
 (comment-set :run))

(comment 0
 (print "test1")
 (print "test2"))

(comment
 (comment-set nil))

(comment
 (:documentation "test"))
