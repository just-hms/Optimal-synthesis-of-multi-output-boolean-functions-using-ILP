if [ $# -eq 0 ] 
then

    for o in {1..16}
    do 
        filename="out/outputs_$o.log"
        if ! [ -f "$filename" ] \
        || ! [ -s "$filename" ] ; then

            echo "init output [$o]"

            matlab -nojvm -noFigureWindows -batch \
                "outputsNumber=$o;run statistics.m" > out/outputs_$o.log &
            continue
        fi
            
        startInputsNumber=$(tac out/outputs_$o.log |egrep -m 1 . | cut -d' ' -f 1)
        startTest=$(tac out/outputs_$o.log |egrep -m 1 . | cut -d' ' -f 2)
        startTest=$(($startTest + 1))

        echo "continue output [$o]"
        matlab -nojvm -noFigureWindows -batch \
            "startInputsNumber=$startInputsNumber;startTest=$startTest;outputsNumber=$o;run statistics.m" \
            >> out/outputs_$o.log &
    done

    read -p "" input

    matlab -nojvm -noFigureWindows -batch \
        "system('taskkill /IM matlab.exe')"
fi