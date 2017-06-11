X = sipl
$(X) :  $(X).y
		flex $(X).fl
		yacc $(X).y
		cc y.tab.c -o iPL `pkg-config --cflags --libs glib-2.0`
