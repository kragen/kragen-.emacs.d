My `.emacs.d`
===========

Like everybody else, I’m checking my `.emacs.d` into Git.  In my case,
it’s primarily so I can share it between machines sanely.

Accordingly, I’m pretty much checking everything in at this point,
including stuff that’s managed other places.

To get this .emacs.d to run on Ubuntu 8.10, I had to install the
following packages:

    sudo apt-get install emacs-snapshot emacs-goodies-el \
         python-mode tuareg-mode ruby1.8-elisp php-elisp

I also needed to do this to get `gist.el`:

    git clone git://github.com/stevej/emacs /home/kragen/devel/stevej-emacs
