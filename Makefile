build:
	mkdir bin/ build/ build/resources/
	x86_64-w64-mingw32-gcc -I include/ apps/main.c -o ./bin/launcher.exe
	find  ./.wsldock/* -maxdepth 1 -type d -printf '%f\n' > build/resl.txt
	xargs -a build/resl.txt -I{} x86_64-w64-mingw32-windres .wsldock/{}/res.rc -o build/resources/{}.o
	xargs -a build/resl.txt -I{} x86_64-w64-mingw32-gcc -I include/ apps/main.c build/resources/{}.o -o bin/{}.exe
	
	cd bin/ && zip ../build/launchers.zip *
	cd ..

clean:
	rm -rf build/
	rm -rf bin/