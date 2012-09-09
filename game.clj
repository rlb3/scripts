(derive ::rock ::object)
(derive ::paper ::object)
(derive ::scissors ::object)

(def rock      { :type ::rock :verb "crushes"})
(def paper     { :type ::paper :verb "covers"})
(def scissors  { :type ::scissors :verb "cuts"})

(def objects [rock paper scissors])

(defmulti play (fn [x y] [(:type x) (:type y)]))

(defmethod play [::object ::object] [o1 o2]
           :tie)

(defmethod play [::rock ::scissors] [o1 o2]
           (str (:type o1) " " (:verb o1) " " (:type o2)))
(defmethod play [::scissors ::rock] [o1 o2]
           (str (:type o2) " " (:verb o2) " " (:type o1)))

(defmethod play [::paper ::rock] [o1 o2]
           (str (:type o1) " " (:verb o1) " " (:type o2)))
(defmethod play [::rock ::paper] [o1 o2]
           (str (:type o2) " " (:verb o2) " " (:type o1)))

(defmethod play [::scissors ::paper] [o1 o2]
           (str (:type o1) " " (:verb o1) " " (:type o2)))
(defmethod play [::paper ::scissors] [o1 o2]
           (str (:type o2) " " (:verb o2) " " (:type o1)))

(defn play-game [person]
  (play person (objects (rand-int 3))))

(comment
  (play-game paper)) 

(descendants ::object)
