let createColumnAccessor = () => {
  %raw(`
    function() {
      return new Proxy({}, {
        get(_, tableAlias_column) {
          const indexOfUnderscore = tableAlias_column.indexOf("_");
          const tableAlias = tableAlias_column.slice(0, indexOfUnderscore);
          const columnName = tableAlias_column.slice(indexOfUnderscore + 1);

          return { table: tableAlias, name: columnName };
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
