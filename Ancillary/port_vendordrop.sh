# port_vendordrop
#  Drop the content of the ports dir into our directory

# Usage: sh Ancillary/port_vendordrop.sh ocaml tuareg-mode.el

port_repository='svn://svn.de.freebsd.org/ports'
port_branch='head'
port_dbdir='Library'
port_tmpdir='/tmp/'


# port_mkportdir PORTDIR
#  Open PORTDIR in the LIBRARY
port_mkportdir()
{
    install -d "$port_dbdir/$1"
}


# port_export PORTDIR ORIGIN
#  Export SVN upstream ORIGIN into PORTDIR
port_export()
{
    local status

    env LANG=C svn export "${port_repository}/${port_branch}/$2" "$1" \
	> "$port_tmpdir/svn-export-$$.log"

    status=$?

    if [ $status ]; then
	sed -n -e '/^Exported revision/{s/^Exported revision //;s/\.$//;p;}' \
	    < "$port_tmpdir/svn-export-$$.log"
    else
	echo 'failed'
    fi

    return $status
}


# port_vendordrop PORTDIR ORIGIN
#  Export SVN upstream ORIGIN into PORTDIR
port_vendordrop()
{
    local status
    local vendordrop

    install -d "$1"

    vendordrop=`port_export "$2.new" "$2"`
    status="$?"

    if [ $status ]; then
	mv "$2" "$2.old" \
	    && mv "$2.new" "$2" \
	    && rm -r -f "$2.old"

	port_mkportdir "$1"

	echo "$vendordrop" > "$port_dbdir/$1/+VENDORDROP"
    else
	rm -r -f "$1.new"
    fi

    return $status
}


# port_vendordrop_iter
#  Iterate port_vendordrop over stdin
port_vendordrop_iter()
{
    local saved_ifs
    local portdir
    local origin
    local revision

    saved_ifs="$IFS"
    IFS='|'
    while read portdir origin; do
	port_vendordrop "$portdir" "$origin"
	revision=`cat "$port_dbdir/$portdir/+VENDORDROP"`
	printf 'Vendor drop %s %s: %s\n' "$revision" "$portdir" "$origin"
    done
    IFS="$saved_ifs"
}

port_vendordrop_select()
{
    if [ $# -gt 0 ]; then
	awk -F'|' -v OFS='|' -v port="$1" '$1 == port {print}'
    else
	cat
    fi
}

(
    port_vendordrop_select "$@" \
	| port_vendordrop_iter
) < ORIGIN
