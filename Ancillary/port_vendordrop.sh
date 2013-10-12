# port_vendordrop
#  Drop the content of the ports dir into our directory

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

    vendordrop=`port_export "$1.new" "$2"`
    status="$?"

    if [ $status ]; then
	mv "$1" "$1.old" \
	    && mv "$1.new" "$1" \
	    && rm -r -f "$1.old"

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

port_vendordrop_iter < ORIGIN
