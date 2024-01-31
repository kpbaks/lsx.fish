function lssys \
    --description "List `sysctl` settings in a pretty format"

    if not command --query sysctl
        echo "sysctrl is not installed"
        return 1
    end

    set -l green (set_color green)
    set -l red (set_color red)
    set -l yellow (set_color yellow)
    set -l reset (set_color normal)

    set -l vars
    set -l vals
    command sysctl --all 2>/dev/null \
        | while read --delimiter "=" var val
        set -a vars $var
        set -a vals $val
    end
    for var in $vars
        set -l splitted (string split "." $var)
        for group in $splitted[1..-2]
            echo $group
            if set --query lssys_$group
                set -f lssys_$group $var
                printf "  %s%s%s\n" $green $var $reset

            end
        end
    end

end
