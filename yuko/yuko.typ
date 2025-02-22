
#import "@preview/suiji:0.3.0": *
#import "@preview/cetz:0.3.2": canvas, draw

#let yuko(msg, text-size: 70pt) = {
  let width = 1770pt
  let height = 1300pt

  let bkg = image("assets/bkg.png")

  page(
    width: width,
    height: height,
    margin: 30pt,
    background: bkg,
    {
      set text(font: "Noto Sans", lang: "zh")
      align(
        center + horizon,
        {
          let size-mul(size, factor) = (
            "width": size.at("width") * factor,
            "height": size.at("height") * factor,
          )

          let rand(rng, min, max) = {
            let (g, n) = random(rng)
            return (g, n * (max - min) + min)
          }
          context {
            set text(size: text-size)

            let chars = ()
            let rng = gen-rng(msg.clusters().last().to-unicode())
            let cur-x = 0
            let cur-y = 0
            let padding-x = 0
            let padding-y = -text-size.pt()

            let my-red = rgb("E5191C")

            for line in msg.split("\n") {
              for (i, char) in line.clusters().enumerate() {
                let text-scale = none
                (rng, text-scale) = rand(rng, 0.8, 1)

                set text(size: text-size)
                let text-content = text(size: text-scale * text-size, char)
                if (i == 0) {
                  text-content = text(size: text-scale * text-size * 1.1, char)
                }

                let char-size = measure(text-content)

                let inner-box-size = size-mul(char-size, 1.2)
                let outter-box-size = none

                let init-angle = none
                (rng, init-angle) = rand(rng, -9, 0)

                let half-dx = inner-box-size.width / 2
                if (i == 0) {
                  outter-box-size = size-mul(char-size, 1.4)
                  half-dx = outter-box-size.width / 2
                }

                cur-x += half-dx.pt()

                if (i == 0) {
                  chars.push((
                    "x": cur-x,
                    "y": cur-y,
                    "char": (
                      "color": white,
                      "size": 1.1em,
                      "angle": 3 * init-angle,
                      "char": char,
                    ),
                    "inner": (
                      "fill": my-red,
                      "border": my-red,
                      "angle": 2 * init-angle - 2,
                      "size": inner-box-size,
                    ),
                    "outter": (
                      "fill": black,
                      "border": white,
                      "angle": init-angle - 5,
                      "size": outter-box-size,
                    ),
                  ))

                  cur-x += outter-box-size.width.pt() * 0.5
                } else {
                  let color-rand = none
                  (rng, color-rand) = random(rng)

                  let text-color = white
                  if (color-rand > 0.8) {
                    text-color = my-red
                  }

                  chars.push((
                    "x": cur-x,
                    "y": cur-y,
                    "char": (
                      "color": text-color,
                      "size": 1em * text-scale,
                      "angle": init-angle,
                      "char": char,
                    ),
                    "inner": (
                      "fill": black,
                      "border": white,
                      "angle": init-angle + 1,
                      "size": inner-box-size,
                    ),
                  ))

                  cur-x += inner-box-size.width.pt() * 0.5
                }
                cur-x += padding-x
              }
              cur-x = 0
              cur-y += padding-y
            }

            let line-end-x = none
            for (i, c) in chars.enumerate().rev() {
              if (cur-y != c.y) {
                cur-y = c.y
                line-end-x = c.x
              }
              chars.at(i).x -= line-end-x / 2
            }

            let angle-factor = calc.pi / 180

            canvas(
              length: 1.5pt,
              {
                import draw: line, content

                let rotated-rect(x, y, rect-dict) = {
                  let vec-mul(factor, vec) = {
                    return (factor * vec.first(), factor * vec.last())
                  }

                  let vec-add(vec1, vec2) = {
                    return (vec1.first() + vec2.first(), vec1.last() + vec2.last())
                  }

                  let w = rect-dict.size.width.pt()
                  let h = rect-dict.size.height.pt()

                  let w-vec = (
                    w * calc.cos(rect-dict.angle * angle-factor),
                    w * calc.sin(rect-dict.angle * angle-factor),
                  )
                  let h-vec = (
                    h * -calc.sin(rect-dict.angle * angle-factor),
                    h * calc.cos(rect-dict.angle * angle-factor),
                  )

                  let o = (x, y)

                  let p1 = vec-add(
                    o,
                    vec-add(
                      vec-mul(0.5, h-vec),
                      vec-mul(0.5, w-vec),
                    ),
                  )
                  let p2 = vec-add(vec-mul(-1, w-vec), p1)
                  let p3 = vec-add(vec-mul(-1, h-vec), p2)
                  let p4 = vec-add(w-vec, p3)

                  line(p1, p2, p3, p4, close: true, fill: rect-dict.fill, stroke: rect-dict.border + 0.06em)
                }

                for c in chars {
                  if (c.char.char == " ") {
                    continue
                  }

                  if (c.keys().contains("outter")) {
                    rotated-rect(c.x, c.y, c.outter)
                  }
                  rotated-rect(c.x, c.y, c.inner)

                  content(
                    (c.x, c.y),
                    rotate(
                      -c.char.angle * angle-factor * 1rad,
                      {
                        text(
                          size: c.char.size,
                          fill: c.char.color,
                          stroke: c.char.color + 0.05em,
                          c.char.char,
                        )
                      },
                    ),
                  )
                }
              },
            )
          }
        },
      )

      place(right + bottom, image("assets/logo.png"))
      place(
        left + bottom,
        {
          set text(
            size: 40pt,
            fill: rgb(255, 255, 255, 100),
            font: "Noto Sans",
          )
          grid(
            columns: 3,
            "Generated by ",
            text(
              font: "Buenard",
              baseline: -0.05em,
              fill: rgb("#40a3b4cc"),
              "typst",
            ),
            " with ❤️",
          )
        },
      )
    },
  )
}
