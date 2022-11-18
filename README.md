# docker-emacs-native
Docker file to build emacs 28 with native compilation (should be faster)

Taken from [Mastering Emacs Native Lisp
Compilation](https://www.masteringemacs.org/article/speed-up-emacs-libjansson-native-elisp-compilation),
with thanks!

Modified to build from ./emacs

## first, clone the emacs source

git clone https://git.savannah.gnu.org/git/emacs.git
apt-get update

source will be in ./emacs now.

## second, build the docker container

docker build -t "emacs-native-comp" .

## third, run the docker container

docker run -it -e DISPLAY -v ~/Projects:/home/<user>/Projects --net=host emacs-native-comp

this will give you a bash shell with emacs29 linked to emacs, so just type emacs
to start. 

This is useful for debugging, especially as the correct .Xauthority file needs
to be passed in for graphics to work. We do this in our docker-spacemacs github repo.
