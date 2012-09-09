(defparameter *days*
  '((:sun . 0) (:mon . 1) (:tues . 2) (:wed . 3)
    (:thurs . 4) (:fri . 5) (:sat . 6)))

(defparameter *weekindex* (- (length *days*) 1))

(defun day-lookup (key)
  (cdr (assoc key *days*)))
(defun day-reverse-lookup (value)
  (car (rassoc value *days*)))

(defun range (start end) 
  (loop for i from start to end collect i))

(defun day-list (first last)
  (let ((current (day-lookup first))
        (end (day-lookup last)))
    (if (<= current end)
        (mapcar (lambda (x) (day-reverse-lookup x)) (range current end))
        (append
         (mapcar (lambda (x) (day-reverse-lookup x))
                 (range current *weekindex*))
         (day-list :sun last)))))
