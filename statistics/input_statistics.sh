o=$1

for i in {1..16} ; do 
        
    filename="out/$o-$i.txt"
    
    if ! [ -f "$filename" ] \
    || ! [ -s "$filename" ] ; then

        matlab -nojvm -batch \
            "outputsNumber=$o;inputsNumber=$i;run statistics.m" > $filename
        continue
    fi
        
    # get the lastTest number to continue from there
    lastTest=$(tac $filename |egrep -m 1 . | cut -d' ' -f 1)
    lastTest=$(($lastTest + 1))

    matlab -nojvm -batch \
        "lastTest=$lastTest;inputsNumber=$i;outputsNumber=$o;run statistics.m" \
        >> $filename
done