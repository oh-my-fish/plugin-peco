function wrn
  set -l creg (set_color normal)(set_color yellow)
  set -l cbld (set_color yellow --bold)
  set -l bold false
  while string match -qe '|' "$argv"
    if test $bold = false
      set argv (string replace '|' "$cbld" "$argv"); set bold true
    else
      set argv (string replace '|' "$creg" "$argv"); set bold false
    end
  end
  echo $cbld"! "$creg"$argv"(set_color normal)
end

function err
  set -l creg (set_color normal)(set_color red)
  set -l cbld (set_color red --bold)
  set -l bold false
  while string match -qe '|' "$argv"
    if test $bold = false
      set argv (string replace '|' "$cbld" "$argv"); set bold true
    else
      set argv (string replace '|' "$creg" "$argv"); set bold false
    end
  end
  echo $creg"✘ $argv"(set_color normal)
end

function check_peco
  set -l message "For more information on downloading and installing peco, visit https://github.com/repos/peco/peco"


  # Determine the current kernel
  set -l kernel
  if string match -q Darwin (uname --kernel-name)
    set kernel darwin
  else if string match -q Linux (uname --kernel-name)
    set kernel linux
  else
    echo $message; return 1
  end

  # Determine the current architecture
  set -l arch
  if string match -q x86_64 (uname --machine)
    set arch amd64
  else if string match -q i386 (uname --machine)
    set arch 386
  else if string match -qe arm (uname --machine)
    set arch arm
  else
    echo $message; return 1
  end

  # Find a local bin.
  set -l bin
  if not string match -r "^($HOME|/data).*bin\$" $PATH | read bin
    echo $message; return 1
  end

  # Get peco's latest release source
  set -l source
  if not curl -s https://api.github.com/repos/peco/peco/releases/latest \
  | string match -r "(?<=\"browser_download_url\": \").*$kernel.*$arch.*(?=\")" \
  | read source
    echo $message; return 1
  end

  # Check if Peco is not installed or there is a more recent version is available
  if type -qf peco
    string match -r 'v[0-9\.]+' $source | read -l latest
    peco --version | awk '{print $3}' | string match -q $latest
    and return 0
    wrn "A more recent version of peco, |$latest| is available"
    rm (whereis peco)
  end

  # Offer to download peco
  echo "Download and extract peco into $bin?"
  read -lP "[y/n]: " opt
  if string match -qr '(?i)^y$' $opt
    echo $message; return 1
  end
  mkdir -p $bin
  if not wget -P $bin $source
    err "Failed to download.";
    echo $message; return 1
  end

  # Extract it in the local bin.
  set -l file $bin/(basename $source)
  string match -r '\.zip$' $file
  and unzip $file -d $bin
  or tar -xzvf $file -C $bin
  set -l folder (string match -r '.*/[^\.]+' $file)
  mv $folder/peco $bin
  rm -r $folder $file
end

function check_peco_dependencies
  set -l failed
  if not type -qf locate
    wrn "peco --open needs package |mlocate|. Install it using your package manager"
    set failed true
  else if not test -s /var/lib/mlocate/mlocate.db -o \
  -s /data/data/com.termux/files/usr/var/mlocate/mlocate.db
    wrn "There's no index of files to locate from"
    read -P "Generate database index? [y/n]: "
    string match -qr '(?i)^y$' $opt
    and sudo updatedb; or set failed true
  end
  if not type -qf xdg-open
    wrn "peco --open needs package |xdg-open|. Install |xdg-utils| using your package manager"
    set failed true
  end
  test -z "$failed"; or return 1
end
