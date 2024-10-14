#!/bin/bash

if [ ! -f sortida.csv ]; then
cut -d ',' -f 1-11,13-15 supervivents.csv > pas1.csv
echo "Columnes 'description' i 'thumbnail_link' eliminades."

vid_err=$(awk -F ','  '$14 == "True"' pas1.csv | wc -l)
awk -F ',' '$14 != "True"' pas1.csv > pas2.csv
echo "S'han eliminat $vid_err vídeos amb error."

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
echo "Columna 'Ranking_views' creada."

echo "Calculant percentatges de likes i dislikes..."
echo "$(head -n 1 pas4.csv),Rlikes,Rdislikes" > sortida.csv
    tail -n +2 pas4.csv | while IFS=',' read -r video_id trending_date title channel_title category_id publish_time tags views likes dislikes comment_count ratings_disabled video_error_or_removed Ranking_Views; do
    if [ "$views" -ne 0 ]; then
            Rlikes=$(( (likes * 100) / views ))
            Rdislikes=$(( (dislikes * 100) / views ))
        else
            Rlikes=0
            Rdislikes=0
        fi
echo "$video_id,$trending_date,$title,$channel_title,$category_id,$publish_time,$tags,$views,$likes,$dislikes,$comment_count,$ratings_disabled,$video_error_or_removed,$Ranking_Views,$Rlikes,$Rdislikes" >> sortida.csv
    done
echo "Percentatges calculats."

rm pas1.csv pas2.csv pas3.csv pas4.csv

fi

echo "Introdueix la teva cerca:"
read video
resultat=$(awk -F ',' -v cerca="$video" 'tolower($1) ~ tolower(cerca) || tolower($3) ~ tolower(cerca)' sortida.csv)


if [ -z "$resultat" ]; then
	echo "No s'han trobat coincidències amb la cerca"
else
	echo "$resultat" | cut -d ',' -f 3,6,8-10,16-18
fi

