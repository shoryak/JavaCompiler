# JavaCompiler
CS335 course project 

To do:
+ Integrate symbol table into parser
+ Figure out how to support types
+ Semantic analysis
+ 3AC Code gen

### Build Compiler
Run
```shell
cd src
make \<target\>
```

### Run corresponding script
```shell
cd bin
./ASTGenerator
```
or
```shell
./3ACGenerator
```

### Test current code
Run the commands
```shell
cd src
make test
../bin/test.out
```