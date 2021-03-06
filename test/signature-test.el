(ert-deftest signature-default ()
  (with-temp-dir path
    (init)
    (let* ((repo (libgit-repository-open path))
           (config (libgit-repository-config repo)))
      (libgit-config-set-string config "user.name" "Ludwig van")
      (libgit-config-set-string config "user.email" "somewhere@bonn.de")
      (let ((sig (libgit-signature-default repo)))
        (should (libgit-signature-p sig))
        (should (string= "Ludwig van" (libgit-signature-name sig)))
        (should (string= "somewhere@bonn.de" (libgit-signature-email sig)))))))

(ert-deftest signature-now ()
  (let ((sig (libgit-signature-now "Ludwig van Beethoven" "somewhere@bonn.de")))
    (should (libgit-signature-p sig))
    (should (string= "Ludwig van Beethoven" (libgit-signature-name sig)))
    (should (string= "somewhere@bonn.de" (libgit-signature-email sig)))))

(ert-deftest signature-new ()
  (let* ((time (decode-time (current-time)))
         (sig (libgit-signature-new "a" "b" time)))
    (should (equal (libgit-signature-time sig) time))))

(ert-deftest signature-from-string ()
  (let* ((str "Ludwig van Beethoven <somewhere@bonn.de> 123456 +0100")
         (sig (libgit-signature-from-string str)))
    (should (string= "Ludwig van Beethoven" (libgit-signature-name sig)))
    (should (string= "somewhere@bonn.de" (libgit-signature-email sig)))
    ;; 2^16 * 1 + 57920 = 123456
    (should (equal '(1 57920) (apply 'encode-time (libgit-signature-time sig))))
    (should (= 3600 (car (last (libgit-signature-time sig)))))))
