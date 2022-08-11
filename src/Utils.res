let createColumnAccessor = (tableIndex: int) => {
  %raw(`
    function(tableIndex, columnRef2Constructor) {
      return new Proxy({}, {
        get(_, columnName) {
          return columnRef2Constructor({ columnName, tableIndex });
        },
      });
    }
  `)(tableIndex, Ref.columnRef2)
}

let ensureArray: 'a => array<'a> = input => {
  %raw(`
    function(input) {
      return Array.isArray(input) ? input : [input];
    }
  `)(input)
}
