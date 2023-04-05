

-- VHDL-�������� ������ �������� ���������� 64-��� ������.

-- ���������� ����� 64-������� ������������ ����� � 32-������� �������������� 
-- �� ��������� ���������.

-- ����� ������� ����� ������� ������������ ����� � ������� ���������� ���������� �� ���������� SPI.


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
			 IRQ0: out STD_LOGIC); -- ������ ���������� (��� ���������� ��������� ���������� ���������) 
end crypto;

architecture archi of crypto is

component spis is
generic(n: POSITIVE); -- ����������� ��������� ������������ ����� SPI
    port (SPCK : in std_logic; -- 2Mhz -- spi
	 		 CLK: in std_logic;	-- 100Mhz
			 CLR: in std_logic; -- ����� ����� ��� ����� �� ��������� ��������� ����������
			 CS: in std_logic;
	       MOSI: in STD_LOGIC;
			 MISO: out std_logic;
	       CS1: out std_logic; -- ������������� CS			 
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
end component spis;

-- ������ ����������
component Crypto7 is
port (CLK: in STD_LOGIC;
		CLR: in STD_LOGIC; 
		start: in std_logic; -- ������ ���������� 64-������ ������ ������	
      A: in std_logic_vector(495 downto 0); -- 512-������ ����
		DO_RGI0: in STD_LOGIC_VECTOR(63 downto 0); -- �������������
		DATA_DI: in STD_LOGIC_VECTOR(63 downto 0); -- ������ ��� ����������	
		DO_RGI_CR: out STD_LOGIC_VECTOR(63 downto 0); -- ������ ������������� ������ (�������� �������)(64 ���)
		wrkey: in std_logic; -- ����� ���������� ���������� ��� ������� ����� ����
	   wrsync: in std_logic; -- ����� ���������� ���������� ���� �������� ����� �������������
		fin: out STD_LOGIC); -- ��������� ���������� ���������
end component Crypto7;

-- ������� ������ ����������
component ctrlcomp is
generic(m: POSITIVE); -- ����� ��������� ������ (�� ������ �������� ������ ������) (m = 7)
port(DI_RST: in std_logic; -- ����� �����
     DI_CLR: in STD_LOGIC_VECTOR (m-1 downto 0); -- ������� ������ �������� �������� CSR (�� ������ �������� ������ ������)  
	  CSR1: in STD_LOGIC_VECTOR (1 downto 0); -- ������� CSR1 (������� ���������� � ������� ��������� ����������)
     CLK: in std_logic;
     CS: in std_logic; -- ���������� CS
	  notoprd: in STD_LOGIC; -- ������
     opwr: in STD_LOGIC; -- ������
	  ctrl1: in STD_LOGIC; -- �������� ������/������ � ������� CSR1 (������� ���������� � ������� ��������� ����������)
     ctrl3: in STD_LOGIC; -- �������� ������/������ � ������� CSR3 (������� ������) 
	  RUN : out std_logic;
     start: out std_logic; -- ������ ��������� ����������
	  fin : in std_logic; -- ��������� ���������� ���������
	  CLR1: out std_logic; -- ����� �� ��������� ��������� ����������
	  DO_CLR: out STD_LOGIC_VECTOR (m downto 0); -- �������� ������� ������ �������� �������� CSR (���������� � ���������)  	  
     IRQ0 : out std_logic);
end component ctrlcomp;



signal CS1: std_logic; -- ���������� CS
signal CSR1: STD_LOGIC_VECTOR (1 downto 0); -- ������� CSR1 (������� ���������� � ������� ��������� ����������)
signal CSR3: STD_LOGIC_VECTOR (7 downto 0); -- ������� CSR3 (������� ������)
signal notoprd: STD_LOGIC; -- ������
signal opwr: STD_LOGIC; -- ������
signal wrkey: STD_LOGIC; -- ����� ���������� ���������� ��� ������� ����  
signal wrsync: STD_LOGIC; -- ����� ���������� ���������� ���� �������� �������������
signal ctrl1: STD_LOGIC; -- ��������� � �������� CSR1
signal ctrl3: STD_LOGIC; -- ��������� � �������� CSR3
signal CLR: std_logic; -- ����� �����
signal CLR1: std_logic; --����� �� ��������� ��������� ���������� 
signal CLR2: std_logic; -- ����� ����� ��� ����� �� ��������� ��������� ����������
signal RUN: std_logic;
signal DATA: STD_LOGIC_VECTOR(63 downto 0); -- 64 ��� ��� ����������
signal DO_RGK0: STD_LOGIC_VECTOR(495 downto 0); -- ����
signal DO_RGI0: STD_LOGIC_VECTOR(63 downto 0); -- �������������
signal DO_RGI_CR: STD_LOGIC_VECTOR(63 downto 0); -- 64 ��� ������������ ������
signal DO_CLR: STD_LOGIC_VECTOR (6 downto 0); -- ����� ���������� ��������� ���������
signal DO_CLRSIG: STD_LOGIC_VECTOR (7 downto 0);
signal start: STD_LOGIC; -- ������ �������� ����������
signal fin: STD_LOGIC; -- ��������� ���������� ���������



begin


CLR2<=DO_CLRSIG(0) or CLR1; -- ����� ����� ��� ����� �� ��������� ��������� ���������� 



-- ������ ������ ����������
ctrlc: ctrlcomp
generic map (m=>7)
port map (DI_RST=>CSR3(0), DI_CLR=>CSR3(7 downto 1), CSR1=>CSR1, CLK=>CLK, CS=>CS1, 
notoprd=>notoprd, opwr=>opwr, ctrl1=>ctrl1, 
ctrl3=>ctrl3, RUN=>RUN, start=>start, fin=>fin, CLR1=>CLR1, 
DO_CLR=>DO_CLRSIG, IRQ0=>IRQ0);


-- SPI-����
spic: spis
generic map (n=>8)
port map (SPCK=>SPCK, CLK=>CLK, CLR=>CLR2, CS=>CS, MOSI=>MOSI, 
MISO=>MISO, CS1=>CS1, DO_CLR=>DO_CLR, DATA_OUT=>DATA, DATA_IN=>DO_RGI_CR, 
syncro=>DO_RGI0, key=>DO_RGK0, CSR1=>CSR1, CSR3=>CSR3, notoprd=>notoprd, 
opwr=>opwr, wrkey=>wrkey, wrsync=>wrsync, ctrl1=>ctrl1, 
ctrl3=>ctrl3, RUN=>RUN);


-- ������ ����������
Cr8: Crypto7
port map (CLK=>CLK, CLR=>CLR2, start=>start, A=>DO_RGK0, 
DO_RGI0=>DO_RGI0, DATA_DI=>DATA, DO_RGI_CR=>DO_RGI_CR, wrkey=>wrkey, 
wrsync=>wrsync, fin=>fin);


-- ������������ �������� ������ ���������� ��������� ��������� ���������� � ���������
process (DO_CLRSIG, CLR1) 
begin
for i in 0 to 6
loop
DO_CLR(i)<=DO_CLRSIG(i+1) or CLR1;
end loop;
end process;

end archi;
