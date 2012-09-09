(defn ticket [age]
  (cond (< age 16) :child
        (>= age 66) :senior
        :else :adult))

(ticket 10)

(defrecord Person [name age])
(defmulti print-name (fn [person] (ticket (:age person))))
(defmethod print-name :child [person] (str "Young " (:name person)))
(defmethod print-name :adult [person] (:name person))
(defmethod print-name :senior [person] (str "Old " (:name person)))

(print-name (Person. "Jimmy" 5))
(print-name (Person. "Alex" 36))
(print-name (Person. "Edna" 99))

