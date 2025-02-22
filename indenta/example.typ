#import "indenta.typ": fix-indent

#show: fix-indent

#set par(first-line-indent: (amount: 2em, all: true))
#set text(blue)

#table(
  [
    + 1
    + 2

    123
  ],
  grid([
      + 1
      + 2
      123

      #box[
        $ sin x $
        123
      ]

      #block[
        $ sin x $

        123
      ]

      + 123
        $ sin x $

        123

        $ sin x $
        123
    ])
)
