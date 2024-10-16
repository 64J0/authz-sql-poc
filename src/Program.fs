open System
open System.Reflection
open DbUp

// TODO use env vars
[<Literal>]
let CONN_STR =
    "Host=localhost;Port=5432;Database=public;Username=postgres;Password=changeme"

[<EntryPoint>]
let main (_args: string[]) : int =
    let createDbIfNotExists () =
        EnsureDatabase.For.PostgresqlDatabase(CONN_STR)

    do createDbIfNotExists ()

    let upgrade () =
        DeployChanges.To
            .PostgresqlDatabase(CONN_STR)
            .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
            .LogToConsole()
            .Build()
            .PerformUpgrade()

    let result = upgrade ()

    let mutable returnValue = 0 // success

    match result.Successful with
    | false ->
        Console.ForegroundColor <- ConsoleColor.Red
        Console.WriteLine result.Error
        returnValue <- 1 // error
    | true ->
        Console.ForegroundColor <- ConsoleColor.Green
        Console.WriteLine "Success!"

    Console.ResetColor()

    returnValue
