(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :hunchentoot)
  (require :cl-who)
  (require :postmodern))

(defpackage rlb3.poems
  (:use :cl :hunchentoot :cl-who :postmodern)
  (:export :start-up))

(in-package :rlb3.poems)

(connect-toplevel "text" "robert" "" "localhost")

(defun start-up (&optional (port 8080))
  (start (make-instance 'acceptor :port port)))

(setf *dispatch-table*
      (list 'dispatch-easy-handlers
            (create-regex-dispatcher "^/$"     'poem-index)
            (create-regex-dispatcher "^/poem$" 'poem-show)
            (create-regex-dispatcher "^/add$"  'poem-add)
            (create-regex-dispatcher "^/save$" 'poem-save)
            (create-regex-dispatcher "^/delete" 'poem-delete)))


(defun poem-index ()
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html
     (:head
      (:title "Poems"))
     (:body
      (:h1 "Poems")
      (:p (:a :href "/add" "Add Poem"))
      (:ol
       (loop :for data :in (query "SELECT id, title from poems order by title")
          :do
          (fmt "<li><a href='/poem?id=~a'>~a</a></li>" (first data) (second data))))))))

(defun poem-show ()
  (let* ((id (parse-integer (get-parameter "id")))
         (data (first (query "SELECT title, body, author FROM poems WHERE id = $1" id))))
    (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
      (:html
       (:head
        (:title (str (first data))))
       (:body
        (:h1 (str (first data)))
        (:pre (str (second data)))
        (:blockquote "-- " (str (third data)))
        (:a :href "/" "[Back]") " | " (fmt "<a href='/delete?id=~a'>~a</a>" id "Delete"))))))

(defun poem-add ()
  (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
    (:html
     (:head
      (:title "Add Poem"))
     (:body
      (:h1 "Add Poem")
      (:form :action "/save" :method "post"
             (:table :border 0
                     (:tr
                      (:th (str "Title:"))
                      (:td
                       (:input :type "text" :name "title" :size 50)))
                     (:tr
                      (:th :valign "top" (str "Body:"))
                      (:td (:textarea :type "text" :rows 10 :cols 50 :name "body")))
                     (:tr
                      (:th (str "Author:"))
                      (:td (:input :type "text" :name "author" :size 30)))
                     (:td (str ""))
                     (:td (:input :type "submit" :name "submit")))
             (:a :href "/" "[Back]"))))))

(defun poem-save ()
  (let ((title  (parameter "title"))
        (body   (parameter "body"))
        (author (parameter "author")))
    (execute "INSERT INTO poems (title, body, author) VALUES ($1, $2, $3)" title body author))
  (redirect "/"))

(defun poem-delete ()
  (let ((id (parse-integer (parameter "id"))))
    (execute "DELETE FROM poems WHERE id = $1" id))
  (redirect "/"))
