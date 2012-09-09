(defclass person ()
  ((name :accessor name
         :initform 'NoName
         :initarg :name)
   (age :accessor age
        :initform 0
        :initarg :age)))

(defclass staff (person)
  ((title :accessor title
          :initform 'Title
          :initarg :title)))

(defmethod year-born ((pn person ))
    (- (current-year) (age pn)))

(defun current-year () 2008)

(setq s1 (make-instance 'staff :name 'robert :age 33 :title 'Dev))

(princ (name s1))
(print (age s1))
(print (title s1))
(print (year-born s1))

