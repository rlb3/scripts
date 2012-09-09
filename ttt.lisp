(defvar *board* nil)

(defconstant *winning-positions* '((1 2 3) (4 5 6) (7 8 9)
                                   (1 4 7) (2 5 8) (3 6 9)
                                   (1 5 9) (3 5 9)))
 
(defun reset-board ()
  (setf *board* nil)
  (dotimes (x 9)
    (push "." *board*)))

(defun show-board ()
  (let ((count 1))
    (dolist (marker *board*)
      (format t "~a " marker)
      (if (eq (mod count 3) 0)
          (format t "~%"))
      (incf count)))
  (format t "~%"))

(defun play (loc player)
  (if (equal (nth loc *board*) ".")
      (progn
        (setf (nth loc *board*) player)
        (show-board))
      (error "Location taken. Try again")))

(defun validate-range (location)
  (unless (and (>= location 0) (<= location 8))
      (error "Location much be between 1-9")))

(defun validate-location (location)
  (unless (equal (nth location *board*) ".")
    (error "Location taken")))

(defun validate (location)
  (validate-range location)
  (validate-location location))

(defun play (location player)
  (decf location)
  (validate location)
  (setf (nth location *board*) player)
  (show-board))

(defun create-turn-keeper ()
  (let ((player "O"))
    (lambda ()
      (if (equal player "O")
          (setf player "X")
          (setf player "O"))
      player)))

(setf turn-keeper (create-turn-keeper))

(funcall turn-keeper)



(reset-board)
(show-board)

;; (play 1 "X")
