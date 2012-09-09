(defclass food () ())

(defmethod cook :before ((f food))
  (print "A food is about to be cooked."))

(defmethod cook :after ((f food))
  (print "A food has been cooked."))

(defclass pie (food)
  ((filling :accessor pie-filling 
	    :initarg :filling
	    :initform 'apple)))

(defmethod cook ((p pie))
  (print "Cooking a pie.")
  (setf (pie-filling p) (list 'cooked (pie-filling p))))

(defmethod cook :before ((p pie))
  (print "A pie is about to be cooked."))

(defmethod cook :after ((p pie))
  (print "A pie has been cooked."))

(defmethod cook :around ((f food))
  (print "Begin around food.")
  (let ((result (call-next-method)))
    (print "End around food.")
    result))

(setq pie-1 (make-instance 'pie :filling 'apple))

(cook pie-1)