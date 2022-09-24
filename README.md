Still very experimental. So the codegen and api could be changed completely.
  
The idea behind this library:

1. Define the basic schema in `example/_DB.res`.
1. Run `codegen` to create rescript types. The result will be written to `example/DB.res`. Try the generator without overwriting the file by running `codegen-dry`.
1. Write queries to create the tables, get some data or manipulate it. Several example queries can be found in `example/Examples.res`.
