ampl amplscript.run
sed -e '1,2d' -e '/^$/d' -e '/^\:/d' -e '/\[/d' -e '/*tr*/d' -e '$d' -e '/\;/d' -e 's/^\w*\ *//' dualresult.txt > dualresultfinal.txt
sed -e '1,2d' -e '/^$/d' -e '/^\:/d' -e '/\[/d' -e '/*tr*/d' -e '$d' -e '/\;/d' -e 's/^\w*\ *//' y12.txt > y12final.txt
