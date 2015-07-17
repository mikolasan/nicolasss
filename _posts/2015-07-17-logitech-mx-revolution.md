---
layout: post
category: pc
title: Необычные кнопки мыши в линуксе
---

**Что имеется:** мышь Logitech MX Revolution.

**Чего не хватает:** драйвера под ubuntu для хитрожопого колесика. В линуксе есть очень удобная функция на клик по колесу - вставка ранее выделенного текста. Без всяких `Ctrl+c` и `Ctrl+v`, только кликанье по кнопкам и колесику. Снимаешь наушники, а там... клацанье на весь офис...

**Зачем всё это?** Некоторые руководства (как вот это <https://help.ubuntu.com/community/MouseCustomizations>) сложно воспринимать, пока ты еще не погрузился в тему. При первом прочтении я ничего не понял. Используются неизвестные утилиты, от каждого конфига возникает больше вопросов, чем понимания.

<!--more-->

С давних времен настройка устройств ввода начинается с редактирования конфигурации Xorg-а.

## Конфигурации Xorg-а

{% blockquote Заметка для XServer версии 1.8 %}

Xorg can detect input devices using udev, deprecating its HAL support. Users are strongly encouraged to migrate to udev.
Xorg's configuration is now much more flexible thanks to generic match options and multiple-file merging capabilities.

{% endblockquote %}

Ищу `etc/X11/xorg.conf`. Всё тщетно, папка есть, а файла - нет. 

{% blockquote Kosyak с ЛОРа <http://www.linux.org.ru/forum/desktop/5908792?cid=5908812> %}

все настройки в иксах уже давно перенесли в /etc/X11/xorg.conf.d/

{% endblockquote %}

{% blockquote %}
Note that the One-Touch Search button doesn’t actually generate a button action but rather a key mapping.
{% endblockquote %}

- <https://wiki.archlinux.org/index.php/Logitech_MX_Revolution_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29>
- <https://help.ubuntu.com/community/Logitech_MX610>
- <http://blog.rootsmith.ca/linux/logitech-mx-revolution-mouse-on-linux/>



{% blockquote %}
The search button is actually treated as a keyboard button, with keycode 122.
{% endblockquote %}

- <http://andy.hillhome.org/blog/2006/09/27/logitech-mx-revolution-in-linux/>
- <http://habrahabr.ru/post/39129/>
- <https://github.com/sebastien/revoco>

Как он это узнал? `xev` тут бессилен :(





The configuration files of Xorg are stored in /etc/X11/xorg.conf.d/. Each file is given a unique name and ends in .conf. If the filenames start with a number, then Xorg will read the files in numeric order. 10-evdev.conf will be read before 20-synaptics.conf, and so on. You don't have to give them numbers, but it may help you organize them. [ https://wiki.gentoo.org/wiki/Xorg/Configuration ]

Иногда люди переписывают старые мануалы [ http://ubuntuforums.org/showthread.php?t=65471, 2005]. Получаются костыли в стиле "работеат - не трожь!". Поэтому строки "scroll down to the mouse section" должны вызывать усмешку легкой иронии.

Почему же? Обратная совместимость...

The xorg.conf.d is an additional folder where users can store adjustments to Xorg's configuraion without touching the main xorg.conf itself. The order of inheritance is quite simple. If present, xorg.conf be loaded, then the xorg.conf.d/**.conf files will be parsed next, in ASCII alphabetical order (so numbers will be first). [ http://www.gentoo.org/proj/en/desktop/x/x11/xorg-server-1.8-upgrade-guide.xml, 2010]
Однако эта директория все-таки существует и искать ее надо в /usr/share/X11/xorg.conf.d/ [ https://wiki.ubuntu.com/X/Config , http://askubuntu.com/questions/304091/wheres-the-xorg-conf-d-in-13-04 , 2013]

А теперь, уважаемые знатоки, вопрос: откуда они берут сразу готовый кусок нового конфига?! [ http://www.x.org/archive/X11R6.8.2/doc/mouse5.html#21 ]

**cat /proc/bus/input/devices**

```
I: Bus=0003 Vendor=046d Product=c525 Version=0111
N: Name="Logitech USB Receiver"
P: Phys=usb-0000:00:1d.2-2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input6
U: Uniq=
H: Handlers=mouse1 event4
B: PROP=0
B: EV=17
B: KEY=ffff0000 0 0 0 0
B: REL=143
B: MSC=10

I: Bus=0003 Vendor=046d Product=c525 Version=0111
N: Name="Logitech USB Receiver"
P: Phys=usb-0000:00:1d.2-2/input1
S: Sysfs=/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.1/input/input7
U: Uniq=
H: Handlers=kbd event5
B: PROP=0
B: EV=1f
B: KEY=4837fff072ff32d bf54444600000000 1 20f908b17c000 677bfad9415fed 9ed68000004400 10000002
B: REL=40
B: ABS=100000000
B: MSC=10
```

http://askubuntu.com/questions/152297/how-to-configure-extra-buttons-in-logitech-mouse

**xev**

```
ButtonRelease event, serial 40, synthetic NO, window 0x2c00001,
    root 0x1dc, subw 0x2c00002, time 3071618, (67,50), root:(844,828),
    state 0x10, button 7, same_screen YES

LeaveNotify event, serial 40, synthetic NO, window 0x2c00001,
    root 0x1dc, subw 0x0, time 3071572, (67,50), root:(844,828),
    mode NotifyUngrab, detail NotifyInferior, same_screen YES,
    focus YES, state 16

ButtonPress event, serial 40, synthetic NO, window 0x2c00001,
    root 0x1dc, subw 0x2c00002, time 3072446, (67,50), root:(844,828),
    state 0x10, button 6, same_screen YES

EnterNotify event, serial 40, synthetic NO, window 0x2c00001,
    root 0x1dc, subw 0x0, time 3072355, (67,50), root:(844,828),
    mode NotifyGrab, detail NotifyInferior, same_screen YES,
    focus YES, state 16

LeaveNotify event, serial 40, synthetic NO, window 0x2c00001,
    root 0x1dc, subw 0x2c00002, time 3077379, (67,50), root:(844,828),
    mode NotifyGrab, detail NotifyNonlinearVirtual, same_screen YES,
    focus YES, state 16

MappingNotify event, serial 40, synthetic NO, window 0x0,
    request MappingKeyboard, first_keycode 8, count 248
```

Счастливый триггер

https://github.com/wertarbyte/triggerhappy
http://manpages.ubuntu.com/manpages/precise/man1/thd.1.html

**sudo thd --dump /dev/input/event***

```
EV_KEY    KEY_ENTER    0    /dev/input/event3
# KEY_ENTER    0    command
EV_KEY    BTN_SIDE    1    /dev/input/event4
# BTN_SIDE    1    command
EV_KEY    BTN_SIDE    0    /dev/input/event4
# BTN_SIDE    0    command
EV_KEY    BTN_EXTRA    1    /dev/input/event4
# BTN_EXTRA    1    command
EV_KEY    BTN_EXTRA    0    /dev/input/event4
# BTN_EXTRA    0    command
Unknown EV_KEY event id on /dev/input/event4 : 282 (value 1)
Unknown EV_KEY event id on /dev/input/event4 : 282 (value 0)
Unknown EV_KEY event id on /dev/input/event4 : 280 (value 1)
Unknown EV_KEY event id on /dev/input/event4 : 280 (value 0)
EV_KEY    KEY_SEARCH    1    /dev/input/event5
# KEY_SEARCH    1    command
EV_KEY    KEY_SEARCH    0    /dev/input/event5
# KEY_SEARCH    0    command
EV_KEY    BTN_LEFT    1    /dev/input/event4
# BTN_LEFT    1    command
EV_KEY    BTN_LEFT    0    /dev/input/event4
# BTN_LEFT    0    command
EV_KEY    BTN_RIGHT    1    /dev/input/event4
# BTN_RIGHT    1    command
EV_KEY    BTN_RIGHT    0    /dev/input/event4
# BTN_RIGHT    0    command
EV_KEY    BTN_LEFT    1    /dev/input/event4
# BTN_LEFT    1    command
EV_KEY    BTN_LEFT    0    /dev/input/event4
# BTN_LEFT    0    command
Unknown EV_KEY event id on /dev/input/event4 : 284 (value 1)
Unknown EV_KEY event id on /dev/input/event4 : 284 (value 0)
```

**xinput --list --long**

```
Buttons supported: 24
        Button labels: "Button Left" "Button Middle" "Button Right" "Button Wheel Up" "Button Wheel Down"
"Button Horiz Wheel Left" "Button Horiz Wheel Right" "Button Side" "Button Extra" "Button Forward"
"Button Back" "Button Task" "Button Unknown" "Button Unknown" "Button Unknown" "Button Unknown"
"Button Unknown" "Button Unknown" "Button Unknown" "Button Unknown" "Button Unknown" "Button Unknown"
"Button Unknown" "Button Unknown"
```

*.xbindkeysrc*

```
####################################
# Setup mice Logitech RevolutionMX #
####################################

# thumb wheel up
#"xte 'key Page_Up'"
#  b:13

## thumb wheel down
#"xte 'key Page_Down'"
#  b:15

## xmodmap do this thing naturally
## thumb wheel press
##"xte 'mouseclick 2'"
##  b:17
#  
## main wheel left
#"xte 'keydown Alt_L' 'key Left' 'keyup Alt_L'"
#  b:6

## main wheel right
#"xte 'keydown Alt_L' 'key Right' 'keyup Alt_L'"
#  b:7

## left edge down
#"xte 'keydown Control_L' 'key Insert' 'keyup Control_L'"
#  b:8

## left edge up
#"xte 'keydown Shift_L' 'key Insert' 'keyup Shift_L'"
#  b:9
```


*.Xmodmap*

```
pointer = 1 17 3 4 5 6 7 8 9 10 11 12 13 14 15 16 2 18 19 20
keycode 122 = XF86AudioMute
```

[ https://wiki.ubuntu.com/X/Config/Input , https://help.ubuntu.com/community/Logitech_MX610 , https://sites.google.com/site/simohmattila/mx610-notification ] Ничего нового, но привело к тому, что люди занимаются тем, что ломают мышей.

В заключении.
http://gnomeshell.wordpress.com/2011/08/28/manage-the-startup-applications/ добавить в автозагрузку

расширяем горизонты http://blog.sleeplessbeastie.eu/2013/01/21/how-to-automate-mouse-and-keyboard/

http://spritesmods.com/?art=rapidisnake&page=5
