function lsenv --description 'List environment variables in a nice way!'
    set -l cols $COLUMNS
    set -l var_with_longest_name ''
    env | while read --delim = -l var val
        if test (string length $var) -gt (string length $var_with_longest_name)
            set var_with_longest_name $var
        end
    end
    set -l length_of_var_with_longest_name (string length $var_with_longest_name)

    # todo: alternating colors per row

    set -l prefix ''
    set -l length_of_prefix (string length $prefix)
    set -l normal (set_color normal)
    env | sort | while read --delim = -l var val
        set -l color_var green --bold
        set -l length_of_var (string length $var)


        if string match --quiet --regex '^\s*$' -- "$val"
            # echoc red "\$var = $val"
            set color_var black --background=yellow
        end
        set -l space_between_var_and_equal (string repeat --no-newline --count (math $length_of_var_with_longest_name - $length_of_var) ' ')

        if test (string length "$space_between_var_and_equal") -eq 0
            set space_between_var_and_equal ' '
        else
            set space_between_var_and_equal "$space_between_var_and_equal "
        end

        set -l MAGIC_NUMBER 6 # do not ask me why this is needed

        set -l cols_left_for_val (math "$cols - " $length_of_var " - " (string length $space_between_var_and_equal) " - " $length_of_prefix "- $MAGIC_NUMBER")

        # echo "\$val: $val"
        # set val (string collect --allow-mpty $val)
        set val (ellipsize $cols_left_for_val "$val")
        # echo "\$val: $val"

        printf "%s%s%s%s%s= %s%s%s\n" $prefix (set_color $color_var) $var $normal $space_between_var_and_equal (set_color $color_val) $val $normal

    end
end
