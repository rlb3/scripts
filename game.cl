(defparameter *objects* (make-array 3 :fill-pointer 0))

(defclass object ()
  ((won-p :accessor won-p
          :initform nil)
   (verb  :accessor verb
          :initarg :verb)))

(defclass rock (object)
  ((name :accessor name
         :initform "rock")
   (verb :initform "breaks")))

(defclass paper (object)
  ((name :accessor name
         :initform "paper")
   (verb :initform "covers")))

(defclass scissors (object)
  ((name :accessor name
         :initform "scissors")
   (verb :initform "cuts")))


(defgeneric play (o1 o2)
  (:documentation "Find a winner between the two objects"))
(defgeneric msg (o1 o2)
  (:documentation "Print out the results"))
(defgeneric set-winner (object)
  (:documentation "Set the win bit"))
(defgeneric clear-winner (object)
  (:documentation "Clear the win bit"))
(defgeneric win (object)
  (:documentation "Set the object won-p to true"))

(defmethod play ((o1 object) (o2 object)) nil)

(defmethod play ((rock rock) (scissors scissors))
  (set-winner rock))
(defmethod play ((scissors scissors) (rock rock))
  (set-winner rock))
(defmethod play ((rock rock) (paper paper))
  (set-winner paper))
(defmethod play ((paper paper) (rock rock))
  (set-winner paper))
(defmethod play ((paper paper) (scissors scissors))
  (set-winner scissors))
(defmethod play ((scissors scissors) (paper paper))
  (set-winner scissors))

(defmethod msg ((winner object) (loser object))
  (format t "~a ~a ~a~%" (name winner) (verb winner) (name loser)))

(defun same (obj)
  (format t "~%[~a]~%~%" "same object - trying again")
  (play-game obj))

(defmethod clear-winner ((object object))
  (setf (won-p object) nil))

(defmethod set-winner ((object object))
  (setf (won-p object) t))

(defun computer-pick ()
  (aref *objects* (random 3)))

(defun play-game (obj1)
  (let (obj2)
    (setf obj2 (computer-pick))
    (format t "you pick ~a~%" (name obj1))
    (format t "computer picks ~a~%" (name obj2))
    (play obj1 obj2)
    (cond
      ((won-p obj1) (msg obj1 obj2))
      ((won-p obj2) (msg obj2 obj1))
      (t (same obj1)))
    (clear-winner obj1)
    (clear-winner obj2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter rock (make-instance 'rock))
(defparameter paper (make-instance 'paper))
(defparameter scissors (make-instance 'scissors))

(vector-push rock *objects*)
(vector-push paper *objects*)
(vector-push scissors *objects*)

(play-game rock)

