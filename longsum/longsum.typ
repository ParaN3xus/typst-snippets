#let longsum(sub, sup) = context {
  let sum = $ sum $

  let len = measure($ sum_#sub^sup $).width
  let n = calc.max(calc.ceil((len - 1.4em.to-absolute()) / 0.07em.to-absolute()), 0)

  let clip-sum(start, len) = {
    box(
      width: len,
      clip: true,
      align(left + horizon, move(dx: -start, sum)),
    )
  }

  let sum-neck(len) = {
    let n = int(len / 0.07em.to-absolute())
    let rem = len - n * 0.07em
    n * (clip-sum(0.035em, 0.07em),)
    (clip-sum(0.035em, rem),)
  }

  math.attach(
    math.op(
      box(
        stack(
          dir: ltr,
          clip-sum(-0.335em, 0.68em),
          ..sum-neck(calc.max((len - 1.2em.to-absolute()).pt(), 0) * 1pt),
          clip-sum(0.35em, 0.65em),
        ),
        baseline: 0.452em,
      ),
      limits: true,
    ),
    b: sub,
    t: sup,
  )
}

