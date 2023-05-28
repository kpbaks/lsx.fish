function lsbind --description "List your key bindings in a nice way!"
    set -l options (fish_opt --short=h --long=help)
    set --append options (fish_opt --short=n --long=no-preset --long-only)

    if not argparse $options -- $argv
        return 1
    end

    if set --query _flag_help
        set -l usage "List your key bindings in a nice way!

Usage: $(set_color blue)$(status  current-command)$(set_color normal) [options]

$(set_color yellow)Options:$(set_color normal)
	$(set_color green)-h$(set_color normal), $(set_color green)--help$(set_color normal)       Show this help message and exit
	$(set_color green)-n$(set_color normal), $(set_color green)--no-preset$(set_color normal)  Don't show preset key bindings
"
        echo $usage
        return 0
    end


	set -l reset (set_color normal)
	set -l green (set_color green)
	set -l yellow (set_color yellow)
	set -l blue (set_color blue)
	set -l red (set_color red)
	set -l cyan (set_color cyan)
	set -l magenta (set_color magenta)



	set -l keybindings_count 0

    bind \
        | while read -l line
        set keybindings_count (math $keybindings_count + 1)
        set -l tokens (string split " " $line)[2..]
        if test $tokens[1] = --preset
            if set --query _flag_no_preset
                continue
            end
            # remove the --preset flag
            set tokens $tokens[2..]
        end
        set -l key $tokens[1]
        set -l command "$tokens[2..]"

        if test (string sub --start=1 --length=2 -- $key) = '\\c'
            set -l key (string sub --start=3 -- $key)
            printf "%sctrl%s+%s" $green $reset (string unescape $key)
        else if test (string sub --start=1 --length=2 -- $key) = '\\e'
            set -l key (string sub --start=3 -- $key)
            printf "%salt%s+%s" $red $reset (string unescape $key)
        else if test "$key" = "\\r" # carriage return
			printf "%senter%s" $cyan $reset
        else if test $key = "\\n"
			printf "%snewline%s" $cyan $reset
        else if test "$key" = "\\b"
			printf "%sbackspace%s" $magenta $reset
        else
            printf "%s" $key
        end

        printf "\t"

        # check if the first and last character of the command is a quote
        # if so, remove them
        # this is to make `fish_indent` not highlight the command as a string
        if test (string sub --start=1 --length=1 -- $command) = "'" -a (string sub --end=1 -- $command) = "'"
            set command (string sub --start=2 --end=-1 -- $command)
			echo $command | fish_indent --ansi
        else
			string unescape $command | fish_indent --ansi
        end
    end

	echo "$keybindings_count key bindings in total"



end
