---
source: https://github.com/nvkelso/natural-earth-vector/issues/494
links:
  - "[[Natural Earth]]"
  - "[[геоданные]]"
---

## Атрибуты
When working with populated places theme I ensured each NEW record had the minimum properties:

- `NE_ID` - from [Brooklyn Integers](https://www.brooklynintegers.com/create/)
- `NAME` - based on issue decision
- `NAMEASCII` - without any diacritical marks
- `NAMEPAR` - only when single other name in common usage
- `NAMEALT` - when appropriate, a list
- `SCALERANK` - look around at similarly sized cities in that map area
- `NATSCALE` - look around at similarly sized cities in that map area
- `LABELRANK` - look around at similarly sized cities in that map area
- `FEATURECLA` - based on issue decision or no change
- `ADM0CAP` - set to 1 if a country capital, else 0
- `CAPIN` - only if it's a country capital
- `WORLDCITY` - to 0 since those are controlled lists
- `MEGACITY` - to 0 since those are controlled lists
- `SOV0NAME` - based on what NE sov it falls in
- `SOV_A3` - based on what NE sov it falls in
- `ADM0NAME` - based on what NE country it falls in
- `ADM0_A3` - based on what NE country it falls in
- `ADM1NAME` - based on what NE admin1 it falls in, or it's real world value
- `ISO_A2` - based on what NE country it falls in
- `POP_MAX` - these are needed to set townspot size and label text size, for "metro area"
- `POP_MIN` - these are needed to set townspot size and label text size, for "incorporated area"
- `RANK_MAX` - these are needed to set townspot size and label text size, [[#[Population ranks](https //www.naturalearthdata.com/downloads/10m-cultural-vectors/10m-populated-places/)|formaula]]
- `RANK_MIN` - these are needed to set townspot size and label text size, [[#[Population ranks](https //www.naturalearthdata.com/downloads/10m-cultural-vectors/10m-populated-places/)|formaula]]
- `GEONAMEID` - when available, sometimes listed in Wikidata page.
- `TIMEZONE` - see the NE theme but commonly avaialble
- `MIN_ZOOM` - look around at similarly sized cities in that map area
- `WIKIDATAID` - when available, sometimes listed in Wikidata page (eg [https://www.wikidata.org/wiki/Q60](https://www.wikidata.org/wiki/Q60))
- `WOF_ID` - when available from [https://spelunker.whosonfirst.org/](https://spelunker.whosonfirst.org/)


## [Population ranks](https://www.naturalearthdata.com/downloads/10m-cultural-vectors/10m-populated-places/)

Are calculated as rank_max and rank_min using this general VB formula that can be pasted into ArcMap Field Calculator advanced area (set your output to x):

> a = [pop_max]
> >   
> x = 14  
> elseif( a > 5_000_000 ) then  
> x = 13  
> elseif( a > 1_000_000 ) then  
> x = 12  
> elseif( a > 500_000 ) then  
> x = 11  
> elseif( a > 200_000 ) then  
> x = 10  
> elseif( a > 100_000 ) then  
> x = 9  
> elseif( a > 50_000 ) then  
> x = 8  
> elseif( a > 20_000 ) then  
> x = 7  
> elseif( a > 10_000 ) then  
> x = 6  
> elseif( a > 5_000 ) then  
> x = 5  
> elseif( a > 2_000 ) then  
> x = 4  
> elseif( a > 1_000 ) then  
> x = 3  
> elseif( a > 200 ) then  
> x = 2  
> elseif( a > 0 ) then  
> x = 1  
>   
> x = 0