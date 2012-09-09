(asdf:oos 'asdf:load-op :postmodern)
(asdf:oos 'asdf:load-op :s-xml-rpc)
(use-package :postmodern)
(use-package :s-xml-rpc)
(use-package :simple-date)

(defclass post ()
  ((title
   :accessor title
   :initarg  :title)
  (body
   :accessor body
   :initarg  :body)
  (datecreated
   :accessor datecreated
   :initarg  :datecreated)))


(connect-toplevel "mt4" "robert" "" "localhost")
(disconnect-toplevel)

(defparameter *db*
  (query "SELECT entry_id, entry_title, entry_text, entry_created_on FROM mt_entry order by entry_created_on ASC"))


(defparameter *posts* (loop for x in *db*
                         collecting (make-instance 'post :title (nth 1 x) :body (nth 2 x) :datecreated (nth 3 x))))

(length *posts*)


(defun publish-post (&key user pass title body timestamp)
  (xml-rpc-call
   (encode-xml-rpc-call "metaWeblog.newPost" 1 user pass
                        (xml-rpc-struct
                         "title" title
                         "description" body
                         "dateCreated" (xml-rpc-time timestamp)) 1)
   :host "admin.rlb3.com"
   :url "/mt-xmlrpc.cgi"))

(defun start-conversion (user pass posts)
  (dolist (post posts)
    (publish-post :user user :pass pass :title (title post) :body (body post) :timestamp (timestamp-to-universal-time (datecreated post))))
  (print "Done!"))

;; (start-conversion "user" "pass" *posts*)



;; Testing code I don't want to delete
;; 
;; (setf *xml-rpc-debug* t)
;;
;; (defun test-xml ()
;;    (xml-rpc-call
;;     (encode-xml-rpc-call "mt.getRecentPostTitles" 1 "user" "pass" 2)
;;     :host "admin.rlb3.com"
;;     :url "/mt-xmlrpc.cgi"))
;;
;; (cdr (test-xml))
;; (get-xml-rpc-struct-member (car (test-xml)) ':|title|)
