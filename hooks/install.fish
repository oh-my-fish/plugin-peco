source $path/init.fish

# Check dependencies
if not type -qf peco
  wrn "|peco| is not installed"; check_peco
end
check_peco_dependencies