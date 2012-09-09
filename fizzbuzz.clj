(ns fizzbuzz)

(defn fizz [n]
  (if (zero? (mod n 3)) "fizz"))


(defn buzz [n]
  (if (zero? (mod n 5)) "buzz"))

(def fb-list [fizz buzz])

(defn fizzbuzz [n]
  (let [fb (apply str ((apply juxt fb-list) n))]
    (if (empty? fb) n fb)))
