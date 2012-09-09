(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :hunchentoot)
  (require :cl-who)
  (require :elephant))

(defpackage :rlb3.links
  (:use :cl :hunchentoot :cl-who :elephant)
  (:export :start-up))

(in-package :rlb3.links)

(defvar *store* (open-store '(:clsql (:sqlite3 "/tmp/links.db"))))
(defvar *ids*   (or (get-from-root "ids") 0))

(setf *dispatch-table*
      (list 'dispatch-easy-handlers
            (create-regex-dispatcher "^/$" 'links-index)
            (create-regex-dispatcher "^/inc$" 'links-inc)
            (create-regex-dispatcher "^/dec$" 'links-dec)))

(defun start-up (&optional (port 8080))
  (start (make-instance 'acceptor :port port)))

;; (setf hunchentoot:*message-log-pathname* "/tmp/error.log")

(defpclass link ()
  ((name
   :initarg :name
   :accessor link-name)
   (id
    :accessor link-id
    :initform (incf *ids*)
    :index t)
  (url
   :initarg :url
   :accessor link-url)
  (count
   :initform 0
   :accessor link-count
   :index t)
  (timestamp
   :initarg :timestamp
   :accessor link-timestamp
   :initform (get-universal-time)
   :index t)))

(defmethod initialize-instance :after ((l link) &rest args)
  (add-to-root "ids" (link-id l)))

(defun make-link (&key name url)
  (make-instance 'link :name name :url url))

;; (make-link :name "Google" :url "http://www.google.com")

(defun links-index ()
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html
     (:head
      (:title "Links"))
     (:body
      (:h1 "Links page")
      (:ol
       (dolist (l (nreverse (get-instances-by-range 'link 'timestamp nil nil)))
         (htm
          (:li
           (:a :href (link-url l) (str (link-name l)))
           "Count "
           (str (link-count l))
           (fmt "<a href='/inc?id=~a'> Up </a>" (link-id l))
           (fmt "<a href='/dec?id=~a'>Down</a>" (link-id l))))))))))

(defun links-inc ()
  (let ((l  (first (get-instances-by-value 'link 'id (parse-integer (get-parameter "id"))))))
      (incf (link-count l)))
  (redirect "/"))

(defun links-dec ()
  (let ((l  (first (get-instances-by-value 'link 'id (parse-integer(get-parameter "id"))))))
    (decf (link-count l)))
  (redirect "/"))