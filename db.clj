(defstruct cd :title :artist :rating :ripped)

(defn add-records [db & cd] (into db cd))

(defn init-db []
  (add-records #{} 
          (struct cd "Roses" "Kathy Mattea" 7 true)
          (struct cd "Fly" "Dixie Chicks" 8 true)
          (struct cd "Home" "Dixie Chicks" 9 true)))

(defn dump-db [db]
  (doseq [cd db]
    (doseq [[key value] cd]
      (print (format "%10s: %s\n" (name key) value)))
    (println)))

(defn prompt-read [prompt]
  (print (format "%s: " prompt))
  (flush)
  (read-line))

(defn parse-integer [str]
  (try (Integer/parseInt str) 
       (catch NumberFormatException nfe 0)))

(defn y-or-n-p [prompt]
  (= "y"
     (loop []
       (or 
        (re-matches #"[yn]" (.toLowerCase (prompt-read prompt)))
        (recur)))))

(defn prompt-for-cd []
  (struct 
   cd 
   (prompt-read "Title")
   (prompt-read "Artist")
   (parse-integer (prompt-read "Rating"))
   (y-or-n-p "Ripped [y/n]")))

(use 'clojure.contrib.duck-streams)

(defn save-db [db filename]
  (spit 
   filename 
   (with-out-str (print db))))

(defn load-db [filename] 
  (with-in-str (slurp filename)
    (read)))

(defn artist-selector [artist]
  #(= (:artist %) artist))

(filter (artist-selector "Dixie Chicks") (init-db))

(defn where [criteria]
  (fn [m]
    (loop [criteria criteria] 
      (let [[k,v] (first criteria)]
        (or (not k)
            (and (= (k m) v) (recur (rest criteria))))))))

(filter (where {:artist "Dixie Chicks" :rating 8}) (init-db))

(defn simpler-where [criteria]
  (fn [m]
    (every? (fn [[k v]] (= (k m) v)) criteria)))

(defn update [db criteria updates]
  (into (empty db) 
   (map (fn [m] 
      (if (criteria m) (merge m updates) m))
    db)))

(update (some-db) (where {:artist "Dixie Chicks"}) {:rating 10})
