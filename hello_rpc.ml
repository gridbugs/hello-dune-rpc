module Drpc_lwt = Dune_rpc_lwt.V1
module Drpc = Dune_rpc.V1

let build_dir = "_build"

let () =
  let init = Drpc.Initialize.create ~id:(Drpc.Id.make (Csexp.Atom "hello")) in
  let where = Drpc_lwt.Where.default ~build_dir () in
  print_endline
    (Printf.sprintf "Connecting to server: %s"
       (Dune_rpc_private.Where.to_string where));
  Lwt_main.run
    (let open Lwt.Syntax in
    let open Lwt.Infix in
    let* input_channel, output_channel = Drpc_lwt.connect_chan where in
    Drpc_lwt.Client.connect (input_channel, output_channel) init
      ~f:(fun client ->
        print_endline "client is running";
        let* request =
          Drpc_lwt.Client.Versioned.prepare_request client
            Drpc.Request.build_dir
          >|= Result.get_ok
        in
        let* response =
          Drpc_lwt.Client.request client request () >|= Result.get_ok
        in
        print_endline
          (Printf.sprintf "path is: %s" (Drpc.Path.to_string_absolute response));
        Lwt.return_unit))
