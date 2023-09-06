@'
#!/bin/sh
set -eu

if [ $# -gt 0 ] && [ "${1#-}" != "$1" ]; then
    set -- kubectl "$@"
elif [ $# -gt 0 ] && kubectl "$1" --help > /dev/null 2>&1; then
    set -- kubectl "$@"
fi

exec "$@"
'@
