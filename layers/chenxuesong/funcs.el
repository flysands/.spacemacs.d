;;; Package --- chenxuesong private fucntion
;;; Commentary:
;;; Code:

(setq chenxueosng-blog-dir "~/Work/blog/")
(defun chenxuesong-review-code-post-g (args)
  "Review with rbt post -g."
  (interactive "P")
  (let ((default-directory (concat (magit-git-dir)
                                   "/../")) output)
    (async-start (lambda ()
                   (message "start review")
                   (setq output (shell-command-to-string "rbt post -g"))
                   (if (string-match "http://.+" output)
                       (substring output
                                  (match-beginning 0)
                                  (match-end 0))
                     nil))
                 (lambda (result)
                   (if result
                       (progn
                         (message result)
                         (browse-url result))
                     (message "result error %s" result))))))

(defun chenxuesong-review-code-post-r (review-id)
  "Review with rbt post -r id."
  (interactive "sWhich review your want again? ")
  (let ((default-directory (concat (magit-git-dir)
                                   "/../")) output)
    (async-start
     `(lambda ()
        (message "start review")
        (setq output (shell-command-to-string (concat "rbt post -r" ,review-id)))
        (if (string-match "http://.+" output)
            (substring output
                       (match-beginning 0)
                       (match-end 0))
          nil))
     (lambda (result)
       (if result
           (progn
             (message result)
             (browse-url result))
         (message "result error %s" result))))))

(defun chenxuesong-start-emacs-client ()
  (interactive)
  (async-start (lambda ()
                 (shell-command-to-string "/usr/local/Cellar/emacs/24.5/bin/emacsclient -c"))))

(defun chenxuesong-review-code-open (review-id)
  "Open the review board with review id."
  (interactive "sWhich review post you want read? ")
  (browse-url (concat "http://reviewboard.testbird.io/r/"
                      review-id)))

(defun chenxuesong-review-code-diff (review-id)
  "Open the review board with review id."
  (interactive "sWhich review post you want view diff? ")
  (browse-url (concat "http://reviewboard.testbird.io/r/"
                      review-id "/diff")))

(defun chenxuesong-qiniu-upload-img (command)
  (let ((command-str (format "~/Work/dev-tools/qiniu-devtools/qrsync %s"
                             command)))
    (shell-command-to-string command-str)))

(defun chenxuesong-qiniu-achieve-image ()
  (shell-command-to-string "cp -rf ~/Work/blog/images/* ~/Work/blog/images-achieve")
  (shell-command-to-string "rm -f ~/Work/blog/images/*"))

(defun chenxuesong-copy-image-to-public-dir ()
  (shell-command-to-string "cp -rf ~/Work/blog/images/* ~/Work/blog/public/images"))

(defun chenxuesong-hexo-generate (args)
  (interactive "P")
  (let ((default-directory chenxueosng-blog-dir))
    (shell-command-to-string "hexo generate")
    (message "hexo generate complete.")))

(defun chenxuesong-hexo-deploy (args)
  (interactive "P")
  (let ((default-directory chenxueosng-blog-dir))
    ;; (chenxuesong-qiniu-upload-img (concat chenxueosng-blog-dir "qiniu.json"))
    (chenxuesong-copy-image-to-public-dir)
    (shell-command-to-string "hexo deploy --generate")
    ;; (chenxuesong-qiniu-achieve-image)
    (message "hexo deploy complete.")))

(defun chenxuesong-insert-qiniu-link (imagename)
  (interactive "sImage name: ")
  (insert (concat (format "[[%s%s]]" "http://7xia6k.com1.z0.glb.clouddn.com/"
                          imagename))))

(defun chenxuesong-set-image-name (name)
  (interactive "sDocker Image Name? ")
  (save-excursion
    (goto-char (point-min))
    (insert (format "## -*- docker-image-name: \"%s\" -*-\n"
                    name))))

(defun chenxuesong-delete-ds-store (args)
  (interactive "P")
  (let ((default-directory (concat (magit-git-dir)
                                   "/../")))
    (message default-directory)
    (async-start (lambda ()
                   (message "delete .ds_store")
                   (shell-command-to-string (format "find %s -name \".DS_Store\" -depth -exec rm {} \\;"
                                                    default-directory))))))


;; (defun my-fundamental-face ()
;;   "Set font to a variable width (proportional) fonts in current buffer"
;;   (interactive)
;;   (setq buffer-face-mode-face '(:family "DejaVu Sans Mono" :height 100 :width semi-condensed))
;;   (buffer-face-mode))


(defun chenxuesong-indent-org-block-automatically ()
  (when (org-in-src-block-p)
    (org-edit-special)
    (indent-region (point-min) (point-max))
    (org-edit-src-exit)))

(defun chenxuesong-replace-punctuation ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "，" nil t)
      (replace-match ","))
    (goto-char (point-min))
    (while (search-forward "。" nil t)
      (replace-match "."))
    (goto-char (point-min))
    (while (search-forward "、" nil t)
      (replace-match ","))
    )
  )

(defun chenxuesong-indent-org-block-cmd ()
  (interactive)
  (chenxuesong-indent-org-block-automatically))

(defun notify-osx (title message)
  (call-process "terminal-notifier"
                nil 0 nil
                "-group" "Emacs"
                "-title" title
                "-message" message
                "-activate" "org.gnu.Emacs"))

(defun chenxuesong-ledger-insert-liabilities ()
  (interactive)
  (org-capture 0 "fl"))

(defun chenxuesong-ledger-insert-expense ()
  (interactive)
  (org-capture 0 "fe"))

