function lshandlers --description "List all fish handlers in a nice way!"
    set -l bold (set_color --bold)
    set -l green (set_color green)
    set -l red (set_color red)
    set -l yellow (set_color yellow)
    set -l blue (set_color blue)
    set -l magenta (set_color magenta)
    set -l cyan (set_color cyan)
    set -l reset (set_color normal)

    set -l ruler_char -

    # on-event

    set -l events
    set -l handlers
    functions --handlers --handlers-type generic \
        | tail -n +2 \
        | while read --local event handler
        set -a events $event
        set -a handlers $handler
    end

    set -l longest_event ""
    for event in $events
        if test (string length $event) -gt (string length $longest_event)
            set longest_event $event
        end
    end

    set -l length_of_longest_event (string length $longest_event)

	set -l header "Event generic "
    printf "%s%s%s%s\n" $bold $header $reset (string repeat --count (math $COLUMNS - (string length $header)) $ruler_char)

	set -l fish_preexec_color $green
	set -l fish_postexec_color $red
	set -l fish_posterror_color $red
    set -l fish_command_not_found_color $red
	set -l fish_cancel_color $red
	set -l fish_prompt_color $yellow
	set -l fish_exit_color $magenta
    set -l fish_read_color $cyan

	for i in (seq (count $events))
		set -l event $events[$i]
		set -l handler $handlers[$i]
		set -l ev_color $bold
        switch $event
			case fish_preexec
				set ev_color $fish_preexec_color
			case fish_postexec
				set ev_color $fish_postexec_color
			case fish_posterror
				set ev_color $fish_posterror_color
			case fish_command_not_found
				set ev_color $fish_command_not_found_color
			case fish_cancel
				set ev_color $fish_cancel_color
			case fish_prompt
				set ev_color $fish_prompt_color
			case fish_exit
				set ev_color $fish_exit_color
			case fish_read
				set ev_color $fish_read_color
		end

		set -l handler_color $cyan
		if string match --quiet --regex "^__fish_.*" $handler
			set handler_color $blue
		end
		set -l padding_amount (math $length_of_longest_event - $(string length $event))
		set -l padding (string repeat --count $padding_amount " ")

		printf "%s%s%s%s %s%s%s\n" \
			$ev_color $event $reset \
			$padding \
			$handler_color $handler $reset
	end

	echo "" # newline

    # --on-variable
    set -l vars
    set -l handlers

    functions --handlers --handlers-type variable \
        | tail -n +2 \
        | while read --local var handler
        set -a vars $var
        set -a handlers $handler
    end

    set -l longest_var ""
    for var in $vars
        if test (string length $var) -gt (string length $longest_var)
            set longest_var $var
        end
    end

    set -l length_of_longest_var (string length $longest_var)

    set -l header "Event variable "
    printf "%s%s%s%s\n" $bold $header $reset (string repeat --count (math $COLUMNS - (string length $header)) $ruler_char)

    for i in (seq (count $vars))
        set -l var $vars[$i]
        set -l handler $handlers[$i]
        set -l va_color $bold
        set -l handler_color $cyan
        if string match --quiet --regex "^__fish_.*" $handler
            set handler_color $blue
        end
        set -l padding_amount (math $length_of_longest_var - $(string length $var))
        set -l padding (string repeat --count $padding_amount " ")

        printf "%s%s%s%s %s%s%s\n" \
            $var_color $var $reset \
            $padding \
            $handler_color $handler $reset
    end

	# --on-sigmal
	set -l sigs
	set -l handlers

	functions --handlers --handlers-type signal \
		| tail -n +2 \
		| while read --local sig handler
		set -a sigs $sig
		set -a handlers $handler
	end

	set -l longest_sig ""
	for sig in $sigs
		if test (string length $sig) -gt (string length $longest_sig)
			set longest_sig $sig
		end
	end

	set -l length_of_longest_sig (string length $longest_sig)

	echo "" # newline

	set -l header "Event signal "
	printf "%s%s%s%s\n" $bold $header $reset (string repeat --count (math $COLUMNS - (string length $header)) $ruler_char)

	for i in (seq (count $sigs))
		set -l sig $sigs[$i]
		set -l handler $handlers[$i]
		set -l sig_color $bold
		set -l handler_color $cyan
		if string match --quiet --regex "^__fish_.*" $handler
			set handler_color $blue
		end
		set -l padding_amount (math $length_of_longest_sig - $(string length $sig))
		set -l padding (string repeat --count $padding_amount " ")

		printf "%s%s%s%s %s%s%s\n" \
			$sig_color $sig $reset \
			$padding \
			$handler_color $handler $reset
	end
end
