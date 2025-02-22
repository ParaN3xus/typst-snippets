#let is-block(e, fn) = (
  fn == heading
    or (fn == math.equation and e.block)
    or (fn == raw and e.has("block") and e.block)
    or fn == figure
    or fn == block
    or fn == table
    or fn == grid
    or fn == align
    or (fn == quote and e.has("block") and e.block)
)

#let child-map = (
  block: "body",
  box: "body",
  cell: "body",
  item: "body",
  styled: "",
)

#let children-map = (
  table: "children",
  grid: "children",
  sequence: "children",
)

#let processed-tag = metadata("_indenta_processed")

#let fix-indent(body) = {
  let fbody = body.func()
  let wrapper(x) = box(
    width: 100%,
    inset: 0pt,
    outset: 0pt,
    fill: none,
    stroke: none,
    processed-tag + x,
  )

  let fstr = repr(fbody)

  if fstr in child-map.keys() {
    // recursively process elements with a single child
    let ckey = child-map.at(fstr)
    if (
      fstr == "box" and repr(body.body.func()) == "sequence" and body.body.children.first() == processed-tag
    ) {
      // don't process processed boxes
    } else if fstr == "styled" {
      // special: positional children
      body = fbody(
        fix-indent(body.child),
        body.styles,
      )
    } else {
      // normal case
      body = fbody(
        // retain all other fields
        ..{
          let ps = body.fields()
          _ = ps.remove(ckey)
          ps
        },
        // process the child
        fix-indent(body.at(ckey)),
      )
    }
  }

  if fstr in children-map.keys() {
    // recursively process elements with multiple children
    let ckey = children-map.at(fstr)
    if fstr == "sequence" {
      // special case: list, enum and term items in sequences
      // directly wrap items in a box will break them, so we need to group consecutive items, and wrap them together
      let groups = ()
      let current_group = ()
      let current_type = none
      let i = 0

      let is_separator(x) = x == [ ] or x == parbreak()

      while i < body.children.len() {
        let child = body.children.at(i)
        let c-is-sep = is_separator(child)
        let item_type = if repr(child.func()) == "item" { child.func() }

        if item_type != none {
          // is item
          if current_type == none {
            // current none, new group
            current_type = item_type
            current_group.push(child)
          } else if current_type == item_type {
            // same type, check previous item
            let prev = if i > 0 { body.children.at(i - 1) }

            // is sep, same group
            if prev != none and is_separator(prev) {
              current_group.push(prev)
              current_group.push(child)
            } else {
              // not sep, new group
              if current_group.len() > 0 {
                groups.push(current_group)
              }
              current_group = (child,)
            }
          } else {
            // different type, new group
            if current_group.len() > 0 {
              groups.push(current_group)
            }
            current_group = (child,)
            current_type = item_type
          }
        } else if c-is-sep and current_group.len() > 0 {
          // keep sep
          current_group.push(child)
        } else {
          // not item, not sep, end group
          if current_group.len() > 0 {
            groups.push(current_group)
            current_group = ()
            current_type = none
          }
          // push it
          groups.push(child)
        }
        i += 1
      }

      // remaining group
      if current_group.len() > 0 {
        groups.push(current_group)
      }

      // extract trailing separators in groups
      let final_groups = ()
      for group in groups {
        if type(group) == array and group.len() > 1 and is_separator(group.at(-1)) {
          let sep = group.pop()
          final_groups.push(group)
          final_groups.push(sep)
        } else {
          final_groups.push(group)
        }
      }
      groups = final_groups

      // process each group
      body = fbody(
        groups.map(group => {
          if type(group) == array {
            wrapper(fbody(group.map(fix-indent)))
          } else {
            fix-indent(group)
          }
        }),
      )
    } else {
      // normal case
      body = fbody(
        ..{
          let ps = body.fields()
          _ = ps.remove(ckey)
          ps
        },
        ..body.at(ckey).map(fix-indent),
      )
    }
  }

  let isb = is-block(body, fbody)

  if isb {
    return wrapper(body)
  } else {
    return body
  }
}
