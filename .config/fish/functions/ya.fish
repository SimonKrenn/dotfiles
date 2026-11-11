function ya
  set tmp (mktemp -t "yazi-cwd.XXXXX")
  yazi $argv --cwd-file="$tmp"
  if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
    cd -- "$cwd"
  end
  rm -f -- "$tmp"
end
