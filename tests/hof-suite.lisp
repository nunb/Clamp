(in-package :clamp-tests)

(defsuite hof (clamp))

(deftest testify (hof)
  (assert-true  (call (testify 5) 5))
  (assert-false (call (testify 5) 4))
  (assert-true  (call (testify #'even) 4))
  (assert-false (call (testify #'even) 5)))

(deftest rem (hof)
  (assert-equal '() (rem 5 '()))
  (assert-equal '() (rem #'even '()))
  (assert-equal '(1 2 8 2) (rem 5 '(1 5 2 8 2 5)))
  (assert-equal '(5 29 5) (rem #'even '(2 5 29 5 28)))
  (assert-equal '() (rem #'even '(2 12 16 4)))
  (assert-equal '(13 5 7) (rem #'even '(13 5 7)))
  ;; Same tests but with vectors instead.
  (assert-equalp #() (rem 5 #()))
  (assert-equalp #() (rem #'even #()))
  (assert-equalp #(1 2 8 2) (rem 5 #(1 5 2 8 2 5)))
  (assert-equalp #(5 29 5) (rem #'even #(2 5 29 5 28)))
  (assert-equalp #() (rem #'even #(2 12 16 4)))
  (assert-equalp #(13 5 7) (rem #'even #(13 5 7))))

(deftest keep (hof)
  (assert-equal '() (keep 7 '()))
  (assert-equal '() (keep #'even '()))
  (assert-equal '(2 8 2 4) (keep #'even '(1 2 8 2 3 4)))
  (assert-equal '() (keep #'even '(5 7 3)))
  (assert-equal '(2 12 72 6) (keep #'even '(2 12 72 6)))
  ;; Same tests but for vectors.
  (assert-equalp #() (keep 7 #()))
  (assert-equalp #() (keep #'even #()))
  (assert-equalp #(2 8 2 4) (keep #'even #(1 2 8 2 3 4)))
  (assert-equalp #() (keep #'even #(5 7 3)))
  (assert-equalp #(2 12 72 6) (keep #'even #(2 12 72 6))))

;;; Member does not work on vectors (what is the tail of a vector?).
(deftest mem (hof)
  (assert-false (mem 7 '()))
  (assert-false (mem #'even '()))
  (assert-false (mem 3 '(1 29 32 5)))
  (assert-equal '(5 3 2) (mem 5 '(1 6 3 5 3 2)))
  (assert-equal '(2 3) (mem #'even '(1 9 2 3))))

(deftest find (hof)
  (assert-false (find 5 '()))
  (assert-false (find #'even '()))
  (assert-false (find 5 '(2 9 1 2 7 3)))
  (assert-eql 5 (find 5 '(1 3 5 2 9 3)))
  (assert-eql 2 (find #'even '(1 3 5 2 9 3 4 6 7)))
  ;; Same tests but for vectors.
  (assert-false (find 5 #()))
  (assert-false (find #'even #()))
  (assert-false (find 5 #(2 9 1 2 7 3)))
  (assert-eql 5 (find 5 #(1 3 5 2 9 3)))
  (assert-eql 2 (find #'even #(1 3 5 2 9 3 4 6 7))))

(deftest count (hof)
  (assert-eql 0 (count 2 '()))
  (assert-eql 0 (count #'even '()))
  (assert-eql 0 (count #'even '(1 3 71 21)))
  (assert-eql 3 (count 5 '(1 5 3 2 5 7 5)))
  (assert-eql 4 (count #'even '(1 6 3 2 2 4)))
  ;; Same tests but for vectors.
  (assert-eql 0 (count 2 #()))
  (assert-eql 0 (count #'even #()))
  (assert-eql 0 (count #'even #(1 3 71 21)))
  (assert-eql 3 (count 5 #(1 5 3 2 5 7 5)))
  (assert-eql 4 (count #'even #(1 6 3 2 2 4))))

(deftest pos (hof)
  (assert-false (pos 2 '()))
  (assert-false (pos #'even '()))
  (assert-false (pos #'even '(123 45 3 7)))
  (assert-eql 2 (pos 5 '(1 3 5 3 2 5)))
  (assert-eql 3 (pos #'even '(1 7 3 2 5 7 4 2)))
  ;; Same tests but for vectors.
  (assert-false (pos 2 #()))
  (assert-false (pos #'even #()))
  (assert-false (pos #'even #(123 45 3 7)))
  (assert-eql 2 (pos 5 #(1 3 5 3 2 5)))
  (assert-eql 3 (pos #'even #(1 7 3 2 5 7 4 2))))

(deftest mappend (hof)
  (assert-equal '() (mappend #'identity '()))
  (assert-equal '(1 4 2 5 3 6) (mappend #'list '(1 2 3) '(4 5 6))))

(deftest partition (hof)
  (assert-equal '(() ()) (mvl (partition #'even '())))
  (assert-equal '(() ()) (mvl (partition 1 '())))
  (assert-equal '((2 4) (1 3 5)) (mvl (partition #'even '(1 2 3 4 5))))
  (assert-equal '((4) (5)) (mvl (partition #'even '(1 2 3 4 5) :start 3)))
  (assert-equal '((1 1 1) (0)) (mvl (partition 1 '(1 0 1 1))))
  (assert-equal '(((2) (4)) ((1) (3) (5)))
		(mvl (partition #'even '((1) (2) (3) (4) (5)) :key #'car)))
  (assert-equal '(((4)) ((5)))
		(mvl (partition #'even '((1) (2) (3) (4) (5))
				:key #'car
				:start 3)))
  ;; Same tests but for vectors.
  (assert-equal '(() ()) (mvl (partition #'even #())))
  (assert-equal '(() ()) (mvl (partition 1 #())))
  (assert-equal '((2 4) (1 3 5)) (mvl (partition #'even #(1 2 3 4 5))))
  (assert-equal '((4) (5)) (mvl (partition #'even #(1 2 3 4 5) :start 3)))
  (assert-equal '((1 1 1) (0)) (mvl (partition 1 #(1 0 1 1))))
  (assert-equal '(((2) (4)) ((1) (3) (5)))
		(mvl (partition #'even #((1) (2) (3) (4) (5)) :key #'car)))
  (assert-equal '(((4)) ((5)))
		(mvl (partition #'even #((1) (2) (3) (4) (5))
				:key #'car
				:start 3))))

(deftest trues (hof)
  (let alist '((a 1) (b 2) (c 3))
    (assert-equal '((c 3) (a 1))
                  (trues [assoc _ alist]
                         '(c d a)))))