(defun my-sort (lst)
  (let ((pivot (car lst)))
    (when lst
      (append
       (my-sort (sort-helper > pivot (cdr lst)))
       (list pivot)
       (my-sort (sort-helper <= pivot (cdr lst)))))))


(defmacro sort-helper (c p l)
  `(remove-if #'(λ (arg)
                   (,c arg ,p))
              ,l))

