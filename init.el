(package-initialize)
;;enabling elpy 
(elpy-enable)
(setq elpy-rpc-backend "jedi")
;;setting up monokai
(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'monokai t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
;;(setq electric-pair-mode t)

;; magit status key
(global-set-key (kbd "C-x g") 'magit-status)

;;helm
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

(helm-mode 1)
;;helm projectile

;; (setq helm-projectile-fuzzy-match nil)
(require 'helm-projectile)
(helm-projectile-on)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay 0.3)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "https://stable.melpa.org/packages/"))))
 '(package-selected-packages
   (quote
    (web-mode org ace-window py-autopep8 monokai-theme material-theme magit helm-swoop helm-projectile flycheck emmet-mode elpy ein company-lua company-jedi company-auctex better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'after-init-hook 'global-company-mode)
(global-company-mode t)


