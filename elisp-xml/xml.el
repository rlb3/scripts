(defun my-process-file (fpath)
  "Process the file at fullpath fpath ..."
  (setq node (car (xml-parse-file fpath)))    
  (setq addressees (xml-get-children node 'to))
  (loop for person in addressees 
        collect (xml-get-attribute person 'userid)))
 
(my-process-file "emacs-xml.xml")