#!/bin/bash

cut -d ',' -f 1-11,13-15 supervivents.csv > pas1.csv

videos_amb_error=$(awk -F ','  '$14 == "True"' pas1.csv | wc -l)
awk -F ',' '$14 != "True"' pas1.csv > pas2.csv
echo "S'han eliminat $videos_amb_error vídeos amb error"

awk 'BEGIN {FS=OFS=","} 
NR==1 {$0 = $0 ",Ranking_Views"} 
1' pas2.csv > pas3.csv

awk -F ',' 'BEGIN {OFS=","}
{   if (NR == 1) {
        print $0;
    } else {
    if ($8 <= 1000000)
        ranking = "Bo";
    else if ($8 > 1000000 && $8 <= 10000000)
        ranking = "Excel·lent";
    else if ($8 > 10000000)
        ranking = "Estrella";
    else
	ranking = "Ranking_views";
    print $0, ranking;
    }
}' pas3.csv > pas4.csv

rm pas1.csv pas2.csv pas3.csv
