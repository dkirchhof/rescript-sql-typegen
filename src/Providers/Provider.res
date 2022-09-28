type queryResult<'t> = array<Js.Dict.t<'t>>

type get<'connection, 'result> = (string, 'connection) => promise<queryResult<'result>>

type mutationResult = {
  changes: int,
  lastId: int,
}

type mutate<'connection> = (string, 'connection) => promise<mutationResult>

let makeMutationResult = (~changes: int, ~lastId: int) => {changes, lastId}
