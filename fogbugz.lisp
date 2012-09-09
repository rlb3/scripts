(asdf:oos 'asdf:load-op :drakma)
(asdf:oos 'asdf:load-op :cl-libxml2)
(asdf:oos 'asdf:load-op :iterate)

(defpackage :fogbugz(:use :cl :iter :drakma :xtree :xpath))
(in-package :fogbugz)
(use-package :iterate)

(defclass Context ()
  ((user :initarg :user
         :accessor user)
   (password :initarg :password
             :accessor password)
   (token :initarg :token
          :accessor token)))

(defclass Fogbugz ()
  ((url :initarg :url
        :accessor url)
   (context :initarg :context
            :accessor context)))

(defun connect (&key user pass url)
  (let* ((c (make-instance 'Context :user user :password pass))
         (fb (make-instance 'Fogbugz :url url :context c)))
    (progn (login fb)
           fb)))

(defmethod login ((f Fogbugz))
  (let ((params `(("cmd" . "logon")
                  ("email" . ,(user (context f)))
                  ("password" . ,(password (context f))))))
    (multiple-value-bind (xml status headers) (http-request (url f) :parameters params)
      (setf (token (context f)) (car (xtree:with-parse-document (doc xml)
              (iter (for node in-xpath-result "/response/token" on doc)
                    (iter:collect (xtree:text-content node)))))))))

(defmethod login-p ((f Fogbugz))
  (or (token (context f)) nil))

(defmethod logout ((f Fogbugz))
  (let ((params `(("cmd" . "logoff")
                  ("token" . ,(token (context f))))))
    (http-request (url f) :parameters params)
    (setf (token (context f)) nil)))

(defmethod set-filter ((f Fogbugz) filter)
  (let ((params `(("cmd" . "setCurrentFilter")
                  ("sFilter" . ,(format nil "~d" filter))
                  ("token" . ,(token (context f))))))
    (multiple-value-bind (xml status headers) (http-request (url f) :parameters params)
      (when (= status 200) t))))

(defmethod list-filters ((f Fogbugz))
  (let ((params `(("cmd" . "listFilters")
                   ("token" . ,(token (context f)))))
         (xpath-string (format nil "~{~a~^ | ~}" '("/response/filters/filter/@sFilter"
                                                   "/response/filters/filter/node()"))))
    (multiple-value-bind (xml status headers) (http-request (url f) :parameters params)
      (let ((plist (xtree:with-parse-document (doc xml)
                     (iter (for node in-xpath-result xpath-string on doc)
                           (collect (xtree:text-content node))))))
        (labels ((to-alist (a lst)
                   (let ((key (first lst))
                         (val (second lst)))
                     (if (null lst)
                         a
                         (to-alist (acons key val a) (cddr lst))))))
          (to-alist '() plist))))))


(defmethod list-cases ((f Fogbugz))
  (let ((params `(("cmd" . "search")
                  ("cols" . "ixBug,fOpen,sTitle,sLatestTextSummary,sPersonAssignedTo,sStatus,ixPriority")
                  ("token" . ,(token (context f)))))
        (xpath-string (format nil "~{~a~^ | ~}" '("/response/cases/case/ixBug"
                                                  "/response/cases/case/fOpen"
                                                  "/response/cases/case/sTitle"
                                                  "/response/cases/case/sLatestTextSummary"
                                                  "/response/cases/case/sPersonAssignedTo"
                                                  "/response/cases/case/sStatus"
                                                  "/response/cases/case/ixPriority"))))
    (multiple-value-bind (xml status headers) (http-request (url f) :parameters params)
      (let ((lst (xtree:with-parse-document (doc xml)
                   (iter (for node in-xpath-result xpath-string on doc)
                         (collect (xtree:text-content node))))))
        (labels ((build-tree (a lst)
                   (let ((case (nth 0 lst))
                         (open (nth 1 lst))
                         (title (nth 2 lst))
                         (summary (nth 3 lst))
                         (name (nth 4 lst))
                         (status (nth 5 lst))
                         (priority (nth 6 lst)))
                     (if (null lst)
                         a
                         (build-tree
                          (concatenate 'list  a (list (list (cons :CASE case)
                                                            (cons :OPEN open)
                                                            (cons :TITLE title)
                                                            (cons :SUMMARY summary)
                                                            (cons :ASSIGNED name)
                                                            (cons :STATUS status)
                                                            (cons :PRIORITY priority))))
                          (cdddr (cddddr lst)))))))
          (build-tree '() lst))))))




(setf fb (connect :user "robert@email.net" :pass "PASSWORD" :url "http://fogbugz.rlb3.net/api.asp"))

(set-filter fb "ez")
(list-filters fb)

(setf x (list-cases fb))
(delete-if-not (lambda (l) (string= (cdr (assoc :ASSIGNED l)) "Robert Boone")) (list-cases fb))


(logout fb)

(if (login-p fb)
    (print "logged in")
    (print "logged out"))
