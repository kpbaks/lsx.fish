function __lsx.fish::help_footer --description "Print a help footer. This way all help messages are consistent in lsx.fish"
    set -l github_url https://github.com/kpbaks/lsx.fish
    set -l star_symbol "⭐"
    set -l reset (set_color normal)
    set -l blue (set_color blue)
    set -l magenta (set_color magenta)
    printf "Part of %slsx.fish%s. A plugin for the %s><>%s shell.\n" $magenta $reset $blue $reset
    printf "See %s%s%s for more information, and if you like it, please give it a %s\n" (set_color --underline cyan) $github_url $reset $star_symbol
end
