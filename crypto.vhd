

-- VHDL-описание модуля блочного шифрования 64-бит данных.

-- Шифрование одной 64-битовки представляет собой её 32-тактное преобразование 
-- по заданному алгоритму.

-- Обмен данными между внешним процессорным ядром и модулем шифрования происходит по интерфейсу SPI.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity crypto is
    port (SPCK : in std_logic; -- 2Mhz -- spi
	 		 CLK: in std_logic;	-- 100Mhz
			 CS: in std_logic;
	       MOSI: in STD_LOGIC;
			 MISO: out std_logic;
			 IRQ0: out STD_LOGIC); -- сигнал прерывания (при завершении процедуры шифрования завершена) 
end crypto;

architecture archi of crypto is

component spis is
generic(n: POSITIVE); -- размерность адресного пространства блока SPI
    port (SPCK : in std_logic; -- 2Mhz -- spi
	 		 CLK: in std_logic;	-- 100Mhz
			 CLR: in std_logic; -- общий сброс или сброс по окончании процедуры шифрования
			 CS: in std_logic;
	       MOSI: in STD_LOGIC;
			 MISO: out std_logic;
	       CS1: out std_logic; -- синхронизация CS			 
			 DO_CLR: in std_logic_vector(6 downto 0); -- сброс внутренних счётчиков регистров			 
			 DATA_OUT: out std_logic_vector(63 downto 0); -- 64 бит для шифрования
			 DATA_IN: in std_logic_vector(63 downto 0); -- зашифрованные 64 бит
			 syncro: out std_logic_vector(63 downto 0); -- синхропосылка
			 key: out std_logic_vector(495 downto 0); -- ключ
			 CSR1: out STD_LOGIC_VECTOR (1 downto 0); -- регистр CSR1 (регистр разрешения и запуска процедуры шифрования)
			 CSR3: out STD_LOGIC_VECTOR (7 downto 0); -- регистр CSR3 (регистр сброса)
			 notoprd: out STD_LOGIC; -- чтение
          opwr: out STD_LOGIC; 
			 wrkey: out STD_LOGIC; -- перед процедурой шифрования был записан ключ  
          wrsync: out STD_LOGIC; -- перед процедурой шифрования была записана синхропосылка
			 ctrl1: out STD_LOGIC; -- операция записи/чтения в регистр CSR1
          ctrl3: out STD_LOGIC; -- операция записи в регистр CSR3
          RUN: in std_logic);			 
end component spis;

-- модуль шифрования
component Crypto7 is
port (CLK: in STD_LOGIC;
		CLR: in STD_LOGIC; 
		start: in std_logic; -- Запуск шифрования 64-битной порции данных	
      A: in std_logic_vector(495 downto 0); -- 512-битный ключ
		DO_RGI0: in STD_LOGIC_VECTOR(63 downto 0); -- синхропосылка
		DATA_DI: in STD_LOGIC_VECTOR(63 downto 0); -- данные для шифрования	
		DO_RGI_CR: out STD_LOGIC_VECTOR(63 downto 0); -- порция зашифрованных данных (дежурный регистр)(64 бит)
		wrkey: in std_logic; -- перед процедурой шифрования был записан новый ключ
	   wrsync: in std_logic; -- перед процедурой шифрования была записана новая синхропосылка
		fin: out STD_LOGIC); -- процедура шифрования завершена
end component Crypto7;

-- базовый модуль управления
component ctrlcomp is
generic(m: POSITIVE); -- число импульсов сброса (не считая импульса общего сброса) (m = 7)
port(DI_RST: in std_logic; -- общий сброс
     DI_CLR: in STD_LOGIC_VECTOR (m-1 downto 0); -- сигналы сброса разрядов регистра CSR (не считая импульса общего сброса)  
	  CSR1: in STD_LOGIC_VECTOR (1 downto 0); -- регистр CSR1 (регистр разрешения и запуска процедуры шифрования)
     CLK: in std_logic;
     CS: in std_logic; -- синхронный CS
	  notoprd: in STD_LOGIC; -- чтение
     opwr: in STD_LOGIC; -- запись
	  ctrl1: in STD_LOGIC; -- операция записи/чтения в регистр CSR1 (регистр разрешения и запуска процедуры шифрования)
     ctrl3: in STD_LOGIC; -- операция записи/чтения в регистр CSR3 (регистр сброса) 
	  RUN : out std_logic;
     start: out std_logic; -- запуск процедуры шифрования
	  fin : in std_logic; -- процедура шифрования завершена
	  CLR1: out std_logic; -- сброс по окончании процедуры шифрования
	  DO_CLR: out STD_LOGIC_VECTOR (m downto 0); -- выходные сигналы сброса разрядов регистра CSR (управления и состояния)  	  
     IRQ0 : out std_logic);
end component ctrlcomp;



signal CS1: std_logic; -- синхронный CS
signal CSR1: STD_LOGIC_VECTOR (1 downto 0); -- регистр CSR1 (регистр разрешения и запуска процедуры шифрования)
signal CSR3: STD_LOGIC_VECTOR (7 downto 0); -- регистр CSR3 (регистр сброса)
signal notoprd: STD_LOGIC; -- чтение
signal opwr: STD_LOGIC; -- запись
signal wrkey: STD_LOGIC; -- перед процедурой шифрования был записан ключ  
signal wrsync: STD_LOGIC; -- перед процедурой шифрования была записана синхропосылка
signal ctrl1: STD_LOGIC; -- обращение к регистру CSR1
signal ctrl3: STD_LOGIC; -- обращение к регистру CSR3
signal CLR: std_logic; -- общий сброс
signal CLR1: std_logic; --сброс по окончании процедуры шифрования 
signal CLR2: std_logic; -- общий сброс или сброс по окончании процедуры шифрования
signal RUN: std_logic;
signal DATA: STD_LOGIC_VECTOR(63 downto 0); -- 64 бит для шифрования
signal DO_RGK0: STD_LOGIC_VECTOR(495 downto 0); -- ключ
signal DO_RGI0: STD_LOGIC_VECTOR(63 downto 0); -- синхропосылка
signal DO_RGI_CR: STD_LOGIC_VECTOR(63 downto 0); -- 64 бит зашифрованых данных
signal DO_CLR: STD_LOGIC_VECTOR (6 downto 0); -- сброс внутренних счётчиков регистров
signal DO_CLRSIG: STD_LOGIC_VECTOR (7 downto 0);
signal start: STD_LOGIC; -- запуск процесса шифрования
signal fin: STD_LOGIC; -- процедура шифрования завершена



begin


CLR2<=DO_CLRSIG(0) or CLR1; -- общий сброс или сброс по окончании процедуры шифрования 



-- базовй модуль управления
ctrlc: ctrlcomp
generic map (m=>7)
port map (DI_RST=>CSR3(0), DI_CLR=>CSR3(7 downto 1), CSR1=>CSR1, CLK=>CLK, CS=>CS1, 
notoprd=>notoprd, opwr=>opwr, ctrl1=>ctrl1, 
ctrl3=>ctrl3, RUN=>RUN, start=>start, fin=>fin, CLR1=>CLR1, 
DO_CLR=>DO_CLRSIG, IRQ0=>IRQ0);


-- SPI-блок
spic: spis
generic map (n=>8)
port map (SPCK=>SPCK, CLK=>CLK, CLR=>CLR2, CS=>CS, MOSI=>MOSI, 
MISO=>MISO, CS1=>CS1, DO_CLR=>DO_CLR, DATA_OUT=>DATA, DATA_IN=>DO_RGI_CR, 
syncro=>DO_RGI0, key=>DO_RGK0, CSR1=>CSR1, CSR3=>CSR3, notoprd=>notoprd, 
opwr=>opwr, wrkey=>wrkey, wrsync=>wrsync, ctrl1=>ctrl1, 
ctrl3=>ctrl3, RUN=>RUN);


-- модуль шифрования
Cr8: Crypto7
port map (CLK=>CLK, CLR=>CLR2, start=>start, A=>DO_RGK0, 
DO_RGI0=>DO_RGI0, DATA_DI=>DATA, DO_RGI_CR=>DO_RGI_CR, wrkey=>wrkey, 
wrsync=>wrsync, fin=>fin);


-- формирование сигналов сброса внутренних счётчиков регистров управления и состояния
process (DO_CLRSIG, CLR1) 
begin
for i in 0 to 6
loop
DO_CLR(i)<=DO_CLRSIG(i+1) or CLR1;
end loop;
end process;

end archi;
