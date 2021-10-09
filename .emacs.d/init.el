;; initialize
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

;; el-get
(unless (file-exists-p (locate-user-emacs-file "el-get")) (shell-command
                               (mapconcat #'shell-quote-argument
                                          (list "git" "clone" "https://github.com/dimitri/el-get.git" (expand-file-name(locate-user-emacs-file "el-get")))
                                          " ")))
(add-to-list 'load-path (locate-user-emacs-file "el-get"))
(require 'el-get)
(setq el-get-dir (locate-user-emacs-file "elisp"))
(el-get-bundle elpa:ddskk)
(el-get-bundle elpa:undo-tree)
(el-get-bundle evil)
(evil-mode 1)
(setq auto-sae-default nil)
