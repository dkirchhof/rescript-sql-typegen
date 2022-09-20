type t<'t> = {
  table: string,
  name: string,
  dt: string,
  size: option<int>,
  nullable: bool,
  unique: bool,
  default: option<'t>,
}
