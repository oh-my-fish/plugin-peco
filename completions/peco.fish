set -l cmd (basename (status -f) | cut -f 1 -d '.')

# Native options
complete -c $cmd -d 'Simplistic interactive filtering tool'
complete -fc $cmd -s h -l help -d 'display instructions'
complete -rc $cmd -l query -d 'initial value for query'
complete -c $cmd -l rcfile -d 'path to the settings file'
complete -fc $cmd -l version -d 'print the version and exit'
complete -xc $cmd -s b -l buffer-size -d 'number of lines to keep in search buffer'
complete -fc $cmd -l null -d 'expect NUL (\0) as separator for target/output'
complete -fc $cmd -l initial-index -d 'position of the initial index of the selection (0 base)'
complete -xc $cmd -l initial-filter -d 'specify the default filter' -a 'IgnoreCase CaseSensitive SmartCase Regexp Fuzzy'
complete -fc $cmd -l prompt -d 'specify the prompt string'
complete -xc $cmd -l layout -d 'layout to be used' -a 'top-down bottom-up'
complete -fc $cmd -l select-1 -d 'select first item and immediately exit if the input contains only 1 item'
complete -xc $cmd -l on-cancel -d 'specify action on user cancel' -a 'success error'
complete -fc $cmd -l selection-prefix -d 'use a prefix instead of changing line color to indicate currently selected lines'
complete -fc $cmd -l prompt -d 'execute command instead of finishing/terminating peco.'

# Fish options
complete -fc $cmd -s y -l history -d 'search for commands in your history'
complete -fc $cmd -s t -l terminate -d 'search for processes to terminate'
complete -fc $cmd -s o -l open -d 'search for files to open'
