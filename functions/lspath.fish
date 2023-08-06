function lspath --description 'List the paths in $PATH in a human readable way'
    set -l options (fish_opt --short=h --long=help)
    set -a options (fish_opt --short=n --long=no-legend)
    if not argparse $options -- $argv
        return 1
    end

    if not isatty stdout
        # stdout is not a tty, so we can't colorize the output
        # it is probably piped to another program
        for i in (seq (count $PATH))
            echo $PATH[$i]
        end
        return 0
    end

    # output is colorized if stdout is a tty
    set -l reset (set_color normal)
    set -l red (set_color red)
    set -l green (set_color green)
    set -l blue (set_color blue)
    set -l yellow (set_color yellow)
    set -l italics (set_color --italics)

    if not set --query _flag_no_legend
        printf "paths in %s\$PATH%s (%spaths with lower numbers are searched first%s):\n" $blue $reset $italics $reset
        printf "- paths colored %sred%s do not exist!\n" $red $reset
        printf "- paths colored %syellow%s do not contain any executables\n" $yellow $reset
        printf "- the number in parentheses indicate how many executables are in that directory\n"
        echo ""
    end

    set -l paths_not_found_count 0
    set -l paths_with_executables_count 0
    set -l executable_count 0
    set -l odd 1
    for i in (seq (count $PATH))
        set -l p $PATH[$i]
        set -l fmt
        if test $odd -eq 1
            set odd 0
        else
            set odd 1
        end
        if not test -d $p
            set --prepend fmt red
            set paths_not_found_count (math $paths_not_found_count + 1)
        else
            # check how many executables are in the path
            # and colorize the path accordingly
            # set -l num_executables (find -L $p -maxdepth 1 -type f -executable | count)
            # set -l num_executables (find $p -maxdepth 1 -type f -executable | count)
            set -l num_executables (path filter -x $p/* | count)
            set executable_count (math $executable_count + $num_executables)
            if test $num_executables -eq 0
                set --prepend fmt yellow
            else
                set paths_with_executables_count (math $paths_with_executables_count + 1)
            end
            set p "$p ($num_executables)"
        end

        set_color $fmt
        printf "%2d. %s\n" $i $p
        set_color reset
    end

    # print summary
    if test $paths_not_found_count -gt 0
        echo "" # newline
        set_color --bold red
        echo "$paths_not_found_count paths do not exist!"
        echo "you should remove them from \$PATH"
        set_color reset
    end

    set -l paths_without_executables_count (math (count $PATH) - $paths_with_executables_count)
    if test $paths_without_executables_count -gt 0
        echo "" # newline
        printf "%s%d%s paths does not contain any executables!\n" $yellow $paths_without_executables_count $reset
    end

    if test $executable_count -gt 0
        echo "" # newline
        printf "%s%d%s executables found in \$PATH\n" $green $executable_count $reset
    end
end
