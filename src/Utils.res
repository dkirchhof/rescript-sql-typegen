%%raw(`
  import { inspect as inspect_ } from "util";
`)

let inspect = %raw(`
  function(value) {
    console.log(inspect_(value, false, 10, true));
  }
`)

let createColumnAccessorWithoutJoins = () => {
  %raw(`
    new Proxy({}, {
      get(_, columnName) {
        return { tableIndex: 0, columnName };
      },
    })
  `)
}

let createColumnAccessor = (tableIndex: int) => {
  %raw(`
    function(tableIndex) {
      return new Proxy({}, {
        get(_, columnName) {
          return { tableIndex, columnName };
        },
      });
    }
  `)(tableIndex)
}

let createColumnAccessorWithJoins = () => {
  %raw(`
    new Proxy({}, {
      get(_, tableIndexString) {
        return new Proxy({}, {
          get(_, columnName) {
            return { tableIndex: Number(tableIndexString), columnName };
          },
        });
      },
    })
  `)
}

let createAlias = index => Js.String.fromCharCode(index + 97)

let ensureArray: 'a => array<'a> = input => {
  %raw(`
    function(input) {
      return Array.isArray(input) ? input : [input];
    }
  `)(input)
}
