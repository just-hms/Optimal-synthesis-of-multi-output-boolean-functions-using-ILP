
for o in {8..8} ; do
    ./input_statistics.sh $o &
done

read -p "" input

sudo ps -aux | grep "input_statistics.sh" | \
awk {print $2} | while read line; do sudo kill -9 $line ; done

sudo ps -aux | grep "matlab" | grep "nojvm" | grep "batch" | \
awk {print $2} | while read line; do sudo kill -9 $line ; done
