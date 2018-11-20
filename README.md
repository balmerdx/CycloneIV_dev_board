# Отладочная плата на Cyclone IV

Это простая отладочная плата для FPGA Cyclone IV EP4CE10.
Кроме собственно FPGA на ней расположенны:
* 4 светодиода
* CP2102 для общения с компьютером по UART
* SPI Flash для записи прошивки
* JTAG
* 28 ножек FPGA для подключения пользовательских устройств

### Плата в KICAD

![KICAD shot](https://raw.githubusercontent.com/balmerdx/CycloneIV_dev_board/master/documentation/pcb_view.png)

### Внешний вид

![Front](https://raw.githubusercontent.com/balmerdx/CycloneIV_dev_board/master/documentation/board_front.JPG)
![Back](https://raw.githubusercontent.com/balmerdx/CycloneIV_dev_board/master/documentation/board_back.JPG)

### Папки

В папке **ep4ce10_0** располагается собственно проект на KiCAD.
В папке examples пара примеров, работающих на ней.

**examples/test_my_board_led** - сравнительно простой пример, который умеет мигать светодиодами и принимать байт с командами по UART (на скорости 115200 bps). Пример общения с компьютером в файле examples/test_my_board_led/test_usart.py . Формат команды простой, посылаем 1 байт на устройство. Младшие 4 бита - состояние светодиодов (включенно/выключенно). Старший бит - переводит устройство в "самостоятельное плавание", когда оно начинает мигать светодиодиками самостоятельно.

**examples/test_my_board_advanced** - более сложный пример. Не только принимает команды по UART, но и отсылает в ответ строку, которую берет из заранее инициализированной памяти.
