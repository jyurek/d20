all: dice

dice:
	ghc -o dice src/Main.hs

clean:
	find -name "*.hi" -exec rm {} ;
	find -name "*.o" -exec rm {} ;
