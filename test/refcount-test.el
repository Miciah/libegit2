(ert-deftest refcount ()
  (with-temp-dir path
    (run "git" "init")
    (commit-change "test" "content")
    (let ((repo (libgit-repository-open path)))
      (should (= 1 (libgit--refcount repo)))
      (let ((ref (libgit-repository-head repo)))
        (should (= 2 (libgit--refcount repo)))
        (let ((obj (libgit-reference-peel ref)))
          (should (= 3 (libgit--refcount repo))))))))