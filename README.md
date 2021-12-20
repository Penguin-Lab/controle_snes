# controle_snes
Esse controle parecido com o de SNES (mas com analógico) foi projetado para ser usado na disciplina de Sistemas Digitais da Engenharia Elétrica. Ele envia a leitura de todos os botões e do joystick para uma FPGA de uma placa de desenvolvimento Basys 2 da Digilent. Essa comunicação é feita por UART.

<img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/basys2.png" width="500">

<img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/controle0.jpg" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/controle1.jpg" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/controle2.jpg" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/controle3.jpg" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/controle4.jpg" width="300">

Este controle foi utilizado em um trabalho para o comando de sprites do Mario Bros. em um monitor VGA.

<img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/sprites3.png" width="500">

# Estrutura física
A estrutura física do controle é composta por duas peças da carcaça e 7 botões coloridos. Esse conjunto esconde a placa de circuito impresso desenvolvida e o módulo joystick.
As peças projetadas em 3D foram impressas utilizando PLA e podem ser encontradas na pasta [Pecas_3d](https://github.com/Penguin-Lab/controle_snes/tree/main/Pecas_3d) deste projeto.

<img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/solid0.png" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/solid1.png" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/solid2.png" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/solid3.png" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/solid4.png" width="300">

## Placas de circuito impresso
No projeto, foi desenvolvida uma placa de circuito para que um ATMEGA328p (arduino) pudesse ler os sinais do controle e enviá-los por UART para a FPGA.

<img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/controle1.jpg" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/placa0.jpg" width="300"> <img src="https://github.com/Penguin-Lab/controle_snes/blob/main/images/placa1.jpg" width="300">

O esquemático e o board do Eagle (v7.7.0) deste projeto podem ser encontrados na pasta [Placa](https://github.com/Penguin-Lab/controle_snes/tree/main/Placa). Lá também é possível encontrar o PDF para que seja impresso o projeto diretamente, sem precisar abrir o board no Eagle.

## Componentes eletrônicos
Os componentes eletrônicos utilizados para a confecção da placa são:
* 8x resistor 10k
* 2x resistor 150R
* 2x resistor 120R
* 7x push-buttons
* 1x LED vermelho 5mm
* 1x BUZZER
* 2x capacitores 22pF
* 1x cristal de clock 16MHz
* 1x soquete de 28 pinos
* 1x ATMEGA328p
* 1x módulo joystick
* 1x pinheader 6x1 macho 90 graus
* 1x pinheader 5x1 femea 90 graus

# Software
Na pasta [Codes](https://github.com/Penguin-Lab/controle_snes/tree/main/Codes), há o código de programação do arduino e da FPGA.

# Vídeo de teste
Caso queira ver um teste com o sistema funcionando, e com a implementação ainda do som do jogo sendo tocado no buzzer do controle, adicionamos um vídeo no [canal do Lab](https://www.youtube.com/channel/UCKsklKPVTsWEkaLD-hVZmng)!

[![Teste do controle de SNES em FPGA](https://img.youtube.com/vi/oQuVJGI_RX0/0.jpg)](https://www.youtube.com/watch?v=oQuVJGI_RX0)
