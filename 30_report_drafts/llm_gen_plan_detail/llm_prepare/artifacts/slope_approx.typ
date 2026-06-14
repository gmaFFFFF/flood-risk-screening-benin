#import "@preview/cetz:0.2.2"
#import "@preview/cetz-plot:0.1.0"

#set page(width: auto, height: auto, margin: 0.5cm)

#let small_func(x, midpoint, spread) = {
  if x <= 0 { return 1 }
  return 1 / (1 + calc.pow(x / midpoint, spread))
}

#cetz.canvas({
  import cetz.draw: *
  cetz-plot.plot.plot(size: (10, 6),
    x-label: [Slope (degrees)],
    y-label: [Membership (1-5 Scale)],
    x-tick-step: 2,
    y-tick-step: 1,
    y-min: 1,
    y-max: 5,
    {
      cetz-plot.plot.add(
        domain: (0, 15),
        x => 1 + 4 * small_func(x, 6, 1.65),
        label: [Small (mid=6, spread=1.65)]
      )
    })
})
