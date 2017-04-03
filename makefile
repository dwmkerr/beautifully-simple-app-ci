# Builds everything in the universe.
build:
	$(info Cleaning up artifacts directory...)
	rm -rf artifacts; mkdir artifacts;

	# Build all of the apps, dumping them to the artifacts folder.
	cd 1_react_native_app/; make build; cp -f artifacts/* ../artifacts; cd ..;
	cd 2_ionic_app;/ make build; cp -f artifacts/* ../artifacts; cd ..;
	cd 3_native_app/; make build; cp -f artifacts/* ../artifacts; cd ..;
	cd 4_xamarinapp/; make build;  cp -f artifacts/* ../artifacts; cd ..;

