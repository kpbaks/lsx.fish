function lspy --description "List installed python development programs and their versions"
    set --local reset (set_color normal)
    set --local red (set_color red)
    set --local green (set_color green)
    set --local command_color (set_color $fish_color_command)
    set --local checkmark ✓
    set --local xmark ✗

    set --local options (fish_opt --short=h --long=help)
    # TODO: add option to check if the user has the latest version of the program
    if not argparse $options -- $argv
        return 2
    end

    if set --query _flag_help
        set -l option_color $green
        set -l section_title_color $yellow
        set -l bold (set_color --bold)
        # Overall description of the command
        printf "%sList installed python development programs and their versions%s\n" $bold $reset >&2
        printf "\n" >&2
        # Usage
        printf "%sUsage:%s %s%s%s [options]\n" $section_title_color $reset (set_color $fish_color_command) (status current-command) $reset >&2
        printf "\n" >&2
        # Description of the options and flags
        printf "%sOptions:%s\n" $section_title_color $reset >&2
        printf "\t%s-h%s, %s--help%s      Show this help message and exit\n" $green $reset $green $reset >&2
        printf "\n" >&2

        __lsx.fish::help_footer >&2
        return 0
    end

    begin
        set --local check_if_pip_is_installed 0
        if command --query python3
            set --local python3_version (command python3 --version | string match --regex --groups-only 'Python (\d+\.\d+\.\d+)')
            set check_if_pip_is_installed 1
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search python3) $reset $python3_version $green $checkmark $reset
        else
            printf "python3: %snot installed %s%s\n" $red $xmark $reset
        end

        if test $check_if_pip_is_installed -eq 1
            set --local test_program "import sys
try:
    import pip
except:
    sys.exit(1)
sys.exit(0)"
            set --local installed (echo $test_program | command python3; echo $status)
            if test $installed -eq 0
            set --local pip_version (command python3 -m pip --version | string match --regex --groups-only "(\d+\.\d+\.\d+)")
                printf "%spip%s: %s %s%s%s\n" $command_color $reset $pip_version $green $checkmark $reset
            else
                printf "pip: %snot installed %s%s\n" $red $xmark $reset
            end
        end


        if command --query pixi
            set --local pixi_version (command pixi --version | string match --regex --groups-only '(\d+\.\d+\.\d+)')
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search pixi) $reset $pixi_version $green $checkmark $reset
        else
            printf "pixi: %snot installed %s%s\n" $red $xmark $reset
        end



    end | command column -t
end
