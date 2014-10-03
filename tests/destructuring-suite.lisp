(in-package :experimental-tests)

(defsuite destructuring (clamp-experimental))

(deftest regular (destructuring)
  (let f (fn fn fn)
    (assert-equal '() (call f))
    (assert-equal '(1 2 3) (call f 1 2 3)))
  (let f (fn ((x . y)) (join x y))
    (assert-equal '(1 2 3 4) (call f '((1 2) 3 4)))
    (assert-equal '(1) (call f '((1)))))
  (let f (fn ((a b) (c . d) e) (list a b c d e))
    (assert-equal '(1 2 3 4 5) (call f '(1 2) '(3 . 4) 5))
    (assert-equal '(1 2 3 (4 5) 6) (call f '(1 2) '(3 4 5) 6))))
