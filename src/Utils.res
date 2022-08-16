let createColumnAccessor = () => {
  %raw(`
    function(columnRefConstructor) {
      return new Proxy({}, {
        get(_, tableAlias) {
          return new Proxy({}, {
            get(_, columnName) {
              return columnRefConstructor({ tableAlias, columnName });
            },
          });
        },
      });
    }
  `)(Ref.Typed.columnRef)
}

let ensureArray: 'a => array<'a> = input => {
  %raw(`
    function(input) {
      return Array.isArray(input) ? input : [input];
    }
  `)(input)
}
