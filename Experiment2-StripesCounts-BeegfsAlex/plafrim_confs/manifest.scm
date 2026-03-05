;; Manifest verrouillé sur un commit spécifique pour gyselalibxx
(use-modules (guix transformations))


;; Transformation spécifique pour gyselalibxx
(define transform-gyselalibxx
      (options->transformation
            '((with-commit . "gyselalibxx=3e458a1e32f0407144cf58d51ff9e80d46a436d1"))))

;; Transformation générique pour les autres paquets
(define transform-default
      (options->transformation
            '((with-latest . "ddc"))))

            (packages->manifest
                  (list
                        (transform-default
                              (specification->package "coreutils"))
                             
                        (transform-gyselalibxx
                              (specification->package "gyselalibxx"))
                                           
                        (transform-default
                              (specification->package "slurm@23.11.11"))))

