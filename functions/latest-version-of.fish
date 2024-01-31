function latest-version-of --argument-names program
    set -l argc (count $argv)
    if test $argc -ne 1
        echo "Usage: latest-version-of <program>"
        return 2
    end
    if not command --query htmlq
        echo "htmlq is not installed"
        return 1
    end

    set -l curl_opts --silent
    switch $program
        case gcc g++
            set -l url 'https://gcc.gnu.org/releases.html'
            set -l selector 'td a'
            command curl $curl_opts $url \
            | command htmlq $selector --text \
            | head -n 1 \
            | string split --fields=2 " "

        case python python3
            set -l url 'https://www.python.org/downloads/'
            set -l selector '.list-row-container .release-version'
            command curl $curl_opts $url \
            | command htmlq $selector --text \
            | tail -n +2 \
            | head -n 1
        case "*"
            echo "Unknown program: $program"
            return 1
    end
end
