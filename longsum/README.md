# long sum
This is a POC of custom strechable characters in Typst, which implements `\suum` in TeX package pdfmsym.

## Features
- Stretchable `sum` operator
  ```typ
  #import "longsum.typ": longsum

  $ longsum(i <= x_1 comma x_2 comma ... comma x_m <= n, med) $
  ```

## Usage Notes
- Only works with default math font(New Computer Modern Math).
## Example
<details>
<summary>Click to expand</summary>

</details>