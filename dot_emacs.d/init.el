;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf t))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get 
          :ensure t
          :init (setq el-get-git-shallow-clone t))
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

(leaf org
      :ensure t
      :require t)

(leaf tree-sitter
      :ensure (t tree-sitter-langs)
      :require tree-sitter-langs
      :config
      (global-tree-sitter-mode)
      (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(leaf ddskk 
      :ensure t
      :bind (("C-x C-j" . skk-mode))
      :custom ((default-input-method . "japanese-skk")
               (skk-server-portnum . 1178)
               (skk-server-host . "localhost")
               (skk-egg-like-newline . t)))


(leaf modus-themes
      :ensure t
      :preface
      (defun my:set-background (&optional frame)
        "Unsets the background color for transparency"
        (or frame
            (setq frame (selected-frame)))
        (if (display-graphic-p frame)
          (progn
            (set-frame-parameter nil 'alpha '(80 50))
            (add-to-list 'default-frame-alist '(alpha 80 50)))
          (set-face-background 'default "unspecified-bg" frame)))
      :advice
      ((:after modus-themes-load-vivendi
               my:set-background)
       (:after modus-themes-load-operandi
               (lambda ()
                 (set-face-background 'default "#FFFFFF"))))
      :hook
      ((window-setup-hook . my:set-background)
       (tty-setup-hook . my:set-background))
      :custom
      `(
        (modus-themes-bold-constructs . nil)
        (modus-themes-italic-constructs . t)
        (modus-themes-region . '(bg-only no-extend))
        )
      :init
      `(
       (modus-themes-load-themes)
       (modus-themes-load-operandi)
       )
      :config
      (eval-when-compile
        (require 'modus-themes))
      )

(leaf ein
      :ensure t
      :require t
      :custom ((ein:worksheet-enable-undo . t)))

(leaf lsp-mode
      :ensure t
      :require t)

(leaf go-mode
      :ensure t
      :require t)

(leaf bind-key
      :ensure t
      :require t)

(leaf htmlize
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
 '(package-selected-packages '(blackout el-get hydra leaf-keywords leaf ddskk)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(if window-system (progn
                    (require 'server)
                    (unless (server-running-p)
                      (server-start) )))

(if window-system (progn
                    (bind-key "C-x C-c" 'kill-this-buffer)
                    (when (equal system-type 'darwin)
                      (setq mac-option-modifier 'meta))))
(setq make-backup-files nil) 
