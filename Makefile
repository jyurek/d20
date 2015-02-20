all: Main.hs

Main.hs:
	ghc -o dice src/Main.hs

clean:
	find -name "*.hi" -exec rm {} ;
	find -name "*.o" -exec rm {} ;
