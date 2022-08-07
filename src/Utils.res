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

let ensureArray: 'a => array<'a> = input => {
  %raw(`
    function(input) {
      return Array.isArray(input) ? input : [input];
    }
  `)(input)
}
