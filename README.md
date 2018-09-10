<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="144px" height="144px"/>

# peco_utils

[![GPL License](https://img.shields.io/badge/license-GPL-blue.svg?longCache=true&style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v2.7.1-blue.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

<br/>

## Description

A wrapper script for [peco](https://github.com/peco/peco), the simplistic interactive filtering tool, with additional options and fully fledged completions.

## Additional options

```
-y, --history         search for commands in your history

-t, --terminate       search for processes to terminate

-o, --open            search for files to open with their default applications
```

## Install

Either with omf
```fish
omf install peco_utils
```
or using [fisherman](https://github.com/fisherman/fisherman)
```fish
fisher gitlab.com/lusiadas/peco_utils
```

## Dependencies

The `peco --open` option makes use of both `mlocate` and `xdg-open` to locate and open files respectively. These packages should be available thourgh the package manager of your distribution.

## Optional configurations

### Keybindings

By default, this script binds Alt+H, Alt+T and Alt+O to the additional fish options. Like so:

```
bind \eh 'peco --history (commandline -b); commandline -r ""'
bind \et 'peco --terminate (commandline -b); commandline -r ""'
bind \eo 'peco --open (commandline -b); commandline -r ""'
```

To change these keybindings, see `man bind`, and modify the file `key_bindings.fish`.

### Peco configuration

This is the config file that I use for `peco`:

```
{
	"Prompt": ">",
	"Layout":"bottom-up"
}
{
	"Action": {
		"selectAllAndFinish": [
			"peco.SelectAll",
			"peco.Finish"
		]
	},
	"Keymap:" {
		"C-Enter": "selectAllAndFinish"
	}
}
```

It places the search bar at the bottom of the screen, and makes `Ctrl+Enter` a shortcut to accept all options presented for the query. To be loaded by `peco`, this file should be placed at `$HOME/.config/peco/config.json`

---

Ⓐ Made in Anarchy. No wage slaves were economically coerced into the making of this work.
