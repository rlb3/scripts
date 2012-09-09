(require 'cl)
(require 'xml)

(setq xml "<listaccts>
  <acct>
    <disklimit>unlimited</disklimit>
    <diskused>0M</diskused>
    <domain>tron.test</domain>
    <email>tron@gmail.com</email>
    <ip>127.0.0.1</ip>
    <owner>tron</owner>
    <partition>home</partition>
    <plan>all</plan>
    <startdate>08%20Oct%2024%2015:27</startdate>
    <suspended>0</suspended>
    <suspendreason>not%20suspended</suspendreason>
    <theme>x3</theme>
    <unix_startdate>1224880021</unix_startdate>
    <user>tron</user>
  </acct>
  <acct>
    <disklimit>unlimited</disklimit>
    <diskused>1M</diskused>
    <domain>ror.com</domain>
    <email>bruce@gmail.com</email>
    <ip>127.0.0.1</ip>
    <owner>root</owner>
    <partition>home</partition>
    <plan>all</plan>
    <startdate>08%20Sep%2010%2009:32</startdate>
    <suspended>0</suspended>
    <suspendreason>not%20suspended</suspendreason>
    <theme>x3</theme>
    <unix_startdate>1221057161</unix_startdate>
    <user>rorcom</user>
  </acct>
  <acct>
    <disklimit>unlimited</disklimit>
    <diskused>0M</diskused>
    <domain>db.com</domain>
    <email>*unknown*</email>
    <ip>127.0.0.1</ip>
    <owner>root</owner>
    <partition>home</partition>
    <plan>undefined</plan>
    <startdate>69%20Dec%2031%2018:00</startdate>
    <suspended>0</suspended>
    <suspendreason>not%20suspended</suspendreason>
    <theme>x3</theme>
    <unix_startdate>*unknown*</unix_startdate>
    <user>dbuser</user>
  </acct>
  <acct>
    <disklimit>100M</disklimit>
    <diskused>0M</diskused>
    <domain>rlb3.com</domain>
    <email>bruce@gmail.com</email>
    <ip>127.0.0.1</ip>
    <owner>root</owner>
    <partition>home</partition>
    <plan>default</plan>
    <startdate>08%20Oct%2007%2014:32</startdate>
    <suspended>0</suspended>
    <suspendreason>not%20suspended</suspendreason>
    <theme>x3</theme>
    <unix_startdate>1223407954</unix_startdate>
    <user>rlb3com</user>
  </acct>
  <acct>
    <disklimit>200M</disklimit>
    <diskused>100M</diskused>
    <domain>fdsafda.com.ar</domain>
    <email>*unknown*</email>
    <ip>127.0.0.1</ip>
    <owner>root</owner>
    <partition>home</partition>
    <plan>undefined</plan>
    <startdate>69 Dec 31 18:00</startdate>
    <suspended>0</suspended>
    <suspendreason>not suspended</suspendreason>
    <theme>x3</theme>
    <unix_startdate>*unknown*</unix_startdate>
    <user>fdasf</user>
  </acct>
  <status>1</status>
  <statusmsg>Ok</statusmsg>
</listaccts>")


(setq node (car (with-temp-buffer
  (insert xml)
  (xml-parse-region (point-min) (point-max)))))

(setq accts (cdr (xml-get-children node 'acct)))

(setq users (loop for acct in accts
      collect (nth 2 (car (xml-get-children acct 'user)))))

users

(dolist (user users)
  (message "%s"  user))

