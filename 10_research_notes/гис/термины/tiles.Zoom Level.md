---
links: "[[tiles]]"
aliases:
  - Уровень масштабирования
  - scaleRank
---
Уровень масштабирования представляет это число от 0 (глобальный обзор) до 23 (очень подробный обзор) и используется как сокращенное обозначение заранее заданных значений масштаба карты.

# Уровни масштабирования для [[OpenStreetMap]]

[Источник](https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Resolution_and_Scale).

| Уровень | Число тайлов [^(1)] : <br> | Ширина тайла  <br>(° долготы) | Ширина тайла (м / пиксель <br>(на экваторе) | ≈ Масштаб (на экране) | Пример зоны интереса                   |
| ------- | -------------------------- | ----------------------------- | ------------------------------------------- | --------------------- | -------------------------------------- |
| 0       | 1                          | 360                           | 156 543                                     | 1:500 million         | Весь мир                               |
| 1       | 4                          | 180                           | 78 272                                      | 1:250 million         |                                        |
| 2       | 16                         | 90                            | 39 136                                      | 1:150 million         | субконтиненты                          |
| 3       | 64                         | 45                            | 19 568                                      | 1:70 million          | большие страны                         |
| 4       | 256                        | 22.5                          | 9 784                                       | 1:35 million          |                                        |
| 5       | 1 024                      | 11.25                         | 4 892                                       | 1:15 million          | большие африканский страны             |
| 6       | 4 096                      | 5.625                         | 2 446                                       | 1:10 million          | большие европейски страны              |
| 7       | 16 384                     | 2.813                         | 1 223                                       | 1:4 million           | маленькие страны, субъекты РФ          |
| 8       | 65 536                     | 1.406                         | 611.496                                     | 1:2 million           |                                        |
| 9       | 262 144                    | 0.703                         | 305.748                                     | 1:1 million           | обширная территория, большой мегаполис |
| 10      | 1 048 576                  | 0.352                         | 152.874                                     | 1:500,000             | мегаполис                              |
| 11      | 4 194 304                  | 0.176                         | 76.437                                      | 1:250,000             | город                                  |
| 12      | 16 777 216                 | 0.088                         | 38.219                                      | 1:150,000             | город или район города                 |
| 13      | 67 108 864                 | 0.044                         | 19.109                                      | 1:70,000              | деревня или пригород                   |
| 14      | 268 435 456                | 0.022                         | 9.555                                       | 1:35,000              |                                        |
| 15      | 1 073 741 824              | 0.011                         | 4.777                                       | 1:15,000              | маленькая дорога                       |
| 16      | 4 294 967 296              | 0.0055                        | 2.389                                       | 1:8,000               | улица                                  |
| 17      | 17 179 869 184             | 0.0027                        | 1.194                                       | 1:4,000               | квартал, парк, адрес                   |
| 18      | 68 719 476 736             | 0.0014                        | 0.597                                       | 1:2,000               | некоторые здания, деревья              |
| 19      | 274 877 906 944            | 0.00069                       | 0.299                                       | 1:1,000               | детали местного шоссе и переходов      |
| 20      | 1 099 511 627 776          | 0.00034                       | 0.149                                       | 1:500                 | Здание среднего размера                |

[^(1)]: Столбец «Число тайлов» указывает количество плиток, необходимое для отображения всего мира при заданном уровне масштабирования. Это полезно при расчете требований к хранилищу для предварительно созданных листов.


# Формулы GoogleMaps
Формула на [stackexchange](https://gis.stackexchange.com/questions/7430/what-ratio-scales-do-google-maps-zoom-levels-correspond-to): $\frac{591657550.5}{2^{level}}$

Особенности векторных тайлов [здесь](https://developers.arcgis.com/documentation/mapping-and-location-services/reference/zoom-levels-and-scale/)
Согласно [источнику](https://webhelp.esri.com/arcgisserver/9.3/java/index.htm#designing_overlay_gm_mve.htm):
19 : 1128.497220
18 : 2256.994440
17 : 4513.988880
16 : 9027.977761
15 : 18055.955520
14 : 36111.911040
13 : 72223.822090
12 : 144447.644200
11 : 288895.288400
10 : 577_790.5767
9 : 1_155_581.153
8  : 2_311_162.307
7  : 4_622_324.614
6  : 9_244_649.227
5  : 18_489_298.45
4  : 36_978_596.91
3  : 73_957_193.82
2  : 147_914_387.6
1  : 295_828_775.3
0  : 591_657_550.5


# Уровни масштабирования для [[Natural Earth]]

Соответствие атрибута **natlScale** и уровень масштабирования (**scaleRank**):

```
Conversion from: https://github.com/nvkelso/geo-how-to/wiki/Map-scales---zooms
Which are slightly differnt than raw web map zooms.

if [natlScale] = 150     then scaleRank = 2    // consistent with web zoom...
if [natlScale] =  75     then scaleRank = 3    
if [natlScale] =  50     then scaleRank = 4    // special to natural earth
if [natlScale] =  30     then scaleRank = 5    // 1 off from web zoom...
if [natlScale] =  20     then scaleRank = 6
if [natlScale] =  10     then scaleRank = 7
if [natlScale] =   5     then scaleRank = 8
if [natlScale] =   2     then scaleRank = 9
if [natlScale] =   1     then scaleRank = 10
if [natlScale] =   0.5   then scaleRank = 11
if [natlScale] =   0.25  then scaleRank = 12
if [natlScale] =   0.15  then scaleRank = 13
if [natlScale] =   0.10  then scaleRank = 14
if [natlScale] =   0.015 then scaleRank = 16
if [natlScale] =   0.01  then scaleRank = 18   // mostly back on track
if [natlScale] =  -1     then scaleRank = 100  // these should be removed
```

