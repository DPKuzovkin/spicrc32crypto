

-- SPI-блок

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity spis is
generic(n: POSITIVE); -- размерность адресного пространства блока SPI
    port (SPCK : in std_logic; -- 2Mhz -- spi
	 		 CLK: in std_logic;	-- 100Mhz
			 CLR: in std_logic; -- общий сброс или сброс по окончании процедуры шифрования
			 CS: in std_logic;
	       MOSI: in STD_LOGIC;
			 MISO: out std_logic;
	       CS1: out std_logic; -- синхронный CS			 
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
end spis;

architecture archi of spis is

component shift_register is
generic(n: POSITIVE);
port(CLK, EN, MS_IN : in std_logic;
DO : out std_logic_vector(n-1 downto 0));
end component shift_register;

component shift_register3 is
generic(n: POSITIVE);
port(CLK, LOAD, EN : in std_logic;
DI : in std_logic_vector(n-1 downto 0);
SO : out std_logic);
end component shift_register3;

component shift_register3_const is
generic(n, m: POSITIVE);
port(CLK, LOAD, EN : in std_logic;
SO : out std_logic);
end component shift_register3_const;

component shift_register4 is
generic(n: POSITIVE);
port(CLK, EN, MS_IN : in std_logic;
DO : out std_logic_vector(n-1 downto 0));
end component shift_register4;

component muxn is
generic(gr: POSITIVE);
port(A : in std_logic_vector((2**gr)-1 downto 0);
S : in std_logic_vector(gr-1 downto 0);
MO : out std_logic);
end component muxn;

component demn is
generic(n: POSITIVE);
   port (
        AR: in STD_LOGIC_VECTOR(n-1 downto 0);
        OU: out STD_LOGIC_VECTOR(2**n-1 downto 0));
end component demn;

component demn3 is
generic(n : POSITIVE; -- input
        m: POSITIVE); -- output
   port (
        AR: in STD_LOGIC_VECTOR(n-1 downto 0);
        OU: out STD_LOGIC_VECTOR(m-1 downto 0));
end component demn3;

component counter is
generic(n: POSITIVE);
port(CLK, CLR, EN: in std_logic;
DO : out std_logic_vector(n-1 downto 0));
end component counter;

component DFF3 is
port (D, CLK : in std_logic;
Q : out std_logic := '0');
end component DFF3;

component VCC3 is
port (CLK, CLR : in std_logic;
Q : out std_logic := '0');
end component VCC3;


component DFFVCC is
port (CLK, CLR, EN : in std_logic;
Q : out std_logic := '0');
end component DFFVCC;


component nDFFVCC2 is
generic(n: POSITIVE);
port(CLK: in std_logic;
CLR : in std_logic_vector(n-1 downto 0); -- сброс флагов "загрузка регистров чтения уже была"
EN : in std_logic_vector(n-1 downto 0);
LOAD1 : in std_logic;
LOAD : out std_logic_vector(n-1 downto 0));
end component nDFFVCC2;


component st4 is
port(CLK: in std_logic;
     CLR: in std_logic;
	  fincnt: in std_logic; -- код операции и адрес регистра считаны
	  LOAD: out std_logic); -- загрузка содержимого регистра записи в регистр чтения
end component st4;

component st5 is
port(CLK: in std_logic;
     CS: in std_logic;
	  fincnt: in std_logic; -- очередные 8 бит чтения/записи по интерфейсу SPI "прошли"
	  CLR2: out std_logic;
	  EN: out std_logic); -- счёт тактов (один такт - 8 записаных/считаных бит) "основного" чтения/записи
end component st5;


component orN is
generic(n: POSITIVE);
   port (DI: in STD_LOGIC_VECTOR (n-1 downto 0);
         DO: out STD_LOGIC);
end component orN;

component andN is
generic(n: POSITIVE);
   port (DI: in STD_LOGIC_VECTOR (n-1 downto 0);
         DO: out STD_LOGIC);
end component andN;

component mux16 is
generic(n: POSITIVE);
port (
A, B : in std_logic_vector(n-1 downto 0);
S : in std_logic;
MO : out std_logic_vector(n-1 downto 0));
end component mux16;


component nfincnti is
generic(m: POSITIVE; -- количество счётчиков
        n: POSITIVE; -- размер одного счётчика
		  i: POSITIVE); -- блокировка счётчика после 2**i тактов CLK
port(CLK: in std_logic;
CLR : in std_logic_vector(m-1 downto 0); -- "внешний" сброс счётчиков
EN : in std_logic_vector(m-1 downto 0); -- "внешнее" разрешение счётчиков
EN1 : out std_logic_vector(m-1 downto 0); -- 2**i тактов CLK прошли (EN1 = 0)
NOTEN1 : out std_logic_vector(m-1 downto 0)); -- not(EN1);
--DO : out std_logic_vector(m*n-1 downto 0)); -- exper
end component nfincnti;



signal CLR2: STD_LOGIC; -- сброс счётчиков кода операции/адреса (первые 8 бит) и даннных (вторые 8 бит)
signal CSIG1: STD_LOGIC;
signal oprd: STD_LOGIC; -- чтение (0);
signal notoprdsig: STD_LOGIC; -- not(oprd)
signal opwrsig: STD_LOGIC; -- запись (1);
signal reg1: STD_LOGIC_VECTOR (63 downto 0); -- 64 бит данных для шифрования
signal RGKSIG: STD_LOGIC_VECTOR (511 downto 0); -- ключ
signal RGISIG: STD_LOGIC_VECTOR (63 downto 0); -- синхропосылка (RGI)
signal CSR1SIG: STD_LOGIC_VECTOR (1 downto 0); -- регистр управления и состояния (1)
signal CSRUN: STD_LOGIC_VECTOR (7 downto 0); -- регистр управления и состояния (1) (чтение)
signal CSR2: STD_LOGIC_VECTOR (7 downto 0); -- регистр управления и состояния (2) (заполненность ячеек)
signal OP_ADDR: STD_LOGIC_VECTOR (7 downto 0); -- код операции (чтение или запись) и адрес регистра
signal ADDRSIG: STD_LOGIC_VECTOR (3 downto 0); -- адрес регистра
signal DO1: STD_LOGIC_VECTOR (3 downto 0); -- счётчик записи кода операции и адреса
signal DO2: STD_LOGIC_VECTOR (3 downto 0); -- счётчик чтения/записи данных (8 бит)
signal LOAD1: STD_LOGIC; -- загрузка содержимого сдвигового регистра записи в соответствующий сдвиговый регистр чтения
signal LOAD: STD_LOGIC_VECTOR (3 downto 0); -- загрузка соответствующего сдвигового регистра чтения
signal LOAD8: STD_LOGIC_VECTOR (3 downto 0);
signal OU0: STD_LOGIC_VECTOR (n downto 0); -- дешифратор адреса (в т.ч. для диагностики ошибки адреса)
signal OU: STD_LOGIC_VECTOR (n-1 downto 0); -- дешифратор операции
signal OU1: STD_LOGIC_VECTOR (n-1 downto 0); -- дешифратор операции (чтение)
signal OU2: STD_LOGIC_VECTOR (n-1 downto 0); -- дешифратор операции (запись)
signal SO: STD_LOGIC_VECTOR (n-1 downto 0); -- шина чтения
signal EN: STD_LOGIC; -- счёт тактов (по 8 бит) "основного" чтения/записи из/в регистра сдвига
signal EN1: STD_LOGIC; -- чтение кода операции и адреса регистра
signal EN2: STD_LOGIC; -- основное чтение/запись (т.е. чтение/запись ПОСЛЕ чтения кода операции и адреса соответствующего регистра)
signal EN3: STD_LOGIC_VECTOR (n-1 downto 0);
signal EN33: STD_LOGIC_VECTOR (2 downto 0);
signal EN4: STD_LOGIC_VECTOR (n-1 downto 0);
signal EN44: STD_LOGIC_VECTOR (3 downto 0);
signal EN5: STD_LOGIC_VECTOR (6 downto 0);
signal EN8 : std_logic_vector(4 downto 0); -- 8 тактов чтения/записи (по 8 бит) прошли (EN1 = 0) --  64 бит данных для шифрования (чтение и запись), 64 бит зашифрованных данных (чтение), 64 бит синхропосылки (RGI) (чтение и запись);
signal EN9 : std_logic_vector(1 downto 0); -- 64 такта чтения/записи ключа (по 8 бит) прошли (EN1 = 0) -- 512 бит ключа (чтение и запись);
signal EN11: std_logic; -- "индикатор" записи ключа перед шифрованием
signal EN22: std_logic; -- "индикатор" записи синхропосылки перед шифрованием
signal fincnt1: STD_LOGIC; --  код операции и адрес регистра считаны
signal fincnt2: STD_LOGIC; -- очередные 8 бит чтения/записи по интерфейсу spi "прошли"
signal fincnt3 : std_logic_vector(4 downto 0); -- not(EN8);
signal fincnt4 : std_logic_vector(1 downto 0); -- not(EN9);
signal MISO2: STD_LOGIC;
signal errop: STD_LOGIC; -- ошибка операции (чтение/запись)
signal erraddr: STD_LOGIC; -- ошибка адреса
signal err: STD_LOGIC; -- errop or erraddr;
signal ctrlsig1: STD_LOGIC; -- операция записи/чтения в регистр CSR1
signal ctrlsig3: STD_LOGIC; -- операция записи/чтения в регистр CSR3
signal ctrl: STD_LOGIC; -- операция записи/чтения в регистр CSR1/CSR3
signal pulsig: STD_LOGIC; -- импульс чтения/записи (два такта)
signal wrkey0: STD_LOGIC;
signal wrsync0: STD_LOGIC;
signal wrkey2: STD_LOGIC;
signal wrsync2: STD_LOGIC;
signal wrkeysig: STD_LOGIC;
signal wrsyncsig: STD_LOGIC;

	  
begin


CS1<=CSIG1;
notoprdsig<=not(oprd); -- если все нули,- операция чтения
opwr<=opwrsig;
notoprd<=notoprdsig;
ADDRSIG<=OP_ADDR(3 downto 0); -- адрес регистра

fincnt1<=DO1(3);


DATA_OUT<=reg1;
key<=RGKSIG(495 downto 0);
syncro<=RGISIG;
ctrlsig1<=OU(4);
ctrlsig3<=OU(6);
ctrl1<=ctrlsig1;
ctrl3<=ctrlsig3;
wrkey0<=opwrsig and OU(2);
wrsync0<=opwrsig and OU(3);
wrkey2 <= wrkey0 and not(wrkeysig);
wrsync2 <= wrsync0 and not(wrsyncsig);
wrkey<=wrkeysig;
wrsync<=wrsyncsig;

CSR1<=CSR1SIG;
CSRUN(0)<=RUN;
CSRUN(1)<=CSR1SIG(1);
CSRUN(7 downto 2)<=(others => '0');

CSR2(0)<=fincnt3(0);
CSR2(1)<=fincnt3(1);
CSR2(2)<=fincnt3(2);
CSR2(3)<=fincnt4(0);
CSR2(4)<=fincnt4(1);
CSR2(5)<=fincnt3(3);
CSR2(6)<=fincnt3(4);
CSR2(7)<='0';


EN5(0) <= OU2(0) and EN; -- запись данных (для шифрования)
EN5(1) <= OU1(0) and EN; -- чтение данных (для шифрования)
EN5(2) <= OU1(1) and EN; -- чтение данных (зашифрованных)
EN5(3) <= OU2(3) and EN; -- запись синхропосылки
EN5(4) <= OU1(3) and EN; -- чтение синхропосылки
EN5(5) <= OU2(2) and EN; -- запись ключа
EN5(6) <= OU1(2) and EN; -- чтение ключа


-- запись в регистры (64 бит для шифрования, 
-- 512 бит ключа, 64 бит синхропосылки)
EN33(0)<=EN3(0) and EN8(0); -- запись 64 бит для шифрования
EN33(1)<=EN3(2) and EN9(0); -- запись 512 бит ключа
EN33(2)<=EN3(3) and EN8(3); -- запись 64 бит синхропосылки

-- чтение из регистров (64 бит для шифрования, 64 бит зашифрованых 
-- данных, 512 бит ключа, 64 бит синхропосылки)
EN44(0)<=EN4(0) and EN8(1); -- чтение 64 бит для шифрования
EN44(1)<=EN4(1) and EN8(2); -- чтение 64 бит зашифрованных данных
EN44(2)<=EN4(2) and EN9(1); -- чтение 512 бит ключа
EN44(3)<=EN4(3) and EN8(4); -- чтение 64 бит синхропосылки



dem1: demn3
generic map (n=>4, m=>n)
port map (AR=>ADDRSIG, OU=>OU);


orc1: orN
generic map (n=>4)
port map (DI=>OP_ADDR(7 downto 4), DO=>oprd);  -- если все нули,- операция чтения


andc: andN
generic map (n=>4)
port map (DI=>OP_ADDR(7 downto 4), DO=>opwrsig);  -- если все единицы,- операция записи


dffc1: dff3
port map (D=>CS, CLK=>CLK, Q=>CSIG1);


-- загрузка соответствующего сдвигового регистра чтения
stc1: st4
port map (CLK=>SPCK, CLR=>CS, fincnt=>fincnt1, LOAD=>LOAD1);


-- чтение/запись очередных 8 бит в ячейку (сдвиговой регистр)
stc2: st5
port map (CLK=>CLK, CS=>CSIG1, CLR2=>CLR2, EN=>EN, fincnt=>fincnt2);


dffc2: DFFVCC
port map (CLK=>CS, CLR=>CLR, EN=>wrkey2, Q=>wrkeysig);


dffc3: DFFVCC
port map (CLK=>CS, CLR=>CLR, EN=>wrsync2, Q=>wrsyncsig);


-- данные для чтения уже были загружены в регистр чтения
-- чтение данных для шифрования (64 бита), чтение зашифрованых данных (64 бита),
-- чтение ключа (512 бит), чтение синхропосылки (64 бита);
dffc4: nDFFVCC2
generic map (n=>4)
port map (CLK=>SPCK, CLR(0)=>DO_CLR(1), CLR(1)=>DO_CLR(2), 
CLR(2)=>DO_CLR(4), CLR(3)=>DO_CLR(6), EN=>OU1(3 downto 0), 
LOAD1=>LOAD1, LOAD=>LOAD);


dffc5: dff3
port map (D=>DO2(3), CLK=>CLK, Q=>fincnt2);


-- счётчик чтения кода операции и адреса регистра (первые 8 бит)
cnt1: counter
generic map (n=>4)
port map (CLK=>SPCK, EN=>EN1, CLR=>CLR2, DO=>DO1);


-- счётчик чтения/записи данных (вторые 8 бит)
cnt2: counter
generic map (n=>4)
port map (CLK=>SPCK, EN=>EN2, CLR=>CLR2, DO=>DO2);



-- запись кода операции и адреса соответствующего регистра
-- n-bit Shift-Left Register with Positive-Edge Clock, Clock Enable
-- Serial In, and Parallel Out
sh1: shift_register4
generic map (n=>8)
port map (CLK=>SPCK, EN=>EN1, MS_IN=>MOSI, DO=>OP_ADDR);



-- блокировщик счёта 5 счётчиков после 8 тактов (по 8 бит) записи или чтения:
 --  64 бит данных для шифрования (запись и чтение), 64 бит зашифрованных 
 -- данных (чтение), 64 бит синхропосылки (запись и чтение);
  -- (8 тактов чтения/записи (по 8 бит) прошли (EN1 = 0));
nfc1: nfincnti
generic map (m=>5, n=>4, i=>3)
port map (CLK=>CLK, CLR(2 downto 0)=>DO_CLR(2 downto 0), 
CLR(4 downto 3)=>DO_CLR(6 downto 5), 
EN=>EN5(4 downto 0), EN1=>EN8, NOTEN1=>fincnt3);



-- блокировщик счёта 2 счётчиков после 64 тактов (по 8 бит) чтения/записи:
 --  512 бит ключа (запись и чтение);
  -- (64 такта чтения/записи (по 8 бит) прошли (EN1 = 0)); 
nfc2: nfincnti
generic map (m=>2, n=>7, i=>6)
port map (CLK=>CLK, CLR=>DO_CLR(4 downto 3), 
EN=>EN5(6 downto 5), EN1=>EN9, NOTEN1=>fincnt4);


-- запись 64 бит данных для шифрования
-- n-bit Shift-Left Register with Positive-Edge Clock, Clock Enable
-- Serial In, and Parallel Out
sh2: shift_register4
generic map (n=>64)
port map (CLK=>SPCK, EN=>EN33(0), MS_IN=>MOSI, DO=>reg1);


-- запись ключа (RGK)
sh3: shift_register4
generic map (n=>512)
port map (CLK=>SPCK, EN=>EN33(1), MS_IN=>MOSI, DO=>RGKSIG);


-- запись синхропосылки (RGI)
sh4: shift_register4
generic map (n=>64)
port map (CLK=>SPCK, EN=>EN33(2), MS_IN=>MOSI, DO=>RGISIG);


-- запись регистра управления и состояния CSR1
sh5: shift_register4
generic map (n=>2)
port map (CLK=>SPCK, EN=>EN3(4), MS_IN=>MOSI, DO=>CSR1SIG);


-- запись регистра управления и состояния CSR3
-- (регистр сброса)
sh7: shift_register4
generic map (n=>8)
port map (CLK=>SPCK, EN=>EN3(6), MS_IN=>MOSI, DO=>CSR3);


-- чтение 64 бит данных для шифрования
sh8: shift_register3
generic map (n=>64)
port map (CLK=>SPCK, LOAD=>LOAD(0), EN=>EN44(0), DI=>reg1, SO=>SO(0));

-- чтение 64 бит зашифрованых данных
sh9: shift_register3
generic map (n=>64)
port map (CLK=>SPCK, LOAD=>LOAD(1), EN=>EN44(1), DI=>DATA_IN, SO=>SO(1));

-- чтение ключа
sh10: shift_register3
generic map (n=>512)
port map (CLK=>SPCK, LOAD=>LOAD(2), EN=>EN44(2), DI=>RGKSIG, SO=>SO(2));

-- чтение синхропосылки (RGI)
sh11: shift_register3
generic map (n=>64)
port map (CLK=>SPCK, LOAD=>LOAD(3), EN=>EN44(3), DI=>RGISIG, SO=>SO(3));


-- чтение регистра управления и состояния CSR1
sh12: shift_register3
generic map (n=>8)
port map (CLK=>SPCK, LOAD=>LOAD8(0), EN=>EN4(4), DI=>CSRUN, SO=>SO(4));

-- чтение регистра управления и состояния CSR2
-- (заполненность ячеек)
sh13: shift_register3
generic map (n=>8)
port map (CLK=>SPCK, LOAD=>LOAD8(1), EN=>EN4(5), DI=>CSR2, SO=>SO(5));

-- чтение регистра управления и состояния CSR3
--sh13: shift_register3
--generic map (n=>8)
--port map (CLK=>SPCK, LOAD=>LOAD(6), EN=>EN4(6), DI=>reg6, SO=>SO(6));


-- чтение регистра идентификации
sh14: shift_register3_const
generic map (n=>8, m=>123)
port map (CLK=>SPCK, LOAD=>LOAD8(3), EN=>EN4(7), SO=>SO(7));


-- выбор сдвигового регистра (согласно адреса) для чтения по spi
mux1: muxn
generic map (gr=>3)
port map (A(7)=>SO(7), A(6)=>'0', A(5 downto 0)=>SO(5 downto 0), 
S=>OP_ADDR(2 downto 0), MO=>MISO);



-- "основное" чтение
process (OU, notoprdsig) 
begin
for i in 0 to 7
loop
OU1(i) <= OU(i) and notoprdsig;
end loop;
end process;

-- загрузка соответствующего сдвигового регистра "основного" чтения
process (OU1, LOAD1) 
begin
for i in 4 to 7
loop
LOAD8(i-4) <= OU1(i) and LOAD1;
end loop;
end process;

-- "основная" запись
process (OU, opwrsig) 
begin
for i in 0 to 7
loop
OU2(i) <= OU(i) and opwrsig;
end loop;
end process;

-- "основная" запись в регистр сдвига
process (OU2, EN2) 
begin
for i in 0 to 7
loop
EN3(i)<=OU2(i) and EN2;
end loop;
end process;

-- "основное" чтение из регистра сдвига
process (OU1, EN2) 
begin
for i in 0 to 7
loop
EN4(i)<=OU1(i) and EN2;
end loop;
end process;



process (DO1(3), DO2(3), CS)
begin
if (CS = '1') then -- 21 -- цикла обращения по шине SPI нету
EN1<='0';
EN2<='0';
else -- (CS = '0') -- цикл обращения по шине SPI
if (DO1(3) = '1') then -- 22 -- код операции (чтение/запись) и адрес регистра считаны
if (DO2(3) = '1') then -- 23 -- очередные 8 бит чтения/записи считаны/записаны
EN2<='0';
else -- (DO2(3) = '0') -- чтение/запись 8 бит по соответствующему адресу (код операции и адрес регистра считаны)
EN2<='1'; -- чтение/запись 8 бит по соответствующему адресу
end if; -- 23
EN1<='0';
else -- (DO1(3) = '0') -- код операции (чтение или запись) и адрес регистра не считаны
EN1<='1'; -- чтение кода операции (чтение/запись) и адреса регистра
EN2<='0';
end if; -- 22
end if; -- 21
end process;


end archi;
