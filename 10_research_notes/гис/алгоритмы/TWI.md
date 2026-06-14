---
aliases:
  - Topographic Wetness Index
---
# Определение
Индекс влажности почв из-за рельефа. Показывает склонность ячейки накапливать воду. 

Высокие значения — это зоны насыщения влагой (русла, поймы, низины).

# Формулы расчета

В интернете:
$$
TWI = \ln(\frac {a} {\tan β}), 
$$
где:
- $a$ — удельная водосборная площадь (накопленная площадь стока на единицу ширины потока), $м^2/м$
- $β$ — уклон поверхности

## Расчет в ГИС
### [Расчет в ArcGis](https://mapscaping.com/topographic-wetness-index-in-arcgis-pro) или [[arcGis.Toolbox.Topography|готовый инструмент]]
* [ArcGis Spatial Analyst. Заполнение](https://desktop.arcgis.com/ru/arcmap/latest/tools/spatial-analyst-toolbox/fill.htm)
* [ArcGis Spatial Analyst. Направление стока](https://desktop.arcgis.com/ru/arcmap/latest/tools/spatial-analyst-toolbox/flow-direction.htm)
* [Суммарный сток](https://desktop.arcgis.com/ru/arcmap/latest/tools/spatial-analyst-toolbox/flow-accumulation.htm)
* [Уклон](https://desktop.arcgis.com/ru/arcmap/latest/tools/spatial-analyst-toolbox/slope.htm)(расчет в градусах)
* С помощью - [калькулятора растра](https://desktop.arcgis.com/ru/arcmap/latest/tools/spatial-analyst-toolbox/raster-calculator.htm):
    * Уклон. Перевести градусы в радианы и рассчитать тангенс $танУгла = \tan(градусы \times (π \div 180))$  
    *  Сток. Дополнить текущей ячейкой $стокКоррект = сток + 1$
    * $TWI=\ln(стокКоррект \div танУгла)$
### [Расчет в QGIS](https://courses.gisopencourseware.org/mod/book/tool/print/index.php?id=41)