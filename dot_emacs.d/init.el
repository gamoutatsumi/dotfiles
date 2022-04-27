;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; Now you can use leaf!
(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)
(leaf transient-dwim
  :ensure t
  :bind (("M-=" . transient-dwim-dispatch)))

(leaf ddskk 
      :ensure t
      :bind (("C-x C-j" . skk-mode))
      :custom ((default-input-method . "japanese-skk")
               (skk-server-portnum . 1178)
               (skk-server-host . "localhost")
               (skk-egg-like-newline . t)))

(leaf darcula-theme
      :ensure t
      :require t
      :config 
      (load-theme 'darcula t))

(leaf ein
      :ensure t
      :require t
      :custom ((ein:worksheet-enable-undo . t)))

(leaf lsp-mode
      :ensure t
      :require t)

(defvar user/standard-fontset
  (create-fontset-from-fontset-spec standard-fontset-spec)
  "Standard fontset for user.")
(defvar user/font-size 16
  "Default font size in px.")
(defvar user/cjk-font "HackGen Nerd" "Default font for CJK characters.")
(defvar user/latin-font "HackGen Nerd" "Default font for Latin characters.")
(defvar user/unicode-font "Noto Emoji" "Default font for Unicode characters, including emojis.")

;; ...
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("79586dc4eb374231af28bbc36ba0880ed8e270249b07f814b0e6555bdcb71fab" default))
 '(package-selected-packages
   '(blackout el-get hydra leaf-keywords leaf ddskk)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
