(require 'ert)

(ert-deftest csv->list ()
  "Test CSV rows are correctly split into lists.
Empty fields become empty strings."
  (should (equal (csv->list "cat") '("cat")))
  (should (equal (csv->list "cat,dog") '("cat" "dog")))
  (should (equal (csv->list "cat,dog,goat") '("cat" "dog" "goat")))
  (should (equal (csv->list "cat,,goat") '("cat" "" "goat")))
  (should (equal (csv->list ",,goat") '("" "" "goat")))
  (should (equal (csv->list ",,goat,") '("" "" "goat" "")))
  (should (equal (csv->list ",,,") '("" "" "" ""))))

(ert-deftest csv->list/spaces-surrounding-fields-are-stripped ()
  "Spaces inside and surrounding fields are preserved."
  (should (equal (csv->list " cat ") '(" cat ")))
  (should (equal (csv->list "cat,sausage dog,goat") '("cat" "sausage dog" "goat"))))

(ert-deftest csv->list/quotes-surrounding-fields-are-stripped ()
  "Quotes surrounding fields should be stripped."
  (should (equal (csv->list
                  "cat,\"sausage dog\",goat")
                 '("cat" "sausage dog" "goat"))))

(ert-deftest csv->list/spaces-inside-quotes-are-retained ()
  "Quotes preserve leading and trailing spaces."
  (should (equal (csv->list "\" cat\"") '(" cat")))
  (should (equal (csv->list "\"cat \"") '("cat ")))
  (should (equal (csv->list "\" cat \"") '(" cat "))))

(ert-deftest csv->list/commas-inside-quotes-are-retained ()
  "Quotes preserve commas embedded in fields."
  (should (equal (csv->list "\",cat\"") '(",cat")))
  (should (equal (csv->list "\"cat,\"") '("cat,")))
  (should (equal (csv->list "\",cat,\"") '(",cat,"))))
