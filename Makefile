build:
	mkdir build/ build/res/ build/launchers/
	x86_64-w64-mingw32-gcc -I include/ apps/main.c -o ./build/launcher.exe
	find  ./.wsldock/* -maxdepth 1 -type d -printf '%f\n' > build/resl.txt
	xargs -a build/resl.txt -I{} x86_64-w64-mingw32-windres .wsldock/{}/res.rc -o build/res/{}.o
	xargs -a build/resl.txt -I{} x86_64-w64-mingw32-gcc -I include/ apps/main.c build/res/{}.o -o build/launchers/{}.exe
	
	cd build/launchers/ && zip ../icons.zip *
	cd ..

clean:
	rm -rf build/