#
# zaw-move-dir
#

function zaw-src-move-dir() {
    local root parent d f
    setopt local_options null_glob

    if (( $# == 0 )); then
        root="${PWD}/"
    else
        root="$1"
    fi

    parent="${root:h}"
    if [[ "${parent}" != */ ]]; then
        parent="${parent}/"
    fi
    BUFFER="$root"
    
    candidates+=("${root}")
    cand_descriptions+=(".")
    candidates+=("${parent}")
    cand_descriptions+=("..")

    # TODO: symlink to directory
    for d in "${root%/}"/*(/); do
        candidates+=("${d}/")
        cand_descriptions+=("${d:t}/")
    done

#    for f in "${root%/}"/*(^/); do
#        candidates+=("${f}")
#        cand_descriptions+=("${f:t}")
#    done

    actions=( "zaw-callback-move-dir" )
    act_descriptions=( "move directory" )
    # TODO: open multiple files
    #options=( "-m" )
    #options=( "-t" "${root}" )
}

zaw-register-src -n move-dir zaw-src-move-dir

function zaw-callback-move-dir() {
    # TODO: symlink to directory
    if [[ "$1" != "$BUFFER" ]]; then
        zaw zaw-src-move-dir "$1"
    else
        BUFFER="cd ${(q)1}"
	CURSOR=$#BUFFER
        accept-line
    fi
}
