# Tree-like Document Builder for Typst

This is a `show` rule for building tree-like documents in [Typst](https://github.com/typst/typst). The initial version was developed by [@hongjr03](https://github.com/hongjr03), and I have refined the code, adding `#end-sect` and numbering-related features.

Although I've made efforts to extract customizable options from the huge `build-tree` function, I still think the code is too tightly coupled to be suitable for release as a public package.

## Features
- Tree-like Document Structure
  The original structure of Typst documents is linear, meaning headings and other content are arranged sequentially. This makes it challenging to customize styles (like section indentation) and add summaries after subsections. With `#show: build-tree(func: xxx)`, you can easily construct a tree-like document structure and use `#end-sect` to return to the parent "node".

- Section-Prefixed Numbering
  Numbers for `math.equation` and `figure` (by default, customizable through `build-tree` parameters) will be prefixed with `heading` numbers. This feature works consistently, even behind the last subsections of sections.

## Usage Notes

- It is recommended to place `#show: build-tree(func: xxx)` after other `show` and `set` statements, particularly those that wrap the entire document in a `style` or other structures that `build-tree` cannot interpret.

- The maximum supported tree depth is approximately 30 due to typst's maximum show rule depth limitation. If you really need more depth, you can either wait for typst to support customizing this limitation or use a modified version of typst.

- If you encounter any issues while using this tool, please feel free to report bugs.

## Example
<details>
<summary>Click to expand</summary>

![1](https://raw.githubusercontent.com/ParaN3xus/typst-snippets/refs/heads/main/tree/example/1.png)

![2](https://raw.githubusercontent.com/ParaN3xus/typst-snippets/refs/heads/main/tree/example/2.png)

</details>