function lsalias --description 'List your aliases in an nice way!'

    set -l hr (string repeat --count $COLUMNS '━')
    # set -l bar "|"
    set -l bar "┃"

    set -l aliases
    set -l expansions

    alias | while read -d " " -l keyword alias expansion
        set -a aliases $alias
        set -a expansions $expansion
    end

    set -l length_of_longest_alias 0
    for alias in $aliases
        set -l length_of_alias (string length -- $alias)
        if test $length_of_alias -gt $length_of_longest_alias
            set length_of_longest_alias $length_of_alias
        end
    end

    echo $hr

    set -l reset (set_color normal)
    set -l bold (set_color --bold)
    set -l red (set_color red)

    set -l alias_header ALIAS
    set -l expansion_header EXPANSION
    set -l alias_header_length (string length -- $alias_header)
    set -l padding_length (math $length_of_longest_alias - $alias_header_length)
    set -l padding (string repeat --count $padding_length " ")
    printf "%s%s%s%s%s%s\n" $padding $bold $alias_header $reset " $bar " $expansion_header
    echo $hr

    for i in (seq (count $aliases))
        set -l alias $aliases[$i]
        set -l expansion $expansions[$i]
        # check if the first and last character of the expansion is a quote
        # if so, remove them
        # this is to make `fish_indent` not highlight the expansion as a string
        if test (string sub --start=1 --length=1 -- $expansion) = "'" -a (string sub --end=1 -- $expansion) = "'"
            set expansion (string sub --start=2 --end=-1 -- $expansion)
        end
        set -l length_of_alias (string length -- $alias)
        set -l padding_length (math $length_of_longest_alias - $length_of_alias)
        set -l padding (string repeat --count $padding_length " ")
        printf "%s%s%s%s%s" $padding $bold $alias $reset " $bar "
        echo $expansion | fish_indent --ansi
    end

    echo $hr
end
