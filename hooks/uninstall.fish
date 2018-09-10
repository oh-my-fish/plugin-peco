# Offer to remove peco as well
if type -qf peco
  read -lp 'wrn "Remove peco as well? [y/n]: "' opt
  string match -qr '(?i)^y$' $opt; and rm (whereis peco)
end
