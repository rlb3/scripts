(ns com.rlb3.perl.rss
  (:require [clojure.contrib.lazy-xml :as xml]
            [clojure.contrib.str-utils2 :as str]))

(def perl-url "http://search.cpan.org/uploads.rdf")

(defn get-new-perl-modules-list []
  (drop 2 (map (fn [map] (first (reverse (str/split (:rdf:about map) #"/"))))
     (filter :rdf:about
             (map :attrs (xml/parse-seq perl-url))))))

(defn get-new-perl-modules-map []
  (map
   (fn [v] (let [version (last v)
                 name (pop v)]
             { :name (str/join "::" name) :version version }))
   (map #(vec (str/split % #"-")) (get-new-perl-modules-list))))

(def perl-module-map (get-new-perl-modules-map))

(defn find-perl-module [s]
  (filter #(when (.equals s (:name %)) true) perl-module-map))

(find-perl-module "Spawn::Safe")

