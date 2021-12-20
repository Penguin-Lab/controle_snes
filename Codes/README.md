# Código para arduino e para FPGA
Os códigos estão separados em código para o ATMEGA328P (arduino) do controle e código em VHDL para a FPGA.

## Código do controle
O código do controle basicamente lê todos os 8 botões (7 mais o do analógico) e o joystick (analógicos vertical e horizontal), e envia via UART pelo pino RX do controle para a FPGA. Perceba que o pino se chama RX por ser o receptor da FPGA.

<img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/pinos_controle.png" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/controle4.jpg" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/pinos_controle1.png" width="500">

A placa de desenvolvimento utilizada foi a Basys 2 da Digilent:

<img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/basys2.png" width="300">

## Código da FPGA
O código em VHDL possui a seguinte estrutura:
- [marIO.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/marIO.vhd)
  - [uart_module.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/uart_module.vhd)
  - [uart_core.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/uart_core.vhd)
  - [timer.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/timer.vhd)
  - [mario_sprite.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/mario_sprite.vhd)
  - [pinmap.ucf](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/pinmap.ucf)

O bloco [marIO.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/marIO.vhd) recebe as informações via UART pelo bloco [uart_module.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/uart_module.vhd), que processa o sinal serial por meio do [uart_core.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/uart_core.vhd).

Para mostrar na tela o sprite do Mario e movimentar o personagem, temos o bloco [mario_sprite.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/mario_sprite.vhd). A velocidade de mudança do sprite e a de comunicação VGA (clock de 25MHz) são controladas por um [timer.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/timer.vhd).

Para conectar os sinais aos pinos físicos da placa, temos o [pinmap.ucf](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/pinmap.ucf).

**Obs:** para que a comunicação VGA seja estável na placa Basys 2, foi necessário adquirir um CI de clock externo (clock de 50MHz indicado pelo datasheet da placa), conectado nos pinos M6
**Obs2:** para utilizar o código em uma placa diferente, basta mapear os pinos atuais nos pinos da nova placa.

## Pinos do controle
O controle possui um conector de 6 pinos com os seguintes sinais cuja sequência segue os terminais de conexão externa da placa:

<img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/pinos_controle.png" width="300">

  - **VCC**: alimentação do controle
  - **GND**: referência
  - **BUZZER**: pino B5 sendo saída da FPGA para comandar o buzzer do controle
  - **LED**: pino J3 sendo saída da FPGA para comandar o LED do controle
  - **RX**: pino A3 sendo entrada da FPGA para receber os dados de leitura do controle de SNES
  - **N/C**: pino sem conexão

## Leitura dos botões do controle
O controle lê por meio do ATMEGA328p o estado de todos os botões e analógicos e envia por UART para a FPGA quatro dados de 8 bits no formato:

  - **data1**: "00" & **X** & **Y** & **B** & **A** & **L** & **R**
  - **data2**: "01" & **start** & **bt** & **Ax(7 downto 4)**
  - **data3**: "10" & **Ax(3 downto 0)** & **Ay(7 downto 6)**
  - **data4**: "11" & **Ay(5 downto 0)**

Sendo, **bt** o botão do joystick.

Assim que o [uart_module.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/uart_module.vhd) recebe todos os quatro dados de 8 bits, ele avisa ao [marIO.vhd](https://github.com/Penguin-Lab/controle_snes/blob/main/Codes/mario_vhdl/marIO.vhd) que os dados novos estão disponíveis colocando o sinal **validData** em '1'.
