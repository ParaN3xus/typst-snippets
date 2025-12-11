# Bionic

A Typst implementation of the [Bionic Reading](https://bionic-reading.com/) method, ported from [text-vide](https://github.com/Gumball12/text-vide/). This package facilitates the reading process by guiding the eyes through text with artificial fixation points, highlighting initial letters to let the brain complete the word.

## Features

- Automatically highlights the beginning of words based on their length.
- Customizable fixations and processing functions for both bolded and regular parts of words.

## Usage

Import the function and fixations array, then apply it using a `#show` rule.

```typst
#import "bionic.typ": bionic, bionic-fixations

// Basic Usage: Use the default bolding with medium fixation intensity
#show: bionic.with(
  fixation: bionic-fixations.at(2)
)

// Advanced Usage: Grey out the non-bolded text for better contrast
#show: bionic.with(
  fixation: bionic-fixations.at(2),
  rest-func: text.with(fill: black.transparentize(30%))
)

// Your document content
Bionic Reading is a new method facilitating the reading process...
```

## Example
<details>
<summary>Click to expand</summary>

![1](https://raw.githubusercontent.com/ParaN3xus/typst-snippets/refs/heads/main/bionic/example/1.png)

</details>