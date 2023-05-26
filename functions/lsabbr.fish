function lsabbr
    set -l abbrs
    set -l expansions
    abbr --show \
        | cut -d -- -f 2 \
        | while read -d -- abbr expansion
        set -a abbrs $abbr
        set -a expansions $expansion
    end

    return


    set -l length_of_longest_abbr 0
    for abbr in $abbrs
        set -l abbr_length (string length $abbr)
        if test $abbr_length -gt $length_of_longest_abbr
            set length_of_longest_abbr $abbr_length
        end
    end


    set -l abbreviation_heading abbreviation
    set -l expansion_heading expanded
    set -l padding_length (math $length_of_longest_abbr - (string length $abbreviation_heading))
    set -l padding (string repeat --count $padding_length ' ')
    set -l hr (string repeat --count $COLUMNS -)

    echo $hr
    printf "%s%s | %s\n" $abbreviation_heading $padding $expansion_heading
    echo $hr

    set -l reset (set_color normal)

    for i in (seq (count $abbrs))
        set -l abbr $abbrs[$i]
        set -l expansion $expansions[$i]
        set -l abbr_length (string length $abbr)
        set -l padding_length (math $length_of_longest_abbr - $abbr_length)
        set -l padding (string repeat --count $padding_length ' ')
        printf "%s%s | " $abbr $padding
        echo "$expansion" | fish_indent --ansi
    end

    echo $hr
end
