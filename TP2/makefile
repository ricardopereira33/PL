X = sipl
$(X) :  $(X).y
		flex $(X).fl
		yacc $(X).y
		cc y.tab.c -o prog `pkg-config --cflags --libs glib-2.0`