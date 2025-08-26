Configuration for nvim
======================

This directory contains configuration files as well as packages for neovim.

You can source each config .vim file at your discretion.

The directory ``pack`` contains packages. Usually they are added as git
submodules. You can symlink to it in you configuration directly as in the
example below::

  ln -s $(pwd)/pack ~/.config/nvim/pack/stuff

