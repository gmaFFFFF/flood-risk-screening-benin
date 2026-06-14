#set page(width: 12cm, height: 10cm, margin: 0cm)
#set text(font: "PT Serif", size: 10pt)

= Сравнение операторов нечёткой логики
Пусть фактор $A = 0.6$, фактор $B = 0.4$

- *Fuzzy AND (MIN)*: $min(0.6, 0.4) = 0.4$
- *Fuzzy OR (MAX)*: $max(0.6, 0.4) = 0.6$
- *Fuzzy Product*: $0.6 times 0.4 = 0.24$
- *Fuzzy Sum*: $1 - (1-0.6) times (1-0.4) = 1 - 0.4 times 0.6 = 1 - 0.24 = 0.76$
- *Fuzzy Gamma* ($gamma = 0.5$): $(0.24)^0.5 times (0.76)^0.5 = 0.489 times 0.871 = 0.427$

#align(center)[
  #table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [*Оператор*], [*Формула*], [*Результат*],
    [AND], [min(A, B)], [0.4],
    [OR], [max(A, B)], [0.6],
    [Product], [A × B], [0.24],
    [Sum], [1 - (1-A)(1-B)], [0.76],
    [Gamma (0.5)], [(Product)^0.5 × (Sum)^0.5], [0.427]
  )
]