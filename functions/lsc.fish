function lsc

    set --local reset (set_color normal)
    set --local red (set_color red)
    set --local green (set_color green)
    set --local command_color (set_color $fish_color_command)
    set --local checkmark ✓
    set --local xmark ✗

    begin
        if command --query gcc
            set --local gcc_version (command gcc --version | string match --regex --groups-only "(\d+\.\d+\.\d+)\$")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search gcc) $reset $gcc_version $green $checkmark $reset
        else
            printf "gcc: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query clang
            set --local clang_version (command clang --version | string match --regex --groups-only "(\d+\.\d+\.\d+)-?")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search clang) $reset $clang_version $green $checkmark $reset
        else
            printf "clang: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query make
            set --local make_version (command make -v | string match --regex --groups-only "GNU Make (\d+\.\d+)")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search make) $reset $make_version $green $checkmark $reset
        else
            printf "make: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query cmake
            set --local cmake_version (command cmake --version | string match --regex --groups-only "cmake version (\d+\.\d+)")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search cmake) $reset $cmake_version $green $checkmark $reset
        else
            printf "cmake: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query gdb
            set --local gdb_version (command gdb --version | string match --regex --groups-only "(\d+\.\d+)")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search gdb) $reset $gdb_version $green $checkmark $reset
        else
            printf "gdb: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query gcov
            set --local gcov_version (command gcov --version | string match --regex --groups-only "(\d+\.\d+)")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search gcov) $reset $gcov_version $green $checkmark $reset
        else
            printf "gcov: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query valgrind
            set --local valgrind_version (command valgrind --version | string match --regex --groups-only "(\d+\.\d+\.\d+)")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search valgrind) $reset $valgrind_version $green $checkmark $reset
        else
            printf "valgrind: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query clangd
            set --local clangd_version (command clangd --version | string match --regex --groups-only "(\d+\.\d+\.\d+)")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search clangd) $reset $clangd_version $green $checkmark $reset
        else
            printf "clangd: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query clang-format
            set --local clang_format_version (command clang-format --version | string match --regex --groups-only "(\d+\.\d+\.\d+)")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search clang-format) $reset $clang_format_version $green $checkmark $reset
        else
            printf "clang-format: %snot installed %s%s\n" $red $xmark $reset
        end

        if command --query clang-tidy
            set --local clang_tidy_version (command clang-tidy --version | string match --regex --groups-only "(\d+\.\d+\.\d+)")
            printf "%s%s%s: %s %s%s%s\n" $command_color (command --search clang-tidy) $reset $clang_tidy_version $green $checkmark $reset
        else
            printf "clang-tidy: %snot installed %s%s\n" $red $xmark $reset
        end
    end | column -t
end
