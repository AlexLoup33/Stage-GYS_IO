(list (channel
        (name 'guix-hpc)
        (url "https://gitlab.inria.fr/guix-hpc/guix-hpc.git")
        (branch "master")
        (commit
          "0599d0e47af92993a2b65fdd2dd4b96373289ed7"))
      (channel
        (name 'guix)
        (url "https://git.guix.gnu.org/guix.git")
        (branch "master")
        (commit
          "4a1fedd453eeb6305a64d16e88d0029cb23f998d")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
      (channel
        (name 'guix-science)
        (url "https://codeberg.org/guix-science/guix-science.git")
        (branch "master")
        (commit
          "975e0fb8e0926820c4836a9452754cd9c12638f4")
        (introduction
          (make-channel-introduction
            "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
            (openpgp-fingerprint
              "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446")))))


