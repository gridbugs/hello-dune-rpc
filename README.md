# Simple example program using `dune-rpc-lwt`

## Usage

In one terminal, run dune in watch mode. This will build this project and also
start an rpc server which the example program will connect to:
```
$ dune build -w
```

In a second terminal, run:
```
_build/default/hello_rpc.exe
```
