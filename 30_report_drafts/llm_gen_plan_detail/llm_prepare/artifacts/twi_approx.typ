#import "@preview/cetz:0.2.2"
#import "@preview/cetz-plot:0.1.0"

#set page(width: auto, height: auto, margin: 0.5cm)

#let large_func(x, midpoint, spread) = {
  if x <= 0 { return 0 }
  return 1 / (1 + calc.pow(x / midpoint, -spread))
}

#cetz.canvas({
  import cetz.draw: *
  cetz-plot.plot.plot(size: (10, 6),
    x-label: [TWI],
    y-label: [Membership (1-5 Scale)],
    x-tick-step: 2,
    y-tick-step: 1,
    y-min: 1,
    y-max: 5,
    {
      cetz-plot.plot.add(
        domain: (0, 15),
        x => 1 + 4 * large_func(x, 7, 3.6),
        label: [Large (mid=7, spread=3.6)]
      )
    })
})
