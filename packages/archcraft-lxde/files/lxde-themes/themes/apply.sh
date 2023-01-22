#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>
##
## Script To Apply Themes

## Theme ------------------------------------
THEME="$1"
THEME_FILE="$HOME/.config/lxde-themes/themes/${THEME}.bash"

if [[ -z "$THEME" ]]; then
	echo "Missing Theme Argument!"
	exit 1
fi

if [[ -f "$THEME_FILE" ]]; then
	source "$THEME_FILE"
else
	echo "Theme Not Available : $THEME"
	exit 1
fi

## Directories ------------------------------
PATH_CONF="$HOME/.config"
PATH_DUNST="$PATH_CONF/dunst"
PATH_GEANY="$PATH_CONF/geany"
PATH_OBOX="$PATH_CONF/openbox"
PATH_TERM="$PATH_CONF/lxterminal"
PATH_LXDE="$PATH_CONF/lxsession/LXDE"

## Wallpaper ---------------------------------
apply_wallpaper() {
	pcmanfm --wallpaper-mode=crop --set-wallpaper="$wallpaper"
}

# Terminal ----------------------------------
apply_terminal() {
	sed -i ${PATH_TERM}/lxterminal.conf \
		-e "s/fontname=.*/fontname=$terminal_font_name $terminal_font_size/g" \
		-e "s/bgcolor=.*/bgcolor=$background/g" \
		-e "s/fgcolor=.*/fgcolor=$foreground/g" \
		-e "s/palette_color_0=.*/palette_color_0=$color0/g" \
		-e "s/palette_color_1=.*/palette_color_1=$color1/g" \
		-e "s/palette_color_2=.*/palette_color_2=$color2/g" \
		-e "s/palette_color_3=.*/palette_color_3=$color3/g" \
		-e "s/palette_color_4=.*/palette_color_4=$color4/g" \
		-e "s/palette_color_5=.*/palette_color_5=$color5/g" \
		-e "s/palette_color_6=.*/palette_color_6=$color6/g" \
		-e "s/palette_color_7=.*/palette_color_7=$color7/g" \
		-e "s/palette_color_8=.*/palette_color_8=$color8/g" \
		-e "s/palette_color_9=.*/palette_color_9=$color9/g" \
		-e "s/palette_color_10=.*/palette_color_10=$color10/g" \
		-e "s/palette_color_11=.*/palette_color_11=$color11/g" \
		-e "s/palette_color_12=.*/palette_color_12=$color12/g" \
		-e "s/palette_color_13=.*/palette_color_13=$color13/g" \
		-e "s/palette_color_14=.*/palette_color_14=$color14/g" \
		-e "s/palette_color_15=.*/palette_color_15=$color15/g"
}

# Geany -------------------------------------
apply_geany() {
	sed -i ${PATH_GEANY}/geany.conf \
		-e "s/color_scheme=.*/color_scheme=$geany_colors/g" \
		-e "s/editor_font=.*/editor_font=$geany_font/g"
}

# Appearance --------------------------------
apply_appearance() {
	# apply gtk theme, icons, cursor & fonts
	sed -i ${PATH_LXDE}/desktop.conf \
		-e "s#sGtk/FontName=.*#sGtk/FontName=$gtk_font#g" \
		-e "s#sNet/ThemeName=.*#sNet/ThemeName=$gtk_theme#g" \
		-e "s#sNet/IconThemeName=.*#sNet/IconThemeName=$icon_theme#g" \
		-e "s#sGtk/CursorThemeName=.*#sGtk/CursorThemeName=$cursor_theme#g"

	sed -i ${HOME}/.gtkrc-2.0 \
		-e "s/gtk-font-name=.*/gtk-font-name=\"$gtk_font\"/g" \
		-e "s/gtk-theme-name=.*/gtk-theme-name=\"$gtk_theme\"/g" \
		-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$icon_theme\"/g" \
		-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$cursor_theme\"/g"

	sed -i ${PATH_CONF}/gtk-3.0/settings.ini \
		-e "s/gtk-font-name=.*/gtk-font-name=$gtk_font/g" \
		-e "s/gtk-theme-name=.*/gtk-theme-name=$gtk_theme/g" \
		-e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$icon_theme/g" \
		-e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$cursor_theme/g"

	# inherit cursor theme
	if [[ -f "$HOME"/.icons/default/index.theme ]]; then
		sed -i -e "s/Inherits=.*/Inherits=$cursor_theme/g" "$HOME"/.icons/default/index.theme
	fi	

	# restart lxpanel
	#sleep 2 && lxpanelctl restart
}

# Openbox -----------------------------------
apply_obconfig () {
	namespace="http://openbox.org/3.4/rc"
	config="$PATH_OBOX/lxde-rc.xml"

	# Theme
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:name' -v "$ob_theme" "$config"

	# Title
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:titleLayout' -v "$ob_layout" "$config"

	# Fonts
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:name' -v "$ob_font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:size' -v "$ob_font_size" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:name' -v "$ob_font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:size' -v "$ob_font_size" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:name' -v "$ob_font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:size' -v "$ob_font_size" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:name' -v "$ob_font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:size' -v "$ob_font_size" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:name' -v "$ob_font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:size' -v "$ob_font_size" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:name' -v "$ob_font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:size' -v "$ob_font_size" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	# Reload Openbox Config
	openbox --reconfigure
}

# Dunst -------------------------------------
apply_dunst() {
	# modify colors
	sed -i '/urgency_low/Q' ${PATH_DUNST}/dunstrc
	cat >> ${PATH_DUNST}/dunstrc <<- _EOF_
		[urgency_low]
		timeout = 2
		background = "${background}"
		foreground = "${foreground}"
		frame_color = "${color4}"

		[urgency_normal]
		timeout = 5
		background = "${background}"
		foreground = "${foreground}"
		frame_color = "${color4}"

		[urgency_critical]
		timeout = 0
		background = "${background}"
		foreground = "${color1}"
		frame_color = "${color1}"
	_EOF_

	# restart dunst
	pkill dunst && dunst &
}

# Create Theme File -------------------------
create_file() {
	theme_file="$HOME/.config/lxde-themes/themes/.current"
	if [[ ! -f "$theme_file" ]]; then
		touch ${theme_file}
	fi
	echo "${THEME^}" > ${theme_file}
}

# Notify User -------------------------------
notify_user() {
	dunstify -u normal -h string:x-dunst-stack-tag:applytheme -i /usr/share/archcraft/icons/dunst/themes.png "Applying Style : ${THEME^}"
}

## Execute Script ---------------------------
notify_user
create_file
apply_wallpaper
apply_terminal
apply_geany
apply_appearance
apply_obconfig
apply_dunst

# fix cursor theme (run it in the end)
xsetroot -cursor_name left_ptr
