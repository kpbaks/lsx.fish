function lsvar --description "List fish variables in a nice way!"
    set -l options (fish_opt --short=h --long=help)
    set -a options (fish_opt --short=g --long=global)
    set -a options (fish_opt --short=l --long=local)
    set -a options (fish_opt --short=x --long=export)
    set -a options (fish_opt --short=U --long=universal)
    if not argparse $options -- $argv
        return 1
    end

    set -l argc (count $argv)

    if set --query _flag_help
        set -l usage "$(set_color --bold)List fish variables in a nice way!$(set_color normal)

$(set_color yellow)Usage:$(set_color normal) $(set_color blue)$(status current-command)$(set_color normal) [options]

$(set_color yellow)Arguments:$(set_color normal)

$(set_color yellow)Options:$(set_color normal)
	$(set_color green)-h$(set_color normal), $(set_color green)--help$(set_color normal)      Show this help message and exit


	"

        echo $usage
        echo ""
        printf "%sdefined in %s%s\n" (set_color --bold) (status current-filename) (set_color normal)
        return 0
    end



    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l yellow (set_color yellow)
    set -l reset (set_color normal)
    set -l red (set_color red)
    if set --query _flag_global
        set -l vars
        set -l vals
        set --global \
            | while read -l var val
            set -a vars $var
            set -a vals $val
        end
        set -l length_of_longest_var_name 0
        for var in $vars
            set -l l (string length $var)
            test $l -gt $length_of_longest_var_name; and set length_of_longest_var_name $l
        end

        for i in (seq (count $vars))
            set -l var $vars[$i]
            set -l val $vals[$i]
            set -l l (string length $var)
            set -l c (math "$length_of_longest_var_name - $l")
            set -l rpad (string repeat --count $c " ")

            printf "%s%s%s%s%s%s%s\n" $green $var $reset $rpad $blue $val $reset
        end
    end

end
