#!/bin/bash

cut -d ',' -f 1-11,13-15 supervivents.csv > pas1.csv

videos_amb_error=$(awk -F ','  '$14 == "True"' pas1.csv | wc -l)
awk -F ',' '$14 != "True"' pas1.csv > pas2.csv
echo "S'han eliminat $videos_amb_error vídeos amb error"

awk -F ',' 'BEGIN {OFS=","}
{
    if ($8 <= 1000000)
        ranking = "Bo";
    else if ($8 > 1000000 && $8 <= 10000000)
        ranking = "Excel·lent";
    else if ($8 > 10000000)
        ranking = "Estrella";
    else
	ranking = "Ranking_views";
    print $0, ranking;
}' pas2.csv > pas3.csv

rm pas1.csv pas2.csv
