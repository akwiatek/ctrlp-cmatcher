#!/usr/bin/env sh

chkPython3()
{
    cmd=$1
    ret=$($cmd -V 2>&1)
    case "$ret" in
    "Python 3."*)
        return 0
        ;;
    *)
        return 1
        ;;
    esac
}

findPython3()
{
    cmd_list="python python3 python38 python3.8 python37 python3.7 python36 python3.6"
    for cmd in $cmd_list; do
        if chkPython3 $cmd; then
            found_python=$cmd
            break
        fi
    done

    if [ "$found_python" = "" ]; then
        echo "cannot find python3 automatically" >&2
        while true; do
            read -p "please input your python 3 command: " cmd
            if chkPython3 "$cmd"; then
                found_python=$cmd
                break
            fi
            echo "verify [$cmd] with -V failed" >&2
        done
    fi

    echo $found_python
}

python=$(findPython3)
echo "find python3 -> $python"

cd autoload
$python setup.py build
cp build/lib*/fuzzycomt*.so ./fuzzycomt.so
