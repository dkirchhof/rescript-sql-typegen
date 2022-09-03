let createColumnAccessor = () => {
  %raw(`
    function() {
      return new Proxy({}, {
        get(_, tableAlias) {
          return new Proxy({}, {
            get(_, columnName) {
              return { table: tableAlias, name: columnName };
            },
          });
        },
      });
    }
  `)()
}

let ensureArray: 'a => array<'a> = input => {
  %raw(`
    function(input) {
      return Array.isArray(input) ? input : [input];
    }
  `)(input)
}

let flatten: array<array<'a>> => array<'a> = arr => {
  %raw(`
    function(arr) {
      return arr.flat();
    }
  `)(arr)
} 
