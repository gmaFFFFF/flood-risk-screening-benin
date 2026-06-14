---
aliases:
  - "CHIRPS Daily: Climate Hazards Center InfraRed Precipitation With Station Data"
source: https://developers.google.com/earth-engine/datasets/catalog/UCSB-CHG_CHIRPS_DAILY#description
links: "[[геоданные]]"
---
Квазиглобальный (60°N-60°S) набор данных об осадках за период с 1981 года. Объединяет спутниковые снимки с разрешением 0,05° (примерно 5×5 км) с данными наземных станций для создания сетки временных рядов осадков для анализа тенденций и мониторинга сезонных засух.

Данные по осадкам доступны в [[google.Earth Engine|GEE]].
# Веб приложение
Есть онлайн приложение [EWX (Early Warning eXplorer)](https://ewx3.chc.ucsb.edu/ewx/index.html) + [зеркала](https://www.chc.ucsb.edu/tools/ewx).

> [!bag]
> Заметил, что данные в онлайн приложении за пентаду (5 дней) отличаются от 5-дневок посчитанных вручную и содержащихся в базе.


# Выгрузка данных с помощью [[google.Earth Engine|Google Earth Engine]] ([[google.Earth Engine|GEE]])

## Выгрузка статических характеристик для расчета [[AEP]]

Дневной максимум осадков ([[Rx1day]]) и 5-ти дневный максимум осадков ([[Rx5day]]).

Чтобы посчитать «пятидневку», к коллекции ежедневных осадков применяется метод «скользящего окна» (moving window).

Код для [[google.Earth Engine|Google Earth Engine]]:
```javascript
// Зона интересов
var region = ee.Geometry.Rectangle([-1, 5, 6, 14]);


// Фильтрованные ежедневные осадки
var chirps = ee.ImageCollection("UCSB-CHG/CHIRPS/DAILY").filterBounds(region);


// Диапазон доступных лет
var dateRange = ee.Dictionary(chirps.reduceColumns(ee.Reducer.minMax(), ['system:time_start']));
var startYear = ee.Date(dateRange.get('min')).get('year');
var endYear = ee.Date(dateRange.get('max')).get('year');
var years = ee.List.sequence(startYear, endYear);


// Скользящая сумма за 5 дней
var dailyColl = chirps.select(['precipitation']);
var chirps5day = dailyColl.map(function(image) {
  return dailyColl.filterDate(
    image.date().advance(-4, 'day'), 
    image.date().advance(1, 'day')
  ).sum().copyProperties(image, ['system:time_start']);
});


// Годовые максимумы
var yearlyMaxCol = ee.ImageCollection.fromImages(years.map(function(y) {
  return chirps.filter(ee.Filter.calendarRange(y, y, 'year'))
               .select('precipitation')
               .max()
               .clip(region);
}));

// Годовые максимумы из "5-дневной" коллекции
var yearlyMax5day = ee.ImageCollection.fromImages(years.map(function(y) {
  return chirps5day.filter(ee.Filter.calendarRange(y, y, 'year'))
                   .select('precipitation')
                   .max()
                   .clip(region);
}));


// Расчет базовых статистик
var meanMax = yearlyMaxCol.mean().rename('mean_max_1d');
var stdMax = yearlyMaxCol.reduce(ee.Reducer.stdDev()).rename('std_max_1d');
var meanMax5 = yearlyMax5day.mean().rename('mean_max_5d');
var stdMax5 = yearlyMax5day.reduce(ee.Reducer.stdDev()).rename('std_max_5d');


// Собираем все 4 показателя (1-day и 5-day)
var all = meanMax.addBands(stdMax)
                 .addBands(meanMax5)
                 .addBands(stdMax5)
                 .toFloat();


//--- Интерактивная проверка
var checkBeta = stdMax.multiply(Math.sqrt(6)).divide(Math.PI);
var checkMu = meanMax.subtract(checkBeta.multiply(0.5772));
var checkARI70 = checkMu.add(checkBeta.multiply(Math.log(70)));

// Настройка визуализации
var visParams = {
  min: 50, 
  max: 250, 
  palette: ['blue', 'cyan', 'green', 'yellow', 'red']
};
var visParamsStd = {
  min: 0, 
  max: 40, 
  palette: ['blue', 'cyan', 'green', 'yellow', 'red']
};

// Центрируем карту на вашем регионе
Map.centerObject(region, 7);

// Добавляем обзорные слои на карту
Map.addLayer(meanMax, visParams, 'Проверка: Среднее максимумов');
Map.addLayer(stdMax, visParamsStd, 'Проверка:СКО');
Map.addLayer(checkARI70, visParams, 'Осадки 70 лет (Превью)');
Map.addLayer(meanMax5, visParams, 'Проверка: Среднее максимумов за 5 дней');
Map.addLayer(stdMax5, visParamsStd, 'Проверка:СКО за 5 дней');

Export.image.toDrive({
  image: all,
  description: 'CHIRPS_Extreme_Stats',
  scale: 5566,
  region: region,
  fileFormat: 'GeoTIFF'
});

```

## Выгрузка эмпирических нормализованных вероятностей для проверки модели

Выборки нормализованных вероятностей по каждой точке объединяются в общую выборку.

Код для [[google.Earth Engine|Google Earth Engine]]:
``` Javascript
// Зона интересов
var region = ee.Geometry.Rectangle([-1, 5, 6, 14]);


// Фильтрованные ежедневные осадки
var chirps = ee.ImageCollection("UCSB-CHG/CHIRPS/DAILY").filterBounds(region);


// Диапазон доступных лет
var dateRange = ee.Dictionary(chirps.reduceColumns(ee.Reducer.minMax(), ['system:time_start']));
var startYear = ee.Date(dateRange.get('min')).get('year');
var endYear = ee.Date(dateRange.get('max')).get('year');
var years = ee.List.sequence(startYear, endYear);


// Годовые максимумы
var yearlyMaxCol = ee.ImageCollection.fromImages(years.map(function(y) {
  return chirps.filter(ee.Filter.calendarRange(y, y, 'year'))
               .select('precipitation')
               .max()
               .clip(region);
}));

// Расчет базовых статистик
var meanMax = yearlyMaxCol.mean().rename('mean_max_1d');
var stdMax = yearlyMaxCol.reduce(ee.Reducer.stdDev()).rename('std_max_1d');

// Расчет параметров Гумбеля
var beta = stdMax.multiply(Math.sqrt(6)).divide(Math.PI);
var mu = meanMax.subtract(beta.multiply(0.5772));


// Стандартизация данных по годам: z = (x - mu) / beta
var yearlyZCol = yearlyMaxCol.map(function(img) {
  var z = img.subtract(mu).divide(beta).rename('z_score');
  return z.copyProperties(img, ['year']);
});

// Извлекаем стандартизованные данные
var getStats = function(image) {
  // Превращаем пиксели в точки (FeatureCollection)
  return image.sample({
    region: region,
    scale: 5566,
    projection: 'EPSG:4326',
    geometries: false // Нам нужны только цифры, без координат (быстрее)
  });
};

var allZValues = yearlyZCol.map(getStats).flatten();

// Проверка в консоли (первые 10 значений)
print('Пример данных:', allZValues.limit(10));

// Экспорт в Google Drive
Export.table.toDrive({
  collection: allZValues,
  description: 'Chirps_Normalized_Z_Scores',
  fileFormat: 'CSV',
  selectors: ['z_score']  // Экспортируем только одну колонку
});
```

# Проверка модели
## Графическая проверка соответствие выборки [[Распределение Гумбеля|распределению Гумбеля]]
Проверка осуществляется графически путем сравнения стандартизованных исторических данных с теоретической кривой Гумбеля.
 
[[#Выгрузка эмпирических нормализованных вероятностей для проверки модели]] по эмпирическим (историческим данным) осуществляется в [[google.Earth Engine|GEE]].

#### Скрипт сравнения выборки с распределением Гумбеля

Код для [[Google Colab]]
```Python
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import gumbel_r


# Загрузка
df = pd.read_csv('/content/drive/MyDrive/Chirps_Normalized_Z_Scores.csv')
data = df['z_score'].dropna() # Удаляем пустые, если есть


# Определение эталонной кривой Гумбеля
# Для стандартизованных данных параметры ВСЕГДА: μ=0, β=1
mu_std = 0
beta_std = 1

# Создание линии Гумбеля
z = np.linspace(data.min(), data.max(), 100)
p_theoretical = gumbel_r.pdf(z, loc=mu_std, scale=beta_std)  


# Построение гистограммы
plt.figure(figsize=(11, 6))

# density=True делает площадь гистограммы равной 1, чтобы наложить кривую вероятности
plt.hist(data, bins=100, density=True, alpha=0.5, color='skyblue',
         label='Эмпирические данные по осадкам\n(стандартизованные)')
# Теоретическая кривая Гумбеля (эталон)
plt.plot(z, p_theoretical, 'r', linewidth=2.5,
         label=f'Кривая Гумбеля (μ={mu_std:.2f}, β={beta_std:.2f})')


plt.title('Проверка соответствия стандартизованных максимумов осадков по CHIRPS распределению Гумбеля')
plt.xlabel('Стандартизованная переменная $z$')
plt.ylabel('Плотность вероятности')
plt.legend()
plt.savefig('/content/drive/MyDrive/rx1dayStandardized_Gumbel_Check.svg')
plt.show()

# Для самоконтроля: выведем реальные среднее и стандартное отклонение z
print(f"Среднее значение z (должно быть близко к 0.577): {data.mean():.4f}")
print(f"Стандартное отклонение z (должно быть близко к 1.282): {data.std():.4f}")
```

## Проверка предсказательной силы модели
### Сравнение с эмпирическими (историческими) данными
Сравнение [[обеспеченность эмпирическая|эмпирической обеспеченности]] по историческим данным и [[AEP]], вычисленной по теоретической модели [[Распределение Гумбеля|Гумбеля]].

#### Скрипт сравнения модельных данных с эмпирическими

Код для [[Google Colab]]

```python
#%%
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
#%%
# Параметры эталонной кривой Гумбеля для стандартизованных данных ВСЕГДА: μ=0, β=1
mu = 0
beta = 1
#%%
# Список ARI для сравнения
target_aris = [2, 5, 10, 20, 30, 40, 50, 70, 100]
#%%
# Загрузка
df = pd.read_csv('/content/drive/MyDrive/Chirps_Normalized_Z_Scores.csv')
# Сортировка data по убыванию:
data = df['z_score'].dropna().sort_values(ascending=False)
N = len(data)
#%%
# Печать таблицы сравнения
print(f"|{'ARI':^5} | {'Теор. Z':^10} | {'Событий > Z':^12} | {'Эмпир. ARI':^12} | {'Разница, лет(%)'} |")
print(f"|{'-' * 5} | {'-' * 10} | {'-' * 12} | {'-' * 12} | {'-' * 15} |")

for ari in target_aris:
    # Теоретическое значение Z для данного ARI
    z_theoretical = mu -beta * np.log(-np.log(1 - 1 / ari))

    # Считаем, сколько реальных точек превысило этот теоретический порог
    count_exceed = (data >= z_theoretical).sum()

    # Эмпирическая вероятность превышения этого порога
    # Если событий 0, то берем оценку как 1/(n+1) для избежания деления на 0
    emp_prob = count_exceed / (N + 1) if count_exceed > 0 else 1 / (N+1)
    emp_ari = 1 / emp_prob

    # Разница в годах
    diff = emp_ari - ari
    diff_p = abs(emp_ari / ari - 1)

    print(f"|{ari:>5} | {z_theoretical:^10.4f} | {count_exceed:>12} | {emp_ari:>12.1f} | {diff:+.1f} ({diff_p:.1%}) |")
#%%
# Ранжирование исторических данных
ranks = np.arange(1, N + 1)
# Эмпирическая обеспеченность: P = m / (N + 1)
empirical_P = ranks / (N + 1)
# Эмпирический период повторения (ARI)
empirical_ari = 1 / empirical_P
#%%
# --- ПРОРЕЖИВАНИЕ ДАННЫХ ДЛЯ ГРАФИКА ---  
# ARI >20: Оставляем каждую 3000-ю точку  
mask_rare = (empirical_ari > 20) & (ranks % 3000 == 0)  
# ARI 5..20: Оставляем каждую 15000-ю точку  
mask_medium = (empirical_ari > 5) & (empirical_ari <= 20) & (ranks % 15000 == 0)  
# ARI < 5: Оставляем каждую 20000-ю точку  
mask_common = (empirical_ari <= 5) & (ranks % 20000 == 0)  
  
mask_plot = mask_rare | mask_medium | mask_common  
  
ari_plot = empirical_ari[mask_plot]  
data_plot = data[mask_plot]
#%%
# Теоретическая выборка (ограничим 150 годами для графика)
model_ari = np.logspace(np.log10(1.01), np.log10(150), 100) # Ось X для линии
model_aep = 1 / model_ari
model_z = mu -beta * np.log(-np.log(1 - model_aep))
#%%
# Построение графика сравнения  
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 10), sharex=True, gridspec_kw={'height_ratios': [2, 1]})

# 1. Основной график
ax1.semilogx(ari_plot, data_plot, 'o', color='black', alpha=0.4, markersize=3, label='Эмпирические данные (факт)')
ax1.semilogx(model_ari, model_z, 'r-', linewidth=2, label='Модель Гумбеля (теория)')

ax1.set_title('Сравнение модели Гумбеля и эмпирических данных')
ax1.set_ylabel('Стандартизованная величина (Z-score)')
ax1.legend()

# 2. График относительной ошибки
model_ari_at_z = 1 / (1 - np.exp(-np.exp(-(data_plot - mu)/beta)))
error_pct = (ari_plot - model_ari_at_z) / model_ari_at_z * 100

ax2.semilogx(ari_plot, error_pct, 'o', color='purple', alpha=0.5, markersize=4, label='Отклонение факта от модели')
ax2.axhline(0, color='red', linestyle='-', linewidth=1)
ax2.axhspan(-10, 10, color='green', alpha=0.1, label='Зона ±10%')

# Настройка осей и меток
for ax in [ax1, ax2]:
    ax.grid(True, which="both", ls="-", alpha=0.2)
    ax.xaxis.set_major_formatter(ticker.ScalarFormatter())
    ax.set_xticks([1, 2, 5, 10, 20, 30, 40, 50, 70, 100, 150])

# Визуализация целевых ARI (вертикальные линии и подписи)
for ari in target_aris:
    ax1.axvline(x=ari, color='blue', linestyle='--', alpha=0.2)
    ax2.axvline(x=ari, color='blue', linestyle='--', alpha=0.2)
    # Подпись внизу графика ошибок
    ax2.text(ari, 0.02, f' ARI {ari}', transform=ax2.get_xaxis_transform(),
             rotation=90, verticalalignment='bottom', color='blue', fontsize=8, alpha=0.7)

ax2.set_title('Относительное отклонение эмпирического ARI от теоретического')
ax2.set_ylabel('Ошибка ARI (%)')
ax2.set_xlabel('Период повторения (ARI), лет [логарифмическая шкала]')
ax2.legend()

# Ограничение осей  
ax1.set_xlim(1, 150)
ax2.set_ylim(-50, 50)

plt.tight_layout()
plt.savefig('/content/drive/MyDrive/limitsOfAcceptability.svg')
plt.show()
```
