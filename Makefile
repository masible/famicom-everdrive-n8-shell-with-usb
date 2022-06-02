all: n8-shell-usb-back.stl n8-shell-usb-front.stl images/render.png

n8-shell-usb-back.stl: n8-shell-with-usb.scad NopSCADlib-copypaste.scad
	echo "use <n8-shell-with-usb.scad> back_shell();" | openscad -o $@ -

n8-shell-usb-front.stl: n8-shell-with-usb.scad NopSCADlib-copypaste.scad
	echo "use <n8-shell-with-usb.scad> front_shell();" | openscad -o $@ -

images/render.png: n8-shell-with-usb.scad NopSCADlib-copypaste.scad
	echo "use <n8-shell-with-usb.scad> front_shell(); pcb();" | openscad -o $@ -

clean:
	rm -f n8-shell-usb-back.stl n8-shell-usb-front.stl images/render.png
