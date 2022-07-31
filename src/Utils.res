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
