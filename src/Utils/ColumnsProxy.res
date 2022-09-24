let make = () => {
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
