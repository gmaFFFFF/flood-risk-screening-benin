// Hazard Index Transformation Function (MSLarge)
// ArcGIS Pro Suitability Modeler
// Parameters: Mean Multiplier = 1.0, Std Multiplier = 1.0
// Statistics: Min=115.4, Max=499.8, Mid=208.9, Std=50.7

#import "@preview/cetz:0.3.2": canvas, draw

#set page(width: 8cm, height: 8.1cm, margin: 0cm)
#set text(font: "PT Serif", size: 10pt)

#let mean = 208.9
#let max = 499.8
#let min = 115.458
#let std = 50.7
#let a = 1.0
#let b = 1.0

#let f(x) = {
  let threshold = a * mean
  if x <= threshold { 0 }
  else { 1 - (b * std) / (x - threshold + (b * std)) }
}

= Аппроксимация интегрального фактора затопления
#v(1em)
#canvas(length: .8cm, {  
  // Оси
  draw.line((0,0), (10,0), mark: (end: ">"), name: "x-axis") 
  draw.line((0,0), (0,6), mark: (end: ">"), name: "y-axis")
  
  draw.content((9, -.5), [Опасность])
  draw.content((0, 6.3), [Балл])
  
  // Генерация точек для графика
  let pts = ()
  for i in range(0, 101) {
    let x_val = min + i * (max - min) / 100 
    let y_val = f(x_val) * 4 + 1 // масштабирование 1-5
    // Нормализация x для холста (от 0 до 9)
    let x_canvas = (x_val - min) / (max - min) * 9
    pts.push((x_canvas, y_val)) 
  }
  
  draw.line(..pts, stroke: red + 1.5pt)
  
  // Метка порога (Threshold)
  let thresh_canvas = (mean - min) / (max - min) * 9
  draw.content((thresh_canvas, -0.5), [208.9 (Среднее)])
  draw.line((thresh_canvas, 0.1), (thresh_canvas, -0.1))
  
  // Метки по оси Y
  draw.content((-0.5, 5), [5])
  draw.content((-0.5, 1), [1])
})
Параметры: $m = 208.9, s = 50.7, a = 1.0, b = 1.0$