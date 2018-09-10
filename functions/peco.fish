set -l cmd (basename (status -f) | cut -d '.' -f 1)
function $cmd -V cmd
  argparse 'y/history' 't/terminate' 'o/open' 'h/help' -- $argv 2>/dev/null
  if test (set --names | string match -r '_flag_.$' | wc -l) -gt 1
    err 'Invalid flag combination'; return 1
  end

  # Check if peco is installed
  if not type -qf peco
    wrn "|peco| is not installed"
    check_peco; or return 1
  end

  # Query command history
  if set --query _flag_history
    set -l result (history | peco --query "$argv")
    test -n "$result"; and echo; or return 1
    for command in $result; eval $command; end

  # Query processes to be terminated
  else if set --query _flag_terminate
    ps ax -o pid,time,command | string match -vr "^peco --query $argv" \
    | peco --query "$argv" | awk '{print $1}' | xargs kill 2>/dev/null

  # Query files to be opened
  else if set --query _flag_open
    check_peco_dependencies; or return 1
    if test -z "$argv"
      err "No argument passed"
      return 1
    end
    set -l query
    for match in (locate "$argv")
      test -d $match; and continue
      string match -qr '/(\.git|Trash)/' $match; and continue
      set query $query $match
    end
    test -n "$query"; or return 1
    set -l result (printf "%s\n" $query | peco --query "$argv" --select-1)
    for file in $result; xdg-open $file; end

  # Show instructions
  else if set --query _flag_help
    cat (dirname (status -f))/instructions; test -z "$argv"

  # If the wrapper function's flags aren't used, pass arguments directly
  else; command peco $argv; end
end
