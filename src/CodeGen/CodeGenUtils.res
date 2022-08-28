/* let parseFirstCharForModuleName = string => { */
/*   let code = Js.String2.charCodeAt(string, 0) */

/*   if code >= 65.0 && code <= 90.0 { */
/*     Ok(string) */
/*   } else { */
/*     Error("The string must start with an capital letter.") */
/*   } */
/* } */

let indent = (str, indentation) => Js.String2.repeat(" ", indentation) ++ str
