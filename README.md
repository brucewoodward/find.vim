# Copyright 

This code is released into the public domain.

# Overview

Vim script to allow for the quick loading of files in the current directory
and any subdirectories.

# Installation

Copy the script to ~/.vim/plugin or ~/vimfiles/plugin on windows.

# How to use.

From command mode call the Find function with a text to match against file
names or buffer names. Use the tab key to move through the matching
buffers/files and hit enter to edit/jump to the desire buffer/file.

Regular expressions are not supported.

# Subdirectory searching.

Each time the Find function is called the current directory and subdirectory
is searching. This could lead to long wait times, so be warned.

Also, there is no need to refresh after a new file has been created.

# Only switching between buffers.

If you just want to use this plugin to only switch between buffers set the global
variable g:file_finder to 0
