# Population Density Transformation Function (Large)
# ArcGIS Pro Suitability Modeler
# Parameters: Midpoint = 36.0, Spread = 0.73

#import "@preview/canvas:0.1.0": canvas

#set page(width: 400pt, height: 300pt, margin: 1cm)

#let mid = 36.0
#let spread = 0.73
#let f(x) = {
  if x <= 0 { 0 }
  else { 1 / (1 + calc.pow(x / mid, -spread)) }
}

= Transformation Function: Large
Parameters: $mid = 36.0$, $spread = 0.73$

#canvas(length: 1cm, {
  import "@preview/canvas:0.1.0": draw
  
  // Axes
  draw.line((0,0), (10,0), mark: (end: ">")) // x-axis (Density)
  draw.line((0,0), (0,6), mark: (end: ">"))  // y-axis (Score 1-5)
  
  draw.content((10.2, 0), [Density])
  draw.content((0, 6.3), [Score])
  
  // Plotting the curve (scaled for visualization)
  let pts = ()
  for i in range(0, 101) {
    let x_val = i * 2.5 // scale 0-250
    let y_val = f(x_val) * 5 // scale 0-5
    pts.push((x_val / 25, y_val)) 
  }
  draw.path(pts, stroke: blue + 2pt)
  
  // Labels
  draw.content((36/25, -0.5), [36.0 (Mid)])
  draw.line((36/25, 0.1), (36/25, -0.1))
  
  draw.content((-0.5, 5), [5])
  draw.content((-0.5, 1), [1])
})
