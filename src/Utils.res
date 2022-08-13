let createColumnAccessor = (tableIndex: int) => {
  %raw(`
    function(tableIndex, columnRefConstructor) {
      return new Proxy({}, {
        get(_, columnName) {
          return columnRefConstructor({ columnName, tableIndex });
        },
      });
    }
  `)(tableIndex, Ref.Typed.columnRef)
}

let ensureArray: 'a => array<'a> = input => {
  %raw(`
    function(input) {
      return Array.isArray(input) ? input : [input];
    }
  `)(input)
}
