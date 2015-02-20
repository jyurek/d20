all: Main.hs

Main.hs:
	ghc -o d20 src/Main.hs

clean:
	find -name "*.hi" -exec rm {} ;
	find -name "*.o" -exec rm {} ;
	rm -f d20
