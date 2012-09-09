
(asdf:oos 'asdf:load-op :cl-observer)
(use-package :cl-observer)


(defclass name ()
  ((fname
   :accessor fname
   :initarg :fname)
   (lname
    :accessor lname
    :initarg :lname))
  (:metaclass observer))

(defmethod fullname ((n name))
  (format nil "~a ~a" (fname n) (lname n)))

(defparameter my-name (make-instance 'name :fname "Robert" :lname "Boone"))
(setf my-name nil)

(inspect my-name)


(fullname my-name)

(observe (my-name 'fname new old)
  (format t "OLD:~a NEW:~a" old new))

(setf (fname my-name) "Lewis")