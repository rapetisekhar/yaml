LOOP_IT="$@"

[ -z "$LOOP_IT" -o \! -f "$LOOP_IT" -o \! -s "$LOOP_IT" ] && echo Nothing to do.... && exit

$LOOP_IT | tee loop_it.op.txt

exit_status=${PIPESTATUS[0]}

if [ $exit_status -ne 0 ]; then
	echo Nothing to do.... && exit
fi

while true;
do
  clear
  date
  cat loop_it.op.txt
  sleep 2s
  $LOOP_IT > loop_it.op.txt
done
