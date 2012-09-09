(def days {:sun 0 :mon 1 :tues 2 :wed 3 :thurs 4 :fri 5 :sat 6 })
(def daylist [:sun :mon :tues :wed :thurs :fri :sat])

(defn day-list [first last]
  (let [current (days first)
        end (days last)]
    (if (<= current end)
      (map #(daylist %) (range current (+ 1 end)))
      (concat (map #(daylist %) (range current (count daylist))) (day-list :sun last)))))

(day-list :fri :tues)
                          