

-- SPI-����

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity spis is
generic(n: POSITIVE); -- ����������� ��������� ������������ ����� SPI
    port (SPCK : in std_logic; -- 2Mhz -- spi
	 		 CLK: in std_logic;	-- 100Mhz
			 CLR: in std_logic; -- ����� ����� ��� ����� �� ��������� ��������� ����������
			 CS: in std_logic;
	       MOSI: in STD_LOGIC;
			 MISO: out std_logic;
	       CS1: out std_logic; -- ���������� CS			 
			 DO_CLR: in std_logic_vector(6 downto 0); -- ����� ���������� ��������� ���������			 
			 DATA_OUT: out std_logic_vector(63 downto 0); -- 64 ��� ��� ����������
			 DATA_IN: in std_logic_vector(63 downto 0); -- ������������� 64 ���
			 syncro: out std_logic_vector(63 downto 0); -- �������������
			 key: out std_logic_vector(495 downto 0); -- ����
			 CSR1: out STD_LOGIC_VECTOR (1 downto 0); -- ������� CSR1 (������� ���������� � ������� ��������� ����������)
			 CSR3: out STD_LOGIC_VECTOR (7 downto 0); -- ������� CSR3 (������� ������)
			 notoprd: out STD_LOGIC; -- ������
          opwr: out STD_LOGIC; 
			 wrkey: out STD_LOGIC; -- ����� ���������� ���������� ��� ������� ����  
          wrsync: out STD_LOGIC; -- ����� ���������� ���������� ���� �������� �������������
			 ctrl1: out STD_LOGIC; -- �������� ������/������ � ������� CSR1
          ctrl3: out STD_LOGIC; -- �������� ������ � ������� CSR3
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
CLR : in std_logic_vector(n-1 downto 0); -- ����� ������ "�������� ��������� ������ ��� ����"
EN : in std_logic_vector(n-1 downto 0);
LOAD1 : in std_logic;
LOAD : out std_logic_vector(n-1 downto 0));
end component nDFFVCC2;


component st4 is
port(CLK: in std_logic;
     CLR: in std_logic;
	  fincnt: in std_logic; -- ��� �������� � ����� �������� �������
	  LOAD: out std_logic); -- �������� ����������� �������� ������ � ������� ������
end component st4;

component st5 is
port(CLK: in std_logic;
     CS: in std_logic;
	  fincnt: in std_logic; -- ��������� 8 ��� ������/������ �� ���������� SPI "������"
	  CLR2: out std_logic;
	  EN: out std_logic); -- ���� ������ (���� ���� - 8 ���������/�������� ���) "���������" ������/������
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
generic(m: POSITIVE; -- ���������� ���������
        n: POSITIVE; -- ������ ������ ��������
		  i: POSITIVE); -- ���������� �������� ����� 2**i ������ CLK
port(CLK: in std_logic;
CLR : in std_logic_vector(m-1 downto 0); -- "�������" ����� ���������
EN : in std_logic_vector(m-1 downto 0); -- "�������" ���������� ���������
EN1 : out std_logic_vector(m-1 downto 0); -- 2**i ������ CLK ������ (EN1 = 0)
NOTEN1 : out std_logic_vector(m-1 downto 0)); -- not(EN1);
--DO : out std_logic_vector(m*n-1 downto 0)); -- exper
end component nfincnti;



signal CLR2: STD_LOGIC; -- ����� ��������� ���� ��������/������ (������ 8 ���) � ������� (������ 8 ���)
signal CSIG1: STD_LOGIC;
signal oprd: STD_LOGIC; -- ������ (0);
signal notoprdsig: STD_LOGIC; -- not(oprd)
signal opwrsig: STD_LOGIC; -- ������ (1);
signal reg1: STD_LOGIC_VECTOR (63 downto 0); -- 64 ��� ������ ��� ����������
signal RGKSIG: STD_LOGIC_VECTOR (511 downto 0); -- ����
signal RGISIG: STD_LOGIC_VECTOR (63 downto 0); -- ������������� (RGI)
signal CSR1SIG: STD_LOGIC_VECTOR (1 downto 0); -- ������� ���������� � ��������� (1)
signal CSRUN: STD_LOGIC_VECTOR (7 downto 0); -- ������� ���������� � ��������� (1) (������)
signal CSR2: STD_LOGIC_VECTOR (7 downto 0); -- ������� ���������� � ��������� (2) (������������� �����)
signal OP_ADDR: STD_LOGIC_VECTOR (7 downto 0); -- ��� �������� (������ ��� ������) � ����� ��������
signal ADDRSIG: STD_LOGIC_VECTOR (3 downto 0); -- ����� ��������
signal DO1: STD_LOGIC_VECTOR (3 downto 0); -- ������� ������ ���� �������� � ������
signal DO2: STD_LOGIC_VECTOR (3 downto 0); -- ������� ������/������ ������ (8 ���)
signal LOAD1: STD_LOGIC; -- �������� ����������� ���������� �������� ������ � ��������������� ��������� ������� ������
signal LOAD: STD_LOGIC_VECTOR (3 downto 0); -- �������� ���������������� ���������� �������� ������
signal LOAD8: STD_LOGIC_VECTOR (3 downto 0);
signal OU0: STD_LOGIC_VECTOR (n downto 0); -- ���������� ������ (� �.�. ��� ����������� ������ ������)
signal OU: STD_LOGIC_VECTOR (n-1 downto 0); -- ���������� ��������
signal OU1: STD_LOGIC_VECTOR (n-1 downto 0); -- ���������� �������� (������)
signal OU2: STD_LOGIC_VECTOR (n-1 downto 0); -- ���������� �������� (������)
signal SO: STD_LOGIC_VECTOR (n-1 downto 0); -- ���� ������
signal EN: STD_LOGIC; -- ���� ������ (�� 8 ���) "���������" ������/������ ��/� �������� ������
signal EN1: STD_LOGIC; -- ������ ���� �������� � ������ ��������
signal EN2: STD_LOGIC; -- �������� ������/������ (�.�. ������/������ ����� ������ ���� �������� � ������ ���������������� ��������)
signal EN3: STD_LOGIC_VECTOR (n-1 downto 0);
signal EN33: STD_LOGIC_VECTOR (2 downto 0);
signal EN4: STD_LOGIC_VECTOR (n-1 downto 0);
signal EN44: STD_LOGIC_VECTOR (3 downto 0);
signal EN5: STD_LOGIC_VECTOR (6 downto 0);
signal EN8 : std_logic_vector(4 downto 0); -- 8 ������ ������/������ (�� 8 ���) ������ (EN1 = 0) --  64 ��� ������ ��� ���������� (������ � ������), 64 ��� ������������� ������ (������), 64 ��� ������������� (RGI) (������ � ������);
signal EN9 : std_logic_vector(1 downto 0); -- 64 ����� ������/������ ����� (�� 8 ���) ������ (EN1 = 0) -- 512 ��� ����� (������ � ������);
signal EN11: std_logic; -- "���������" ������ ����� ����� �����������
signal EN22: std_logic; -- "���������" ������ ������������� ����� �����������
signal fincnt1: STD_LOGIC; --  ��� �������� � ����� �������� �������
signal fincnt2: STD_LOGIC; -- ��������� 8 ��� ������/������ �� ���������� spi "������"
signal fincnt3 : std_logic_vector(4 downto 0); -- not(EN8);
signal fincnt4 : std_logic_vector(1 downto 0); -- not(EN9);
signal MISO2: STD_LOGIC;
signal errop: STD_LOGIC; -- ������ �������� (������/������)
signal erraddr: STD_LOGIC; -- ������ ������
signal err: STD_LOGIC; -- errop or erraddr;
signal ctrlsig1: STD_LOGIC; -- �������� ������/������ � ������� CSR1
signal ctrlsig3: STD_LOGIC; -- �������� ������/������ � ������� CSR3
signal ctrl: STD_LOGIC; -- �������� ������/������ � ������� CSR1/CSR3
signal pulsig: STD_LOGIC; -- ������� ������/������ (��� �����)
signal wrkey0: STD_LOGIC;
signal wrsync0: STD_LOGIC;
signal wrkey2: STD_LOGIC;
signal wrsync2: STD_LOGIC;
signal wrkeysig: STD_LOGIC;
signal wrsyncsig: STD_LOGIC;

	  
begin


CS1<=CSIG1;
notoprdsig<=not(oprd); -- ���� ��� ����,- �������� ������
opwr<=opwrsig;
notoprd<=notoprdsig;
ADDRSIG<=OP_ADDR(3 downto 0); -- ����� ��������

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


EN5(0) <= OU2(0) and EN; -- ������ ������ (��� ����������)
EN5(1) <= OU1(0) and EN; -- ������ ������ (��� ����������)
EN5(2) <= OU1(1) and EN; -- ������ ������ (�������������)
EN5(3) <= OU2(3) and EN; -- ������ �������������
EN5(4) <= OU1(3) and EN; -- ������ �������������
EN5(5) <= OU2(2) and EN; -- ������ �����
EN5(6) <= OU1(2) and EN; -- ������ �����


-- ������ � �������� (64 ��� ��� ����������, 
-- 512 ��� �����, 64 ��� �������������)
EN33(0)<=EN3(0) and EN8(0); -- ������ 64 ��� ��� ����������
EN33(1)<=EN3(2) and EN9(0); -- ������ 512 ��� �����
EN33(2)<=EN3(3) and EN8(3); -- ������ 64 ��� �������������

-- ������ �� ��������� (64 ��� ��� ����������, 64 ��� ������������ 
-- ������, 512 ��� �����, 64 ��� �������������)
EN44(0)<=EN4(0) and EN8(1); -- ������ 64 ��� ��� ����������
EN44(1)<=EN4(1) and EN8(2); -- ������ 64 ��� ������������� ������
EN44(2)<=EN4(2) and EN9(1); -- ������ 512 ��� �����
EN44(3)<=EN4(3) and EN8(4); -- ������ 64 ��� �������������



dem1: demn3
generic map (n=>4, m=>n)
port map (AR=>ADDRSIG, OU=>OU);


orc1: orN
generic map (n=>4)
port map (DI=>OP_ADDR(7 downto 4), DO=>oprd);  -- ���� ��� ����,- �������� ������


andc: andN
generic map (n=>4)
port map (DI=>OP_ADDR(7 downto 4), DO=>opwrsig);  -- ���� ��� �������,- �������� ������


dffc1: dff3
port map (D=>CS, CLK=>CLK, Q=>CSIG1);


-- �������� ���������������� ���������� �������� ������
stc1: st4
port map (CLK=>SPCK, CLR=>CS, fincnt=>fincnt1, LOAD=>LOAD1);


-- ������/������ ��������� 8 ��� � ������ (��������� �������)
stc2: st5
port map (CLK=>CLK, CS=>CSIG1, CLR2=>CLR2, EN=>EN, fincnt=>fincnt2);


dffc2: DFFVCC
port map (CLK=>CS, CLR=>CLR, EN=>wrkey2, Q=>wrkeysig);


dffc3: DFFVCC
port map (CLK=>CS, CLR=>CLR, EN=>wrsync2, Q=>wrsyncsig);


-- ������ ��� ������ ��� ���� ��������� � ������� ������
-- ������ ������ ��� ���������� (64 ����), ������ ������������ ������ (64 ����),
-- ������ ����� (512 ���), ������ ������������� (64 ����);
dffc4: nDFFVCC2
generic map (n=>4)
port map (CLK=>SPCK, CLR(0)=>DO_CLR(1), CLR(1)=>DO_CLR(2), 
CLR(2)=>DO_CLR(4), CLR(3)=>DO_CLR(6), EN=>OU1(3 downto 0), 
LOAD1=>LOAD1, LOAD=>LOAD);


dffc5: dff3
port map (D=>DO2(3), CLK=>CLK, Q=>fincnt2);


-- ������� ������ ���� �������� � ������ �������� (������ 8 ���)
cnt1: counter
generic map (n=>4)
port map (CLK=>SPCK, EN=>EN1, CLR=>CLR2, DO=>DO1);


-- ������� ������/������ ������ (������ 8 ���)
cnt2: counter
generic map (n=>4)
port map (CLK=>SPCK, EN=>EN2, CLR=>CLR2, DO=>DO2);



-- ������ ���� �������� � ������ ���������������� ��������
-- n-bit Shift-Left Register with Positive-Edge Clock, Clock Enable
-- Serial In, and Parallel Out
sh1: shift_register4
generic map (n=>8)
port map (CLK=>SPCK, EN=>EN1, MS_IN=>MOSI, DO=>OP_ADDR);



-- ����������� ����� 5 ��������� ����� 8 ������ (�� 8 ���) ������ ��� ������:
 --  64 ��� ������ ��� ���������� (������ � ������), 64 ��� ������������� 
 -- ������ (������), 64 ��� ������������� (������ � ������);
  -- (8 ������ ������/������ (�� 8 ���) ������ (EN1 = 0));
nfc1: nfincnti
generic map (m=>5, n=>4, i=>3)
port map (CLK=>CLK, CLR(2 downto 0)=>DO_CLR(2 downto 0), 
CLR(4 downto 3)=>DO_CLR(6 downto 5), 
EN=>EN5(4 downto 0), EN1=>EN8, NOTEN1=>fincnt3);



-- ����������� ����� 2 ��������� ����� 64 ������ (�� 8 ���) ������/������:
 --  512 ��� ����� (������ � ������);
  -- (64 ����� ������/������ (�� 8 ���) ������ (EN1 = 0)); 
nfc2: nfincnti
generic map (m=>2, n=>7, i=>6)
port map (CLK=>CLK, CLR=>DO_CLR(4 downto 3), 
EN=>EN5(6 downto 5), EN1=>EN9, NOTEN1=>fincnt4);


-- ������ 64 ��� ������ ��� ����������
-- n-bit Shift-Left Register with Positive-Edge Clock, Clock Enable
-- Serial In, and Parallel Out
sh2: shift_register4
generic map (n=>64)
port map (CLK=>SPCK, EN=>EN33(0), MS_IN=>MOSI, DO=>reg1);


-- ������ ����� (RGK)
sh3: shift_register4
generic map (n=>512)
port map (CLK=>SPCK, EN=>EN33(1), MS_IN=>MOSI, DO=>RGKSIG);


-- ������ ������������� (RGI)
sh4: shift_register4
generic map (n=>64)
port map (CLK=>SPCK, EN=>EN33(2), MS_IN=>MOSI, DO=>RGISIG);


-- ������ �������� ���������� � ��������� CSR1
sh5: shift_register4
generic map (n=>2)
port map (CLK=>SPCK, EN=>EN3(4), MS_IN=>MOSI, DO=>CSR1SIG);


-- ������ �������� ���������� � ��������� CSR3
-- (������� ������)
sh7: shift_register4
generic map (n=>8)
port map (CLK=>SPCK, EN=>EN3(6), MS_IN=>MOSI, DO=>CSR3);


-- ������ 64 ��� ������ ��� ����������
sh8: shift_register3
generic map (n=>64)
port map (CLK=>SPCK, LOAD=>LOAD(0), EN=>EN44(0), DI=>reg1, SO=>SO(0));

-- ������ 64 ��� ������������ ������
sh9: shift_register3
generic map (n=>64)
port map (CLK=>SPCK, LOAD=>LOAD(1), EN=>EN44(1), DI=>DATA_IN, SO=>SO(1));

-- ������ �����
sh10: shift_register3
generic map (n=>512)
port map (CLK=>SPCK, LOAD=>LOAD(2), EN=>EN44(2), DI=>RGKSIG, SO=>SO(2));

-- ������ ������������� (RGI)
sh11: shift_register3
generic map (n=>64)
port map (CLK=>SPCK, LOAD=>LOAD(3), EN=>EN44(3), DI=>RGISIG, SO=>SO(3));


-- ������ �������� ���������� � ��������� CSR1
sh12: shift_register3
generic map (n=>8)
port map (CLK=>SPCK, LOAD=>LOAD8(0), EN=>EN4(4), DI=>CSRUN, SO=>SO(4));

-- ������ �������� ���������� � ��������� CSR2
-- (������������� �����)
sh13: shift_register3
generic map (n=>8)
port map (CLK=>SPCK, LOAD=>LOAD8(1), EN=>EN4(5), DI=>CSR2, SO=>SO(5));

-- ������ �������� ���������� � ��������� CSR3
--sh13: shift_register3
--generic map (n=>8)
--port map (CLK=>SPCK, LOAD=>LOAD(6), EN=>EN4(6), DI=>reg6, SO=>SO(6));


-- ������ �������� �������������
sh14: shift_register3_const
generic map (n=>8, m=>123)
port map (CLK=>SPCK, LOAD=>LOAD8(3), EN=>EN4(7), SO=>SO(7));


-- ����� ���������� �������� (�������� ������) ��� ������ �� spi
mux1: muxn
generic map (gr=>3)
port map (A(7)=>SO(7), A(6)=>'0', A(5 downto 0)=>SO(5 downto 0), 
S=>OP_ADDR(2 downto 0), MO=>MISO);



-- "��������" ������
process (OU, notoprdsig) 
begin
for i in 0 to 7
loop
OU1(i) <= OU(i) and notoprdsig;
end loop;
end process;

-- �������� ���������������� ���������� �������� "���������" ������
process (OU1, LOAD1) 
begin
for i in 4 to 7
loop
LOAD8(i-4) <= OU1(i) and LOAD1;
end loop;
end process;

-- "��������" ������
process (OU, opwrsig) 
begin
for i in 0 to 7
loop
OU2(i) <= OU(i) and opwrsig;
end loop;
end process;

-- "��������" ������ � ������� ������
process (OU2, EN2) 
begin
for i in 0 to 7
loop
EN3(i)<=OU2(i) and EN2;
end loop;
end process;

-- "��������" ������ �� �������� ������
process (OU1, EN2) 
begin
for i in 0 to 7
loop
EN4(i)<=OU1(i) and EN2;
end loop;
end process;



process (DO1(3), DO2(3), CS)
begin
if (CS = '1') then -- 21 -- ����� ��������� �� ���� SPI ����
EN1<='0';
EN2<='0';
else -- (CS = '0') -- ���� ��������� �� ���� SPI
if (DO1(3) = '1') then -- 22 -- ��� �������� (������/������) � ����� �������� �������
if (DO2(3) = '1') then -- 23 -- ��������� 8 ��� ������/������ �������/��������
EN2<='0';
else -- (DO2(3) = '0') -- ������/������ 8 ��� �� ���������������� ������ (��� �������� � ����� �������� �������)
EN2<='1'; -- ������/������ 8 ��� �� ���������������� ������
end if; -- 23
EN1<='0';
else -- (DO1(3) = '0') -- ��� �������� (������ ��� ������) � ����� �������� �� �������
EN1<='1'; -- ������ ���� �������� (������/������) � ������ ��������
EN2<='0';
end if; -- 22
end if; -- 21
end process;


end archi;
