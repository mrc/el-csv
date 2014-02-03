(require 'ert)
(require 'parse-csv)

(ert-deftest parse-csv->list ()
  "Test CSV rows are correctly split into lists.
Empty fields become empty strings."
  (should (equal (parse-csv->list "cat") '("cat")))
  (should (equal (parse-csv->list "cat,dog") '("cat" "dog")))
  (should (equal (parse-csv->list "cat,dog,goat") '("cat" "dog" "goat")))
  (should (equal (parse-csv->list "cat,,goat") '("cat" "" "goat")))
  (should (equal (parse-csv->list ",,goat") '("" "" "goat")))
  (should (equal (parse-csv->list ",,goat,") '("" "" "goat" "")))
  (should (equal (parse-csv->list ",,,") '("" "" "" ""))))

(ert-deftest parse-csv->list/spaces-surrounding-fields-are-stripped ()
  "Spaces inside and surrounding fields are preserved."
  (should (equal (parse-csv->list " cat ") '(" cat ")))
  (should (equal (parse-csv->list "cat,sausage dog,goat") '("cat" "sausage dog" "goat"))))

(ert-deftest parse-csv->list/quotes-surrounding-fields-are-stripped ()
  "Quotes surrounding fields should be stripped."
  (should (equal (parse-csv->list
                  "cat,\"sausage dog\",goat")
                 '("cat" "sausage dog" "goat"))))

(ert-deftest parse-csv->list/spaces-inside-quotes-are-retained ()
  "Quotes preserve leading and trailing spaces."
  (should (equal (parse-csv->list "\" cat\"") '(" cat")))
  (should (equal (parse-csv->list "\"cat \"") '("cat ")))
  (should (equal (parse-csv->list "\" cat \"") '(" cat "))))

(ert-deftest parse-csv->list/commas-inside-quotes-are-retained ()
  "Quotes preserve commas embedded in fields."
  (should (equal (parse-csv->list "\",cat\"") '(",cat")))
  (should (equal (parse-csv->list "\"cat,\"") '("cat,")))
  (should (equal (parse-csv->list "\",cat,\"") '(",cat,"))))

(ert-deftest parse-csv-string-rows/two-simple-lines ()
  "Should parse two rows"
  (should (= 2 (length (parse-csv-string-rows "apples,bananas,carrots
monkies,rabbits,cherries" ?\, ?\" "
")))))

(ert-deftest parse-csv-string-rows/two-simple-lines-correctly ()
  "Should parse two rows correctly"
  (should (equal (parse-csv-string-rows "apples,bananas,carrots\nmonkies,rabbits,cherries" ?\, ?\" "\n")
                 '(("apples" "bananas" "carrots") ("monkies" "rabbits" "cherries")))))

(ert-deftest parse-csv-string-rows/three-simple-lines-with-empy-line-correctly ()
  "Should parse three lines with a blank middle row correctly"
  (should (equal (parse-csv-string-rows "apples,bananas,carrots\n\nmonkies,rabbits,cherries" ?\, ?\" "\n")
                 '(("apples" "bananas" "carrots") ("") ("monkies" "rabbits" "cherries")))))

(ert-deftest parse-csv-string-rows/three-simple-lines-with-empy-line-correctly ()
  "Should parse two lines with a multiline row correctly"
  (should
   (equal
    (parse-csv-string-rows "apples,bananas,\"carrots\nare delicious\"\nmonkies,rabbits,cherries" ?\, ?\" "\n")
    '(("apples" "bananas" "carrots\nare delicious") ("monkies" "rabbits" "cherries")))))
