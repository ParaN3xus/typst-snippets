# indenta
This is an refined indenta package for Typst >= 0.13.0.

## Features
- Indentation wherever you want

  With `#show: fix-indent`, you can control the indentation of paragraphs by linebreaks.
  ```typ
  #import "indenta.typ": fix-indent

  #show: fix-indent
  #set par(first-line-indent: (amount: 2em, all: true))
  $ sin^2 x + cos^2 x = 1 $
  This paragraph will not be indented.

  $ sin^2 x + cos^2 x = 1 $
  
  This paragraph will be indented, since there is an blank line.
  ```
- Pass through containers, `styled`, `enum`, etc
  
  With the original indenta package, you can't pass through elements like `box`, `styled`, `enum`, etc. So you'll have to use `#show: fix-indent` after other customizations, and it can't fix indentations inside those elements.

  With this refined indenta, the `fix-indent` will pass through `block`, `box`, `*.cell`, `*.item`, `styled` and `sequence` elements. So you can use `fix-indent` anywhere you want, and it will work anywhere expected in the document.
