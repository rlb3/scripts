(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :hunchentoot)
  (require :cl-who))

(defpackage :tictactoe
  (:use :cl :hunchentoot :cl-who)
  (:export :start-web))

(in-package :tictactoe)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (setf *hunchentoot-default-external-format* (flex:make-external-format :utf-8 :eol-style :lf)
        *default-content-type* "text/html; charset=UTF-8"
        (html-mode) :sgml
        *read-eval* nil
        *dispatch-table* (list 'dispatch-easy-handlers
                               (create-folder-dispatcher-and-handler "/static/" "./" "text/plain")
                               (create-prefix-dispatcher "/" 'print-main-page))))

(defun start-web (&optional (port 4321))
  (start (make-instance 'acceptor :port port)))

(defparameter *remaining-digits* nil)

(defparameter *computer-digits* nil)

(defparameter *human-digits* nil)

(defparameter *magic* #2A((2 7 6)
                          (9 5 1)
                          (4 3 8)))

(defun print-main-page ()
  (let* ((human (or (get-parameter "human") ""))
         (computer (or (get-parameter "computer") ""))
         (human-sym (if (> (length human) (length computer)) 'x 'o))
         (computer-sym (if (equal human-sym 'x) 'o 'x)))
    (let* ((*human-digits* (map 'list (lambda (c) (position c "0123456789")) human))
           (*computer-digits* (map 'list (lambda (c) (position c "0123456789")) computer))
           (*remaining-digits* (sort (set-difference (list 1 2 3 4 5 6 7 8 9)
                                                     (append *human-digits* *computer-digits*))
                                     (lambda (x y) (and (evenp x) (not (evenp y)))))))
      (cond ((and (not *human-digits*)
                  (not *computer-digits*)
                  (> (random 100) 25))
             (setf human-sym 'x
                   computer-sym 'o))
            ((not (game-is-won))
             (make-next-move)))
      (with-html-output-to-string (*standard-output* nil :prologue t :indent t)
        (:html
         (:head
          (:style "html body{font-family:sans-serif; font-size:large} a{text-decoration:none;}")
          (:title "tic tac toe"))
         (:body
          (:h1
           "tic tac toe")
          ((:table :cellpadding "10px" :cellspacing "0")
           (dotimes (row 3)
             (fmt "<tr>")
             (dotimes (col 3)
               (fmt "<td align=\"center\" width=\"33%\" style=\"background:#ddddff; border:1px solid #888888\">")
               (cond ((member (aref *magic* row col) *human-digits*)
                      (fmt "~A" human-sym))
                     ((member (aref *magic* row col) *computer-digits*)
                      (fmt "~A" computer-sym))
                     ((game-is-won)
                      (fmt "-"))
                     (t
                      (fmt "<a href=\"/?human=~A~A&computer=~{~A~}\">-</a>"
                           human
                           (aref *magic* row col)
                           *computer-digits*)))
               (fmt "</td>"))
             (fmt "</tr>")))
          (when (or (null *remaining-digits*)
                    (game-is-won))
            (fmt "<p><a href=\"/\">play again</a></p>"))
          (:p
           ((:a :href "/static/ttt.lisp") "source code"))))))))

(defun triples (set)
  (let ((result nil))
    (dolist (i set result)
      (dolist (j set)
        (dolist (k set)
          (unless (or (equal i j) (equal j k) (equal i k))
            (push (list i j k) result)))))))

(defun game-is-won ()
  (or (some (lambda (triple) (= (apply #'+ triple) 15))
            (triples *computer-digits*))
      (some (lambda (triple) (= (apply #'+ triple) 15))
            (triples *human-digits*))))

(defun is-winner (digit)
  (let ((*computer-digits* (cons digit *computer-digits*)))
    (game-is-won)))

(defun is-blocker (digit)
  (let ((*human-digits* (cons digit *human-digits*)))
    (game-is-won)))

(defun is-fork (digit)
  (let ((*computer-digits* (cons digit *computer-digits*)))
    (some (lambda (next) (is-winner next))
          (remove digit *remaining-digits*))))

(defun is-fork-blocker (digit)
  (let ((*human-digits* (cons digit *computer-digits*)))
    (some (lambda (next) (is-winner next))
          (remove digit *remaining-digits*))))

(defun make-next-move ()
  (let ((winner (find-if #'identity *remaining-digits* :key #'is-winner))
        (blocker (find-if #'identity *remaining-digits* :key #'is-blocker))
        (fork (find-if #'identity *remaining-digits* :key #'is-fork))
        (fork-blocker (find-if #'identity *remaining-digits* :key #'is-fork-blocker))
        (center (first (member 5 *remaining-digits*))))
    (dolist (x (remove nil (list winner blocker fork fork-blocker center (first *remaining-digits*))))
      (when x
        (push x *computer-digits*)
        (setf *remaining-digits* (remove x *remaining-digits*))
        (return-from make-next-move x)))))