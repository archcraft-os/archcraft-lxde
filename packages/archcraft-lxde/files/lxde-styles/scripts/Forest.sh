#!/usr/bin/env bash

## Dirs #############################################
terminal_cfg="$HOME/.config/lxterminal/lxterminal.conf"
geany_cfg="$HOME/.config/geany/geany.conf"
openbox_cfg="$HOME/.config/openbox/lxde-rc.xml"
dunst_cfg="$HOME/.config/dunst/dunstrc"
lxsession_cfg="$HOME/.config/lxsession/LXDE/desktop.conf"

# Wallpaper ---------------------------------
set_wall() {
	pcmanfm --wallpaper-mode=crop --set-wallpaper=/usr/share/backgrounds/"${1}"
}

# LXterminal ---------------------------------
change_lxterm () {
	sed -i -e "s/fontname=.*/fontname=$1/g"                      "$terminal_cfg"
	sed -i -e 's/bgcolor=.*/bgcolor=#222d32/g'                   "$terminal_cfg"
	sed -i -e 's/fgcolor=.*/fgcolor=#c4c7c5/g'                   "$terminal_cfg"
	sed -i -e 's/palette_color_0=.*/palette_color_0=#263640/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_1=.*/palette_color_1=#EC7875/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_2=.*/palette_color_2=#61C766/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_3=.*/palette_color_3=#FDD835/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_4=.*/palette_color_4=#42A5F5/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_5=.*/palette_color_5=#BA68C8/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_6=.*/palette_color_6=#4DD0E1/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_7=.*/palette_color_7=#BFBAAC/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_8=.*/palette_color_8=#4A697D/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_9=.*/palette_color_9=#FB8784/g'   "$terminal_cfg"
	sed -i -e 's/palette_color_10=.*/palette_color_10=#70D675/g' "$terminal_cfg"
	sed -i -e 's/palette_color_11=.*/palette_color_11=#FFE744/g' "$terminal_cfg"
	sed -i -e 's/palette_color_12=.*/palette_color_12=#51B4FF/g' "$terminal_cfg"
	sed -i -e 's/palette_color_13=.*/palette_color_13=#C979D7/g' "$terminal_cfg"
	sed -i -e 's/palette_color_14=.*/palette_color_14=#5CDFF0/g' "$terminal_cfg"
	sed -i -e 's/palette_color_15=.*/palette_color_15=#FDF6E3/g' "$terminal_cfg"
}

# Dunst -------------------------------------
change_dunst() {
	sed -i '/urgency_low/Q' "${dunst_cfg}"
	cat >> "${dunst_cfg}" <<- _EOF_
		[urgency_low]
		timeout = 2
		background = "#212B30"
		foreground = "#C4C7C5"
		frame_color = "#4DD0E1"

		[urgency_normal]
		timeout = 5
		background = "#212B30"
		foreground = "#C4C7C5"
		frame_color = "#4DD0E1"

		[urgency_critical]
		timeout = 0
		background = "#212B30"
		foreground = "#EC407A"
		frame_color = "#EC407A"
	_EOF_

	pkill dunst && dunst &
}

# Geany ---------------------------------
change_geany() {
	sed -i -e "s/color_scheme=.*/color_scheme=$1.conf/g"  "$geany_cfg"
	sed -i -e "s/editor_font=.*/editor_font=$2/g"         "$geany_cfg"
}

# LXDE openbox -----------------------------------
obconfig () {
	namespace="http://openbox.org/3.4/rc"
	config="$openbox_cfg"
	theme="$1"
	layout="$2"
	font="$3"
	fontsize="$4"

	# Theme
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:name' -v "$theme" "$config"

	# Title
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:titleLayout' -v "$layout" "$config"

	# Fonts
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:slant' -v Normal "$config"
}

# Gtk Theme, Icons and Cursor ---------------------------------
change_gtk() {
	sed -i -e "s#sNet/ThemeName=.*#sNet/ThemeName=$1#g"                   "$lxsession_cfg"
	sed -i -e "s#sNet/IconThemeName=.*#sNet/IconThemeName=$2#g"           "$lxsession_cfg"
	sed -i -e "s#sGtk/CursorThemeName=.*#sGtk/CursorThemeName=$3#g"       "$lxsession_cfg"

	sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=\"$1\"/g"                ${HOME}/.gtkrc-2.0
	sed -i -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=\"$2\"/g"      ${HOME}/.gtkrc-2.0
	sed -i -e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=\"$3\"/g"  ${HOME}/.gtkrc-2.0	
	sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=$1/g"                    ${HOME}/.config/gtk-3.0/settings.ini
	sed -i -e "s/gtk-icon-theme-name=.*/gtk-icon-theme-name=$2/g"          ${HOME}/.config/gtk-3.0/settings.ini
	sed -i -e "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$3/g"      ${HOME}/.config/gtk-3.0/settings.ini

	if [[ -f "$HOME"/.icons/default/index.theme ]]; then
		sed -i -e "s/Inherits=.*/Inherits=$3/g" "$HOME"/.icons/default/index.theme
	fi	
}

# notify ---------------------------------
notify_user () {
	local style=`basename $0` 
	notify-send -u normal -i /usr/share/icons/Archcraft/actions/24/channelmixer.svg "Applying Style : ${style%.*}"
}

## Execute Script -----------------------
notify_user

# Set Wallpaper
set_wall 'forest.jpg'

# LX terminal Colors
change_lxterm 'JetBrainsMono Nerd Font 10'

# Dunst Colors
change_dunst

# SCHEME | FONT
change_geany 'adapta' 'JetBrains Mono 10'

# THEME | LAYOUT | FONT | SIZE
obconfig 'Adapta-Nokto' 'DLIMC' 'Noto Sans' '9' && openbox --reconfigure

# THEME | ICON | CURSOR
change_gtk 'Adapta-Nokto' 'Archcraft-Dark' 'Pear' && sleep 2 && lxpanelctl restart
