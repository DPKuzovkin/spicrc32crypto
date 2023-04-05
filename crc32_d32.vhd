

--рассчет CRC32 IEEE 802.3 для Ethernet с входной шиной данных 32 бита

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- схема вычисления контрольной суммы CRC-32-IEEE 802.3 
-- за Один такт.

entity crc32_d32 is
port(clk: in std_logic; --xgmii clk 156.25 MHz

	  CLR: in std_logic;
	  data_in: in std_logic_vector(31 downto 0);  -- начальная 32-битовка
     EN: in std_logic; -- разрешение на подсчёт crc32
	  crc_out: out std_logic_vector(31 downto 0));  -- значение CRC-32-IEEE 802.3
end crc32_d32;

architecture archi of crc32_d32 is

	
  -- polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  -- data width: 64
  -- convention: the first serial bit is D[63]
  function nextCRC32_D64 (Data: std_logic_vector(63 downto 0); crc:  std_logic_vector(31 downto 0)) return std_logic_vector is
	 
    variable d:      std_logic_vector(63 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

  begin
		 d := Data;
		 c := crc;

		 newcrc(0) := d(63) xor d(61) xor d(60) xor d(58) xor d(55) xor d(54) xor d(53) xor d(50) xor d(48) xor d(47) xor d(45) xor d(44) xor d(37) xor d(34) xor d(32) xor d(31) xor d(30) xor d(29) xor d(28) xor d(26) xor d(25) xor d(24) xor d(16) xor d(12) xor d(10) xor d(9) xor d(6) xor d(0) xor c(0) xor c(2) xor c(5) xor c(12) xor c(13) xor c(15) xor c(16) xor c(18) xor c(21) xor c(22) xor c(23) xor c(26) xor c(28) xor c(29) xor c(31);
		 newcrc(1) := d(63) xor d(62) xor d(60) xor d(59) xor d(58) xor d(56) xor d(53) xor d(51) xor d(50) xor d(49) xor d(47) xor d(46) xor d(44) xor d(38) xor d(37) xor d(35) xor d(34) xor d(33) xor d(28) xor d(27) xor d(24) xor d(17) xor d(16) xor d(13) xor d(12) xor d(11) xor d(9) xor d(7) xor d(6) xor d(1) xor d(0) xor c(1) xor c(2) xor c(3) xor c(5) xor c(6) xor c(12) xor c(14) xor c(15) xor c(17) xor c(18) xor c(19) xor c(21) xor c(24) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
		 newcrc(2) := d(59) xor d(58) xor d(57) xor d(55) xor d(53) xor d(52) xor d(51) xor d(44) xor d(39) xor d(38) xor d(37) xor d(36) xor d(35) xor d(32) xor d(31) xor d(30) xor d(26) xor d(24) xor d(18) xor d(17) xor d(16) xor d(14) xor d(13) xor d(9) xor d(8) xor d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(0) xor c(3) xor c(4) xor c(5) xor c(6) xor c(7) xor c(12) xor c(19) xor c(20) xor c(21) xor c(23) xor c(25) xor c(26) xor c(27);
		 newcrc(3) := d(60) xor d(59) xor d(58) xor d(56) xor d(54) xor d(53) xor d(52) xor d(45) xor d(40) xor d(39) xor d(38) xor d(37) xor d(36) xor d(33) xor d(32) xor d(31) xor d(27) xor d(25) xor d(19) xor d(18) xor d(17) xor d(15) xor d(14) xor d(10) xor d(9) xor d(8) xor d(7) xor d(3) xor d(2) xor d(1) xor c(0) xor c(1) xor c(4) xor c(5) xor c(6) xor c(7) xor c(8) xor c(13) xor c(20) xor c(21) xor c(22) xor c(24) xor c(26) xor c(27) xor c(28);
		 newcrc(4) := d(63) xor d(59) xor d(58) xor d(57) xor d(50) xor d(48) xor d(47) xor d(46) xor d(45) xor d(44) xor d(41) xor d(40) xor d(39) xor d(38) xor d(33) xor d(31) xor d(30) xor d(29) xor d(25) xor d(24) xor d(20) xor d(19) xor d(18) xor d(15) xor d(12) xor d(11) xor d(8) xor d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(1) xor c(6) xor c(7) xor c(8) xor c(9) xor c(12) xor c(13) xor c(14) xor c(15) xor c(16) xor c(18) xor c(25) xor c(26) xor c(27) xor c(31);
		 newcrc(5) := d(63) xor d(61) xor d(59) xor d(55) xor d(54) xor d(53) xor d(51) xor d(50) xor d(49) xor d(46) xor d(44) xor d(42) xor d(41) xor d(40) xor d(39) xor d(37) xor d(29) xor d(28) xor d(24) xor d(21) xor d(20) xor d(19) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(5) xor c(7) xor c(8) xor c(9) xor c(10) xor c(12) xor c(14) xor c(17) xor c(18) xor c(19) xor c(21) xor c(22) xor c(23) xor c(27) xor c(29) xor c(31);
		 newcrc(6) := d(62) xor d(60) xor d(56) xor d(55) xor d(54) xor d(52) xor d(51) xor d(50) xor d(47) xor d(45) xor d(43) xor d(42) xor d(41) xor d(40) xor d(38) xor d(30) xor d(29) xor d(25) xor d(22) xor d(21) xor d(20) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(6) xor c(8) xor c(9) xor c(10) xor c(11) xor c(13) xor c(15) xor c(18) xor c(19) xor c(20) xor c(22) xor c(23) xor c(24) xor c(28) xor c(30);
		 newcrc(7) := d(60) xor d(58) xor d(57) xor d(56) xor d(54) xor d(52) xor d(51) xor d(50) xor d(47) xor d(46) xor d(45) xor d(43) xor d(42) xor d(41) xor d(39) xor d(37) xor d(34) xor d(32) xor d(29) xor d(28) xor d(25) xor d(24) xor d(23) xor d(22) xor d(21) xor d(16) xor d(15) xor d(10) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(5) xor c(7) xor c(9) xor c(10) xor c(11) xor c(13) xor c(14) xor c(15) xor c(18) xor c(19) xor c(20) xor c(22) xor c(24) xor c(25) xor c(26) xor c(28);
		 newcrc(8) := d(63) xor d(60) xor d(59) xor d(57) xor d(54) xor d(52) xor d(51) xor d(50) xor d(46) xor d(45) xor d(43) xor d(42) xor d(40) xor d(38) xor d(37) xor d(35) xor d(34) xor d(33) xor d(32) xor d(31) xor d(28) xor d(23) xor d(22) xor d(17) xor d(12) xor d(11) xor d(10) xor d(8) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(3) xor c(5) xor c(6) xor c(8) xor c(10) xor c(11) xor c(13) xor c(14) xor c(18) xor c(19) xor c(20) xor c(22) xor c(25) xor c(27) xor c(28) xor c(31);
		 newcrc(9) := d(61) xor d(60) xor d(58) xor d(55) xor d(53) xor d(52) xor d(51) xor d(47) xor d(46) xor d(44) xor d(43) xor d(41) xor d(39) xor d(38) xor d(36) xor d(35) xor d(34) xor d(33) xor d(32) xor d(29) xor d(24) xor d(23) xor d(18) xor d(13) xor d(12) xor d(11) xor d(9) xor d(5) xor d(4) xor d(2) xor d(1) xor c(0) xor c(1) xor c(2) xor c(3) xor c(4) xor c(6) xor c(7) xor c(9) xor c(11) xor c(12) xor c(14) xor c(15) xor c(19) xor c(20) xor c(21) xor c(23) xor c(26) xor c(28) xor c(29);
		 newcrc(10) := d(63) xor d(62) xor d(60) xor d(59) xor d(58) xor d(56) xor d(55) xor d(52) xor d(50) xor d(42) xor d(40) xor d(39) xor d(36) xor d(35) xor d(33) xor d(32) xor d(31) xor d(29) xor d(28) xor d(26) xor d(19) xor d(16) xor d(14) xor d(13) xor d(9) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(1) xor c(3) xor c(4) xor c(7) xor c(8) xor c(10) xor c(18) xor c(20) xor c(23) xor c(24) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
		 newcrc(11) := d(59) xor d(58) xor d(57) xor d(56) xor d(55) xor d(54) xor d(51) xor d(50) xor d(48) xor d(47) xor d(45) xor d(44) xor d(43) xor d(41) xor d(40) xor d(36) xor d(33) xor d(31) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(20) xor d(17) xor d(16) xor d(15) xor d(14) xor d(12) xor d(9) xor d(4) xor d(3) xor d(1) xor d(0) xor c(1) xor c(4) xor c(8) xor c(9) xor c(11) xor c(12) xor c(13) xor c(15) xor c(16) xor c(18) xor c(19) xor c(22) xor c(23) xor c(24) xor c(25) xor c(26) xor c(27);
		 newcrc(12) := d(63) xor d(61) xor d(59) xor d(57) xor d(56) xor d(54) xor d(53) xor d(52) xor d(51) xor d(50) xor d(49) xor d(47) xor d(46) xor d(42) xor d(41) xor d(31) xor d(30) xor d(27) xor d(24) xor d(21) xor d(18) xor d(17) xor d(15) xor d(13) xor d(12) xor d(9) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(9) xor c(10) xor c(14) xor c(15) xor c(17) xor c(18) xor c(19) xor c(20) xor c(21) xor c(22) xor c(24) xor c(25) xor c(27) xor c(29) xor c(31);
		 newcrc(13) := d(62) xor d(60) xor d(58) xor d(57) xor d(55) xor d(54) xor d(53) xor d(52) xor d(51) xor d(50) xor d(48) xor d(47) xor d(43) xor d(42) xor d(32) xor d(31) xor d(28) xor d(25) xor d(22) xor d(19) xor d(18) xor d(16) xor d(14) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(0) xor c(10) xor c(11) xor c(15) xor c(16) xor c(18) xor c(19) xor c(20) xor c(21) xor c(22) xor c(23) xor c(25) xor c(26) xor c(28) xor c(30);
		 newcrc(14) := d(63) xor d(61) xor d(59) xor d(58) xor d(56) xor d(55) xor d(54) xor d(53) xor d(52) xor d(51) xor d(49) xor d(48) xor d(44) xor d(43) xor d(33) xor d(32) xor d(29) xor d(26) xor d(23) xor d(20) xor d(19) xor d(17) xor d(15) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(0) xor c(1) xor c(11) xor c(12) xor c(16) xor c(17) xor c(19) xor c(20) xor c(21) xor c(22) xor c(23) xor c(24) xor c(26) xor c(27) xor c(29) xor c(31);
		 newcrc(15) := d(62) xor d(60) xor d(59) xor d(57) xor d(56) xor d(55) xor d(54) xor d(53) xor d(52) xor d(50) xor d(49) xor d(45) xor d(44) xor d(34) xor d(33) xor d(30) xor d(27) xor d(24) xor d(21) xor d(20) xor d(18) xor d(16) xor d(15) xor d(12) xor d(9) xor d(8) xor d(7) xor d(5) xor d(4) xor d(3) xor c(1) xor c(2) xor c(12) xor c(13) xor c(17) xor c(18) xor c(20) xor c(21) xor c(22) xor c(23) xor c(24) xor c(25) xor c(27) xor c(28) xor c(30);
		 newcrc(16) := d(57) xor d(56) xor d(51) xor d(48) xor d(47) xor d(46) xor d(44) xor d(37) xor d(35) xor d(32) xor d(30) xor d(29) xor d(26) xor d(24) xor d(22) xor d(21) xor d(19) xor d(17) xor d(13) xor d(12) xor d(8) xor d(5) xor d(4) xor d(0) xor c(0) xor c(3) xor c(5) xor c(12) xor c(14) xor c(15) xor c(16) xor c(19) xor c(24) xor c(25);
		 newcrc(17) := d(58) xor d(57) xor d(52) xor d(49) xor d(48) xor d(47) xor d(45) xor d(38) xor d(36) xor d(33) xor d(31) xor d(30) xor d(27) xor d(25) xor d(23) xor d(22) xor d(20) xor d(18) xor d(14) xor d(13) xor d(9) xor d(6) xor d(5) xor d(1) xor c(1) xor c(4) xor c(6) xor c(13) xor c(15) xor c(16) xor c(17) xor c(20) xor c(25) xor c(26);
		 newcrc(18) := d(59) xor d(58) xor d(53) xor d(50) xor d(49) xor d(48) xor d(46) xor d(39) xor d(37) xor d(34) xor d(32) xor d(31) xor d(28) xor d(26) xor d(24) xor d(23) xor d(21) xor d(19) xor d(15) xor d(14) xor d(10) xor d(7) xor d(6) xor d(2) xor c(0) xor c(2) xor c(5) xor c(7) xor c(14) xor c(16) xor c(17) xor c(18) xor c(21) xor c(26) xor c(27);
		 newcrc(19) := d(60) xor d(59) xor d(54) xor d(51) xor d(50) xor d(49) xor d(47) xor d(40) xor d(38) xor d(35) xor d(33) xor d(32) xor d(29) xor d(27) xor d(25) xor d(24) xor d(22) xor d(20) xor d(16) xor d(15) xor d(11) xor d(8) xor d(7) xor d(3) xor c(0) xor c(1) xor c(3) xor c(6) xor c(8) xor c(15) xor c(17) xor c(18) xor c(19) xor c(22) xor c(27) xor c(28);
		 newcrc(20) := d(61) xor d(60) xor d(55) xor d(52) xor d(51) xor d(50) xor d(48) xor d(41) xor d(39) xor d(36) xor d(34) xor d(33) xor d(30) xor d(28) xor d(26) xor d(25) xor d(23) xor d(21) xor d(17) xor d(16) xor d(12) xor d(9) xor d(8) xor d(4) xor c(1) xor c(2) xor c(4) xor c(7) xor c(9) xor c(16) xor c(18) xor c(19) xor c(20) xor c(23) xor c(28) xor c(29);
		 newcrc(21) := d(62) xor d(61) xor d(56) xor d(53) xor d(52) xor d(51) xor d(49) xor d(42) xor d(40) xor d(37) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(22) xor d(18) xor d(17) xor d(13) xor d(10) xor d(9) xor d(5) xor c(2) xor c(3) xor c(5) xor c(8) xor c(10) xor c(17) xor c(19) xor c(20) xor c(21) xor c(24) xor c(29) xor c(30);
		 newcrc(22) := d(62) xor d(61) xor d(60) xor d(58) xor d(57) xor d(55) xor d(52) xor d(48) xor d(47) xor d(45) xor d(44) xor d(43) xor d(41) xor d(38) xor d(37) xor d(36) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(23) xor d(19) xor d(18) xor d(16) xor d(14) xor d(12) xor d(11) xor d(9) xor d(0) xor c(2) xor c(3) xor c(4) xor c(5) xor c(6) xor c(9) xor c(11) xor c(12) xor c(13) xor c(15) xor c(16) xor c(20) xor c(23) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30);
		 newcrc(23) := d(62) xor d(60) xor d(59) xor d(56) xor d(55) xor d(54) xor d(50) xor d(49) xor d(47) xor d(46) xor d(42) xor d(39) xor d(38) xor d(36) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(20) xor d(19) xor d(17) xor d(16) xor d(15) xor d(13) xor d(9) xor d(6) xor d(1) xor d(0) xor c(2) xor c(3) xor c(4) xor c(6) xor c(7) xor c(10) xor c(14) xor c(15) xor c(17) xor c(18) xor c(22) xor c(23) xor c(24) xor c(27) xor c(28) xor c(30);
		 newcrc(24) := d(63) xor d(61) xor d(60) xor d(57) xor d(56) xor d(55) xor d(51) xor d(50) xor d(48) xor d(47) xor d(43) xor d(40) xor d(39) xor d(37) xor d(36) xor d(35) xor d(32) xor d(30) xor d(28) xor d(27) xor d(21) xor d(20) xor d(18) xor d(17) xor d(16) xor d(14) xor d(10) xor d(7) xor d(2) xor d(1) xor c(0) xor c(3) xor c(4) xor c(5) xor c(7) xor c(8) xor c(11) xor c(15) xor c(16) xor c(18) xor c(19) xor c(23) xor c(24) xor c(25) xor c(28) xor c(29) xor c(31);
		 newcrc(25) := d(62) xor d(61) xor d(58) xor d(57) xor d(56) xor d(52) xor d(51) xor d(49) xor d(48) xor d(44) xor d(41) xor d(40) xor d(38) xor d(37) xor d(36) xor d(33) xor d(31) xor d(29) xor d(28) xor d(22) xor d(21) xor d(19) xor d(18) xor d(17) xor d(15) xor d(11) xor d(8) xor d(3) xor d(2) xor c(1) xor c(4) xor c(5) xor c(6) xor c(8) xor c(9) xor c(12) xor c(16) xor c(17) xor c(19) xor c(20) xor c(24) xor c(25) xor c(26) xor c(29) xor c(30);
		 newcrc(26) := d(62) xor d(61) xor d(60) xor d(59) xor d(57) xor d(55) xor d(54) xor d(52) xor d(49) xor d(48) xor d(47) xor d(44) xor d(42) xor d(41) xor d(39) xor d(38) xor d(31) xor d(28) xor d(26) xor d(25) xor d(24) xor d(23) xor d(22) xor d(20) xor d(19) xor d(18) xor d(10) xor d(6) xor d(4) xor d(3) xor d(0) xor c(6) xor c(7) xor c(9) xor c(10) xor c(12) xor c(15) xor c(16) xor c(17) xor c(20) xor c(22) xor c(23) xor c(25) xor c(27) xor c(28) xor c(29) xor c(30);
		 newcrc(27) := d(63) xor d(62) xor d(61) xor d(60) xor d(58) xor d(56) xor d(55) xor d(53) xor d(50) xor d(49) xor d(48) xor d(45) xor d(43) xor d(42) xor d(40) xor d(39) xor d(32) xor d(29) xor d(27) xor d(26) xor d(25) xor d(24) xor d(23) xor d(21) xor d(20) xor d(19) xor d(11) xor d(7) xor d(5) xor d(4) xor d(1) xor c(0) xor c(7) xor c(8) xor c(10) xor c(11) xor c(13) xor c(16) xor c(17) xor c(18) xor c(21) xor c(23) xor c(24) xor c(26) xor c(28) xor c(29) xor c(30) xor c(31);
		 newcrc(28) := d(63) xor d(62) xor d(61) xor d(59) xor d(57) xor d(56) xor d(54) xor d(51) xor d(50) xor d(49) xor d(46) xor d(44) xor d(43) xor d(41) xor d(40) xor d(33) xor d(30) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(22) xor d(21) xor d(20) xor d(12) xor d(8) xor d(6) xor d(5) xor d(2) xor c(1) xor c(8) xor c(9) xor c(11) xor c(12) xor c(14) xor c(17) xor c(18) xor c(19) xor c(22) xor c(24) xor c(25) xor c(27) xor c(29) xor c(30) xor c(31);
		 newcrc(29) := d(63) xor d(62) xor d(60) xor d(58) xor d(57) xor d(55) xor d(52) xor d(51) xor d(50) xor d(47) xor d(45) xor d(44) xor d(42) xor d(41) xor d(34) xor d(31) xor d(29) xor d(28) xor d(27) xor d(26) xor d(25) xor d(23) xor d(22) xor d(21) xor d(13) xor d(9) xor d(7) xor d(6) xor d(3) xor c(2) xor c(9) xor c(10) xor c(12) xor c(13) xor c(15) xor c(18) xor c(19) xor c(20) xor c(23) xor c(25) xor c(26) xor c(28) xor c(30) xor c(31);
		 newcrc(30) := d(63) xor d(61) xor d(59) xor d(58) xor d(56) xor d(53) xor d(52) xor d(51) xor d(48) xor d(46) xor d(45) xor d(43) xor d(42) xor d(35) xor d(32) xor d(30) xor d(29) xor d(28) xor d(27) xor d(26) xor d(24) xor d(23) xor d(22) xor d(14) xor d(10) xor d(8) xor d(7) xor d(4) xor c(0) xor c(3) xor c(10) xor c(11) xor c(13) xor c(14) xor c(16) xor c(19) xor c(20) xor c(21) xor c(24) xor c(26) xor c(27) xor c(29) xor c(31);
		 newcrc(31) := d(62) xor d(60) xor d(59) xor d(57) xor d(54) xor d(53) xor d(52) xor d(49) xor d(47) xor d(46) xor d(44) xor d(43) xor d(36) xor d(33) xor d(31) xor d(30) xor d(29) xor d(28) xor d(27) xor d(25) xor d(24) xor d(23) xor d(15) xor d(11) xor d(9) xor d(8) xor d(5) xor c(1) xor c(4) xor c(11) xor c(12) xor c(14) xor c(15) xor c(17) xor c(20) xor c(21) xor c(22) xor c(25) xor c(27) xor c(28) xor c(30);
		 return newcrc;
  end nextCRC32_D64;
  
  
  -- polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  -- data width: 56
  -- convention: the first serial bit is D[55]
  function nextCRC32_D56
    (Data: std_logic_vector(55 downto 0);
     crc:  std_logic_vector(31 downto 0))
    return std_logic_vector is

    variable d:      std_logic_vector(55 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(55) xor d(54) xor d(53) xor d(50) xor d(48) xor d(47) xor d(45) xor d(44) xor d(37) xor d(34) xor d(32) xor d(31) xor d(30) xor d(29) xor d(28) xor d(26) xor d(25) xor d(24) xor d(16) xor d(12) xor d(10) xor d(9) xor d(6) xor d(0) xor c(0) xor c(1) xor c(2) xor c(4) xor c(5) xor c(6) xor c(7) xor c(8) xor c(10) xor c(13) xor c(20) xor c(21) xor c(23) xor c(24) xor c(26) xor c(29) xor c(30) xor c(31);
    newcrc(1) := d(53) xor d(51) xor d(50) xor d(49) xor d(47) xor d(46) xor d(44) xor d(38) xor d(37) xor d(35) xor d(34) xor d(33) xor d(28) xor d(27) xor d(24) xor d(17) xor d(16) xor d(13) xor d(12) xor d(11) xor d(9) xor d(7) xor d(6) xor d(1) xor d(0) xor c(0) xor c(3) xor c(4) xor c(9) xor c(10) xor c(11) xor c(13) xor c(14) xor c(20) xor c(22) xor c(23) xor c(25) xor c(26) xor c(27) xor c(29);
    newcrc(2) := d(55) xor d(53) xor d(52) xor d(51) xor d(44) xor d(39) xor d(38) xor d(37) xor d(36) xor d(35) xor d(32) xor d(31) xor d(30) xor d(26) xor d(24) xor d(18) xor d(17) xor d(16) xor d(14) xor d(13) xor d(9) xor d(8) xor d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(0) xor c(2) xor c(6) xor c(7) xor c(8) xor c(11) xor c(12) xor c(13) xor c(14) xor c(15) xor c(20) xor c(27) xor c(28) xor c(29) xor c(31);
    newcrc(3) := d(54) xor d(53) xor d(52) xor d(45) xor d(40) xor d(39) xor d(38) xor d(37) xor d(36) xor d(33) xor d(32) xor d(31) xor d(27) xor d(25) xor d(19) xor d(18) xor d(17) xor d(15) xor d(14) xor d(10) xor d(9) xor d(8) xor d(7) xor d(3) xor d(2) xor d(1) xor c(1) xor c(3) xor c(7) xor c(8) xor c(9) xor c(12) xor c(13) xor c(14) xor c(15) xor c(16) xor c(21) xor c(28) xor c(29) xor c(30);
    newcrc(4) := d(50) xor d(48) xor d(47) xor d(46) xor d(45) xor d(44) xor d(41) xor d(40) xor d(39) xor d(38) xor d(33) xor d(31) xor d(30) xor d(29) xor d(25) xor d(24) xor d(20) xor d(19) xor d(18) xor d(15) xor d(12) xor d(11) xor d(8) xor d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(0) xor c(1) xor c(5) xor c(6) xor c(7) xor c(9) xor c(14) xor c(15) xor c(16) xor c(17) xor c(20) xor c(21) xor c(22) xor c(23) xor c(24) xor c(26);
    newcrc(5) := d(55) xor d(54) xor d(53) xor d(51) xor d(50) xor d(49) xor d(46) xor d(44) xor d(42) xor d(41) xor d(40) xor d(39) xor d(37) xor d(29) xor d(28) xor d(24) xor d(21) xor d(20) xor d(19) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(4) xor c(5) xor c(13) xor c(15) xor c(16) xor c(17) xor c(18) xor c(20) xor c(22) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30) xor c(31);
    newcrc(6) := d(55) xor d(54) xor d(52) xor d(51) xor d(50) xor d(47) xor d(45) xor d(43) xor d(42) xor d(41) xor d(40) xor d(38) xor d(30) xor d(29) xor d(25) xor d(22) xor d(21) xor d(20) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(1) xor c(5) xor c(6) xor c(14) xor c(16) xor c(17) xor c(18) xor c(19) xor c(21) xor c(23) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
    newcrc(7) := d(54) xor d(52) xor d(51) xor d(50) xor d(47) xor d(46) xor d(45) xor d(43) xor d(42) xor d(41) xor d(39) xor d(37) xor d(34) xor d(32) xor d(29) xor d(28) xor d(25) xor d(24) xor d(23) xor d(22) xor d(21) xor d(16) xor d(15) xor d(10) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(1) xor c(4) xor c(5) xor c(8) xor c(10) xor c(13) xor c(15) xor c(17) xor c(18) xor c(19) xor c(21) xor c(22) xor c(23) xor c(26) xor c(27) xor c(28) xor c(30);
    newcrc(8) := d(54) xor d(52) xor d(51) xor d(50) xor d(46) xor d(45) xor d(43) xor d(42) xor d(40) xor d(38) xor d(37) xor d(35) xor d(34) xor d(33) xor d(32) xor d(31) xor d(28) xor d(23) xor d(22) xor d(17) xor d(12) xor d(11) xor d(10) xor d(8) xor d(4) xor d(3) xor d(1) xor d(0) xor c(4) xor c(7) xor c(8) xor c(9) xor c(10) xor c(11) xor c(13) xor c(14) xor c(16) xor c(18) xor c(19) xor c(21) xor c(22) xor c(26) xor c(27) xor c(28) xor c(30);
    newcrc(9) := d(55) xor d(53) xor d(52) xor d(51) xor d(47) xor d(46) xor d(44) xor d(43) xor d(41) xor d(39) xor d(38) xor d(36) xor d(35) xor d(34) xor d(33) xor d(32) xor d(29) xor d(24) xor d(23) xor d(18) xor d(13) xor d(12) xor d(11) xor d(9) xor d(5) xor d(4) xor d(2) xor d(1) xor c(0) xor c(5) xor c(8) xor c(9) xor c(10) xor c(11) xor c(12) xor c(14) xor c(15) xor c(17) xor c(19) xor c(20) xor c(22) xor c(23) xor c(27) xor c(28) xor c(29) xor c(31);
    newcrc(10) := d(55) xor d(52) xor d(50) xor d(42) xor d(40) xor d(39) xor d(36) xor d(35) xor d(33) xor d(32) xor d(31) xor d(29) xor d(28) xor d(26) xor d(19) xor d(16) xor d(14) xor d(13) xor d(9) xor d(5) xor d(3) xor d(2) xor d(0) xor c(2) xor c(4) xor c(5) xor c(7) xor c(8) xor c(9) xor c(11) xor c(12) xor c(15) xor c(16) xor c(18) xor c(26) xor c(28) xor c(31);
    newcrc(11) := d(55) xor d(54) xor d(51) xor d(50) xor d(48) xor d(47) xor d(45) xor d(44) xor d(43) xor d(41) xor d(40) xor d(36) xor d(33) xor d(31) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(20) xor d(17) xor d(16) xor d(15) xor d(14) xor d(12) xor d(9) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(3) xor c(4) xor c(7) xor c(9) xor c(12) xor c(16) xor c(17) xor c(19) xor c(20) xor c(21) xor c(23) xor c(24) xor c(26) xor c(27) xor c(30) xor c(31);
    newcrc(12) := d(54) xor d(53) xor d(52) xor d(51) xor d(50) xor d(49) xor d(47) xor d(46) xor d(42) xor d(41) xor d(31) xor d(30) xor d(27) xor d(24) xor d(21) xor d(18) xor d(17) xor d(15) xor d(13) xor d(12) xor d(9) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(0) xor c(3) xor c(6) xor c(7) xor c(17) xor c(18) xor c(22) xor c(23) xor c(25) xor c(26) xor c(27) xor c(28) xor c(29) xor c(30);
    newcrc(13) := d(55) xor d(54) xor d(53) xor d(52) xor d(51) xor d(50) xor d(48) xor d(47) xor d(43) xor d(42) xor d(32) xor d(31) xor d(28) xor d(25) xor d(22) xor d(19) xor d(18) xor d(16) xor d(14) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(1) xor c(4) xor c(7) xor c(8) xor c(18) xor c(19) xor c(23) xor c(24) xor c(26) xor c(27) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(14) := d(55) xor d(54) xor d(53) xor d(52) xor d(51) xor d(49) xor d(48) xor d(44) xor d(43) xor d(33) xor d(32) xor d(29) xor d(26) xor d(23) xor d(20) xor d(19) xor d(17) xor d(15) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(2) xor c(5) xor c(8) xor c(9) xor c(19) xor c(20) xor c(24) xor c(25) xor c(27) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(15) := d(55) xor d(54) xor d(53) xor d(52) xor d(50) xor d(49) xor d(45) xor d(44) xor d(34) xor d(33) xor d(30) xor d(27) xor d(24) xor d(21) xor d(20) xor d(18) xor d(16) xor d(15) xor d(12) xor d(9) xor d(8) xor d(7) xor d(5) xor d(4) xor d(3) xor c(0) xor c(3) xor c(6) xor c(9) xor c(10) xor c(20) xor c(21) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(16) := d(51) xor d(48) xor d(47) xor d(46) xor d(44) xor d(37) xor d(35) xor d(32) xor d(30) xor d(29) xor d(26) xor d(24) xor d(22) xor d(21) xor d(19) xor d(17) xor d(13) xor d(12) xor d(8) xor d(5) xor d(4) xor d(0) xor c(0) xor c(2) xor c(5) xor c(6) xor c(8) xor c(11) xor c(13) xor c(20) xor c(22) xor c(23) xor c(24) xor c(27);
    newcrc(17) := d(52) xor d(49) xor d(48) xor d(47) xor d(45) xor d(38) xor d(36) xor d(33) xor d(31) xor d(30) xor d(27) xor d(25) xor d(23) xor d(22) xor d(20) xor d(18) xor d(14) xor d(13) xor d(9) xor d(6) xor d(5) xor d(1) xor c(1) xor c(3) xor c(6) xor c(7) xor c(9) xor c(12) xor c(14) xor c(21) xor c(23) xor c(24) xor c(25) xor c(28);
    newcrc(18) := d(53) xor d(50) xor d(49) xor d(48) xor d(46) xor d(39) xor d(37) xor d(34) xor d(32) xor d(31) xor d(28) xor d(26) xor d(24) xor d(23) xor d(21) xor d(19) xor d(15) xor d(14) xor d(10) xor d(7) xor d(6) xor d(2) xor c(0) xor c(2) xor c(4) xor c(7) xor c(8) xor c(10) xor c(13) xor c(15) xor c(22) xor c(24) xor c(25) xor c(26) xor c(29);
    newcrc(19) := d(54) xor d(51) xor d(50) xor d(49) xor d(47) xor d(40) xor d(38) xor d(35) xor d(33) xor d(32) xor d(29) xor d(27) xor d(25) xor d(24) xor d(22) xor d(20) xor d(16) xor d(15) xor d(11) xor d(8) xor d(7) xor d(3) xor c(0) xor c(1) xor c(3) xor c(5) xor c(8) xor c(9) xor c(11) xor c(14) xor c(16) xor c(23) xor c(25) xor c(26) xor c(27) xor c(30);
    newcrc(20) := d(55) xor d(52) xor d(51) xor d(50) xor d(48) xor d(41) xor d(39) xor d(36) xor d(34) xor d(33) xor d(30) xor d(28) xor d(26) xor d(25) xor d(23) xor d(21) xor d(17) xor d(16) xor d(12) xor d(9) xor d(8) xor d(4) xor c(1) xor c(2) xor c(4) xor c(6) xor c(9) xor c(10) xor c(12) xor c(15) xor c(17) xor c(24) xor c(26) xor c(27) xor c(28) xor c(31);
    newcrc(21) := d(53) xor d(52) xor d(51) xor d(49) xor d(42) xor d(40) xor d(37) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(22) xor d(18) xor d(17) xor d(13) xor d(10) xor d(9) xor d(5) xor c(0) xor c(2) xor c(3) xor c(5) xor c(7) xor c(10) xor c(11) xor c(13) xor c(16) xor c(18) xor c(25) xor c(27) xor c(28) xor c(29);
    newcrc(22) := d(55) xor d(52) xor d(48) xor d(47) xor d(45) xor d(44) xor d(43) xor d(41) xor d(38) xor d(37) xor d(36) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(23) xor d(19) xor d(18) xor d(16) xor d(14) xor d(12) xor d(11) xor d(9) xor d(0) xor c(0) xor c(2) xor c(3) xor c(5) xor c(7) xor c(10) xor c(11) xor c(12) xor c(13) xor c(14) xor c(17) xor c(19) xor c(20) xor c(21) xor c(23) xor c(24) xor c(28) xor c(31);
    newcrc(23) := d(55) xor d(54) xor d(50) xor d(49) xor d(47) xor d(46) xor d(42) xor d(39) xor d(38) xor d(36) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(20) xor d(19) xor d(17) xor d(16) xor d(15) xor d(13) xor d(9) xor d(6) xor d(1) xor d(0) xor c(2) xor c(3) xor c(5) xor c(7) xor c(10) xor c(11) xor c(12) xor c(14) xor c(15) xor c(18) xor c(22) xor c(23) xor c(25) xor c(26) xor c(30) xor c(31);
    newcrc(24) := d(55) xor d(51) xor d(50) xor d(48) xor d(47) xor d(43) xor d(40) xor d(39) xor d(37) xor d(36) xor d(35) xor d(32) xor d(30) xor d(28) xor d(27) xor d(21) xor d(20) xor d(18) xor d(17) xor d(16) xor d(14) xor d(10) xor d(7) xor d(2) xor d(1) xor c(3) xor c(4) xor c(6) xor c(8) xor c(11) xor c(12) xor c(13) xor c(15) xor c(16) xor c(19) xor c(23) xor c(24) xor c(26) xor c(27) xor c(31);
    newcrc(25) := d(52) xor d(51) xor d(49) xor d(48) xor d(44) xor d(41) xor d(40) xor d(38) xor d(37) xor d(36) xor d(33) xor d(31) xor d(29) xor d(28) xor d(22) xor d(21) xor d(19) xor d(18) xor d(17) xor d(15) xor d(11) xor d(8) xor d(3) xor d(2) xor c(4) xor c(5) xor c(7) xor c(9) xor c(12) xor c(13) xor c(14) xor c(16) xor c(17) xor c(20) xor c(24) xor c(25) xor c(27) xor c(28);
    newcrc(26) := d(55) xor d(54) xor d(52) xor d(49) xor d(48) xor d(47) xor d(44) xor d(42) xor d(41) xor d(39) xor d(38) xor d(31) xor d(28) xor d(26) xor d(25) xor d(24) xor d(23) xor d(22) xor d(20) xor d(19) xor d(18) xor d(10) xor d(6) xor d(4) xor d(3) xor d(0) xor c(0) xor c(1) xor c(2) xor c(4) xor c(7) xor c(14) xor c(15) xor c(17) xor c(18) xor c(20) xor c(23) xor c(24) xor c(25) xor c(28) xor c(30) xor c(31);
    newcrc(27) := d(55) xor d(53) xor d(50) xor d(49) xor d(48) xor d(45) xor d(43) xor d(42) xor d(40) xor d(39) xor d(32) xor d(29) xor d(27) xor d(26) xor d(25) xor d(24) xor d(23) xor d(21) xor d(20) xor d(19) xor d(11) xor d(7) xor d(5) xor d(4) xor d(1) xor c(0) xor c(1) xor c(2) xor c(3) xor c(5) xor c(8) xor c(15) xor c(16) xor c(18) xor c(19) xor c(21) xor c(24) xor c(25) xor c(26) xor c(29) xor c(31);
    newcrc(28) := d(54) xor d(51) xor d(50) xor d(49) xor d(46) xor d(44) xor d(43) xor d(41) xor d(40) xor d(33) xor d(30) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(22) xor d(21) xor d(20) xor d(12) xor d(8) xor d(6) xor d(5) xor d(2) xor c(0) xor c(1) xor c(2) xor c(3) xor c(4) xor c(6) xor c(9) xor c(16) xor c(17) xor c(19) xor c(20) xor c(22) xor c(25) xor c(26) xor c(27) xor c(30);
    newcrc(29) := d(55) xor d(52) xor d(51) xor d(50) xor d(47) xor d(45) xor d(44) xor d(42) xor d(41) xor d(34) xor d(31) xor d(29) xor d(28) xor d(27) xor d(26) xor d(25) xor d(23) xor d(22) xor d(21) xor d(13) xor d(9) xor d(7) xor d(6) xor d(3) xor c(1) xor c(2) xor c(3) xor c(4) xor c(5) xor c(7) xor c(10) xor c(17) xor c(18) xor c(20) xor c(21) xor c(23) xor c(26) xor c(27) xor c(28) xor c(31);
    newcrc(30) := d(53) xor d(52) xor d(51) xor d(48) xor d(46) xor d(45) xor d(43) xor d(42) xor d(35) xor d(32) xor d(30) xor d(29) xor d(28) xor d(27) xor d(26) xor d(24) xor d(23) xor d(22) xor d(14) xor d(10) xor d(8) xor d(7) xor d(4) xor c(0) xor c(2) xor c(3) xor c(4) xor c(5) xor c(6) xor c(8) xor c(11) xor c(18) xor c(19) xor c(21) xor c(22) xor c(24) xor c(27) xor c(28) xor c(29);
    newcrc(31) := d(54) xor d(53) xor d(52) xor d(49) xor d(47) xor d(46) xor d(44) xor d(43) xor d(36) xor d(33) xor d(31) xor d(30) xor d(29) xor d(28) xor d(27) xor d(25) xor d(24) xor d(23) xor d(15) xor d(11) xor d(9) xor d(8) xor d(5) xor c(0) xor c(1) xor c(3) xor c(4) xor c(5) xor c(6) xor c(7) xor c(9) xor c(12) xor c(19) xor c(20) xor c(22) xor c(23) xor c(25) xor c(28) xor c(29) xor c(30);
    return newcrc;
  end nextCRC32_D56;
  
  
  -- polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  -- data width: 48
  -- convention: the first serial bit is D[47]
  function nextCRC32_D48
    (Data: std_logic_vector(47 downto 0);
     crc:  std_logic_vector(31 downto 0))
    return std_logic_vector is

    variable d:      std_logic_vector(47 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(47) xor d(45) xor d(44) xor d(37) xor d(34) xor d(32) xor d(31) xor d(30) xor d(29) xor d(28) xor d(26) xor d(25) xor d(24) xor d(16) xor d(12) xor d(10) xor d(9) xor d(6) xor d(0) xor c(0) xor c(8) xor c(9) xor c(10) xor c(12) xor c(13) xor c(14) xor c(15) xor c(16) xor c(18) xor c(21) xor c(28) xor c(29) xor c(31);
    newcrc(1) := d(47) xor d(46) xor d(44) xor d(38) xor d(37) xor d(35) xor d(34) xor d(33) xor d(28) xor d(27) xor d(24) xor d(17) xor d(16) xor d(13) xor d(12) xor d(11) xor d(9) xor d(7) xor d(6) xor d(1) xor d(0) xor c(0) xor c(1) xor c(8) xor c(11) xor c(12) xor c(17) xor c(18) xor c(19) xor c(21) xor c(22) xor c(28) xor c(30) xor c(31);
    newcrc(2) := d(44) xor d(39) xor d(38) xor d(37) xor d(36) xor d(35) xor d(32) xor d(31) xor d(30) xor d(26) xor d(24) xor d(18) xor d(17) xor d(16) xor d(14) xor d(13) xor d(9) xor d(8) xor d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(8) xor c(10) xor c(14) xor c(15) xor c(16) xor c(19) xor c(20) xor c(21) xor c(22) xor c(23) xor c(28);
    newcrc(3) := d(45) xor d(40) xor d(39) xor d(38) xor d(37) xor d(36) xor d(33) xor d(32) xor d(31) xor d(27) xor d(25) xor d(19) xor d(18) xor d(17) xor d(15) xor d(14) xor d(10) xor d(9) xor d(8) xor d(7) xor d(3) xor d(2) xor d(1) xor c(1) xor c(2) xor c(3) xor c(9) xor c(11) xor c(15) xor c(16) xor c(17) xor c(20) xor c(21) xor c(22) xor c(23) xor c(24) xor c(29);
    newcrc(4) := d(47) xor d(46) xor d(45) xor d(44) xor d(41) xor d(40) xor d(39) xor d(38) xor d(33) xor d(31) xor d(30) xor d(29) xor d(25) xor d(24) xor d(20) xor d(19) xor d(18) xor d(15) xor d(12) xor d(11) xor d(8) xor d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(2) xor c(3) xor c(4) xor c(8) xor c(9) xor c(13) xor c(14) xor c(15) xor c(17) xor c(22) xor c(23) xor c(24) xor c(25) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(5) := d(46) xor d(44) xor d(42) xor d(41) xor d(40) xor d(39) xor d(37) xor d(29) xor d(28) xor d(24) xor d(21) xor d(20) xor d(19) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(3) xor c(4) xor c(5) xor c(8) xor c(12) xor c(13) xor c(21) xor c(23) xor c(24) xor c(25) xor c(26) xor c(28) xor c(30);
    newcrc(6) := d(47) xor d(45) xor d(43) xor d(42) xor d(41) xor d(40) xor d(38) xor d(30) xor d(29) xor d(25) xor d(22) xor d(21) xor d(20) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(4) xor c(5) xor c(6) xor c(9) xor c(13) xor c(14) xor c(22) xor c(24) xor c(25) xor c(26) xor c(27) xor c(29) xor c(31);
    newcrc(7) := d(47) xor d(46) xor d(45) xor d(43) xor d(42) xor d(41) xor d(39) xor d(37) xor d(34) xor d(32) xor d(29) xor d(28) xor d(25) xor d(24) xor d(23) xor d(22) xor d(21) xor d(16) xor d(15) xor d(10) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(5) xor c(6) xor c(7) xor c(8) xor c(9) xor c(12) xor c(13) xor c(16) xor c(18) xor c(21) xor c(23) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30) xor c(31);
    newcrc(8) := d(46) xor d(45) xor d(43) xor d(42) xor d(40) xor d(38) xor d(37) xor d(35) xor d(34) xor d(33) xor d(32) xor d(31) xor d(28) xor d(23) xor d(22) xor d(17) xor d(12) xor d(11) xor d(10) xor d(8) xor d(4) xor d(3) xor d(1) xor d(0) xor c(1) xor c(6) xor c(7) xor c(12) xor c(15) xor c(16) xor c(17) xor c(18) xor c(19) xor c(21) xor c(22) xor c(24) xor c(26) xor c(27) xor c(29) xor c(30);
    newcrc(9) := d(47) xor d(46) xor d(44) xor d(43) xor d(41) xor d(39) xor d(38) xor d(36) xor d(35) xor d(34) xor d(33) xor d(32) xor d(29) xor d(24) xor d(23) xor d(18) xor d(13) xor d(12) xor d(11) xor d(9) xor d(5) xor d(4) xor d(2) xor d(1) xor c(2) xor c(7) xor c(8) xor c(13) xor c(16) xor c(17) xor c(18) xor c(19) xor c(20) xor c(22) xor c(23) xor c(25) xor c(27) xor c(28) xor c(30) xor c(31);
    newcrc(10) := d(42) xor d(40) xor d(39) xor d(36) xor d(35) xor d(33) xor d(32) xor d(31) xor d(29) xor d(28) xor d(26) xor d(19) xor d(16) xor d(14) xor d(13) xor d(9) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(3) xor c(10) xor c(12) xor c(13) xor c(15) xor c(16) xor c(17) xor c(19) xor c(20) xor c(23) xor c(24) xor c(26);
    newcrc(11) := d(47) xor d(45) xor d(44) xor d(43) xor d(41) xor d(40) xor d(36) xor d(33) xor d(31) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(20) xor d(17) xor d(16) xor d(15) xor d(14) xor d(12) xor d(9) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(4) xor c(8) xor c(9) xor c(10) xor c(11) xor c(12) xor c(15) xor c(17) xor c(20) xor c(24) xor c(25) xor c(27) xor c(28) xor c(29) xor c(31);
    newcrc(12) := d(47) xor d(46) xor d(42) xor d(41) xor d(31) xor d(30) xor d(27) xor d(24) xor d(21) xor d(18) xor d(17) xor d(15) xor d(13) xor d(12) xor d(9) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(1) xor c(2) xor c(5) xor c(8) xor c(11) xor c(14) xor c(15) xor c(25) xor c(26) xor c(30) xor c(31);
    newcrc(13) := d(47) xor d(43) xor d(42) xor d(32) xor d(31) xor d(28) xor d(25) xor d(22) xor d(19) xor d(18) xor d(16) xor d(14) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(0) xor c(2) xor c(3) xor c(6) xor c(9) xor c(12) xor c(15) xor c(16) xor c(26) xor c(27) xor c(31);
    newcrc(14) := d(44) xor d(43) xor d(33) xor d(32) xor d(29) xor d(26) xor d(23) xor d(20) xor d(19) xor d(17) xor d(15) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(1) xor c(3) xor c(4) xor c(7) xor c(10) xor c(13) xor c(16) xor c(17) xor c(27) xor c(28);
    newcrc(15) := d(45) xor d(44) xor d(34) xor d(33) xor d(30) xor d(27) xor d(24) xor d(21) xor d(20) xor d(18) xor d(16) xor d(15) xor d(12) xor d(9) xor d(8) xor d(7) xor d(5) xor d(4) xor d(3) xor c(0) xor c(2) xor c(4) xor c(5) xor c(8) xor c(11) xor c(14) xor c(17) xor c(18) xor c(28) xor c(29);
    newcrc(16) := d(47) xor d(46) xor d(44) xor d(37) xor d(35) xor d(32) xor d(30) xor d(29) xor d(26) xor d(24) xor d(22) xor d(21) xor d(19) xor d(17) xor d(13) xor d(12) xor d(8) xor d(5) xor d(4) xor d(0) xor c(1) xor c(3) xor c(5) xor c(6) xor c(8) xor c(10) xor c(13) xor c(14) xor c(16) xor c(19) xor c(21) xor c(28) xor c(30) xor c(31);
    newcrc(17) := d(47) xor d(45) xor d(38) xor d(36) xor d(33) xor d(31) xor d(30) xor d(27) xor d(25) xor d(23) xor d(22) xor d(20) xor d(18) xor d(14) xor d(13) xor d(9) xor d(6) xor d(5) xor d(1) xor c(2) xor c(4) xor c(6) xor c(7) xor c(9) xor c(11) xor c(14) xor c(15) xor c(17) xor c(20) xor c(22) xor c(29) xor c(31);
    newcrc(18) := d(46) xor d(39) xor d(37) xor d(34) xor d(32) xor d(31) xor d(28) xor d(26) xor d(24) xor d(23) xor d(21) xor d(19) xor d(15) xor d(14) xor d(10) xor d(7) xor d(6) xor d(2) xor c(3) xor c(5) xor c(7) xor c(8) xor c(10) xor c(12) xor c(15) xor c(16) xor c(18) xor c(21) xor c(23) xor c(30);
    newcrc(19) := d(47) xor d(40) xor d(38) xor d(35) xor d(33) xor d(32) xor d(29) xor d(27) xor d(25) xor d(24) xor d(22) xor d(20) xor d(16) xor d(15) xor d(11) xor d(8) xor d(7) xor d(3) xor c(0) xor c(4) xor c(6) xor c(8) xor c(9) xor c(11) xor c(13) xor c(16) xor c(17) xor c(19) xor c(22) xor c(24) xor c(31);
    newcrc(20) := d(41) xor d(39) xor d(36) xor d(34) xor d(33) xor d(30) xor d(28) xor d(26) xor d(25) xor d(23) xor d(21) xor d(17) xor d(16) xor d(12) xor d(9) xor d(8) xor d(4) xor c(0) xor c(1) xor c(5) xor c(7) xor c(9) xor c(10) xor c(12) xor c(14) xor c(17) xor c(18) xor c(20) xor c(23) xor c(25);
    newcrc(21) := d(42) xor d(40) xor d(37) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(22) xor d(18) xor d(17) xor d(13) xor d(10) xor d(9) xor d(5) xor c(1) xor c(2) xor c(6) xor c(8) xor c(10) xor c(11) xor c(13) xor c(15) xor c(18) xor c(19) xor c(21) xor c(24) xor c(26);
    newcrc(22) := d(47) xor d(45) xor d(44) xor d(43) xor d(41) xor d(38) xor d(37) xor d(36) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(23) xor d(19) xor d(18) xor d(16) xor d(14) xor d(12) xor d(11) xor d(9) xor d(0) xor c(0) xor c(2) xor c(3) xor c(7) xor c(8) xor c(10) xor c(11) xor c(13) xor c(15) xor c(18) xor c(19) xor c(20) xor c(21) xor c(22) xor c(25) xor c(27) xor c(28) xor c(29) xor c(31);
    newcrc(23) := d(47) xor d(46) xor d(42) xor d(39) xor d(38) xor d(36) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(20) xor d(19) xor d(17) xor d(16) xor d(15) xor d(13) xor d(9) xor d(6) xor d(1) xor d(0) xor c(0) xor c(1) xor c(3) xor c(4) xor c(10) xor c(11) xor c(13) xor c(15) xor c(18) xor c(19) xor c(20) xor c(22) xor c(23) xor c(26) xor c(30) xor c(31);
    newcrc(24) := d(47) xor d(43) xor d(40) xor d(39) xor d(37) xor d(36) xor d(35) xor d(32) xor d(30) xor d(28) xor d(27) xor d(21) xor d(20) xor d(18) xor d(17) xor d(16) xor d(14) xor d(10) xor d(7) xor d(2) xor d(1) xor c(0) xor c(1) xor c(2) xor c(4) xor c(5) xor c(11) xor c(12) xor c(14) xor c(16) xor c(19) xor c(20) xor c(21) xor c(23) xor c(24) xor c(27) xor c(31);
    newcrc(25) := d(44) xor d(41) xor d(40) xor d(38) xor d(37) xor d(36) xor d(33) xor d(31) xor d(29) xor d(28) xor d(22) xor d(21) xor d(19) xor d(18) xor d(17) xor d(15) xor d(11) xor d(8) xor d(3) xor d(2) xor c(1) xor c(2) xor c(3) xor c(5) xor c(6) xor c(12) xor c(13) xor c(15) xor c(17) xor c(20) xor c(21) xor c(22) xor c(24) xor c(25) xor c(28);
    newcrc(26) := d(47) xor d(44) xor d(42) xor d(41) xor d(39) xor d(38) xor d(31) xor d(28) xor d(26) xor d(25) xor d(24) xor d(23) xor d(22) xor d(20) xor d(19) xor d(18) xor d(10) xor d(6) xor d(4) xor d(3) xor d(0) xor c(2) xor c(3) xor c(4) xor c(6) xor c(7) xor c(8) xor c(9) xor c(10) xor c(12) xor c(15) xor c(22) xor c(23) xor c(25) xor c(26) xor c(28) xor c(31);
    newcrc(27) := d(45) xor d(43) xor d(42) xor d(40) xor d(39) xor d(32) xor d(29) xor d(27) xor d(26) xor d(25) xor d(24) xor d(23) xor d(21) xor d(20) xor d(19) xor d(11) xor d(7) xor d(5) xor d(4) xor d(1) xor c(3) xor c(4) xor c(5) xor c(7) xor c(8) xor c(9) xor c(10) xor c(11) xor c(13) xor c(16) xor c(23) xor c(24) xor c(26) xor c(27) xor c(29);
    newcrc(28) := d(46) xor d(44) xor d(43) xor d(41) xor d(40) xor d(33) xor d(30) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(22) xor d(21) xor d(20) xor d(12) xor d(8) xor d(6) xor d(5) xor d(2) xor c(4) xor c(5) xor c(6) xor c(8) xor c(9) xor c(10) xor c(11) xor c(12) xor c(14) xor c(17) xor c(24) xor c(25) xor c(27) xor c(28) xor c(30);
    newcrc(29) := d(47) xor d(45) xor d(44) xor d(42) xor d(41) xor d(34) xor d(31) xor d(29) xor d(28) xor d(27) xor d(26) xor d(25) xor d(23) xor d(22) xor d(21) xor d(13) xor d(9) xor d(7) xor d(6) xor d(3) xor c(5) xor c(6) xor c(7) xor c(9) xor c(10) xor c(11) xor c(12) xor c(13) xor c(15) xor c(18) xor c(25) xor c(26) xor c(28) xor c(29) xor c(31);
    newcrc(30) := d(46) xor d(45) xor d(43) xor d(42) xor d(35) xor d(32) xor d(30) xor d(29) xor d(28) xor d(27) xor d(26) xor d(24) xor d(23) xor d(22) xor d(14) xor d(10) xor d(8) xor d(7) xor d(4) xor c(6) xor c(7) xor c(8) xor c(10) xor c(11) xor c(12) xor c(13) xor c(14) xor c(16) xor c(19) xor c(26) xor c(27) xor c(29) xor c(30);
    newcrc(31) := d(47) xor d(46) xor d(44) xor d(43) xor d(36) xor d(33) xor d(31) xor d(30) xor d(29) xor d(28) xor d(27) xor d(25) xor d(24) xor d(23) xor d(15) xor d(11) xor d(9) xor d(8) xor d(5) xor c(7) xor c(8) xor c(9) xor c(11) xor c(12) xor c(13) xor c(14) xor c(15) xor c(17) xor c(20) xor c(27) xor c(28) xor c(30) xor c(31);
    return newcrc;
  end nextCRC32_D48;
  
  
    -- polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  -- data width: 40
  -- convention: the first serial bit is D[39]
  function nextCRC32_D40
    (Data: std_logic_vector(39 downto 0);
     crc:  std_logic_vector(31 downto 0))
    return std_logic_vector is

    variable d:      std_logic_vector(39 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(37) xor d(34) xor d(32) xor d(31) xor d(30) xor d(29) xor d(28) xor d(26) xor d(25) xor d(24) xor d(16) xor d(12) xor d(10) xor d(9) xor d(6) xor d(0) xor c(1) xor c(2) xor c(4) xor c(8) xor c(16) xor c(17) xor c(18) xor c(20) xor c(21) xor c(22) xor c(23) xor c(24) xor c(26) xor c(29);
    newcrc(1) := d(38) xor d(37) xor d(35) xor d(34) xor d(33) xor d(28) xor d(27) xor d(24) xor d(17) xor d(16) xor d(13) xor d(12) xor d(11) xor d(9) xor d(7) xor d(6) xor d(1) xor d(0) xor c(1) xor c(3) xor c(4) xor c(5) xor c(8) xor c(9) xor c(16) xor c(19) xor c(20) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30);
    newcrc(2) := d(39) xor d(38) xor d(37) xor d(36) xor d(35) xor d(32) xor d(31) xor d(30) xor d(26) xor d(24) xor d(18) xor d(17) xor d(16) xor d(14) xor d(13) xor d(9) xor d(8) xor d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(5) xor c(6) xor c(8) xor c(9) xor c(10) xor c(16) xor c(18) xor c(22) xor c(23) xor c(24) xor c(27) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(3) := d(39) xor d(38) xor d(37) xor d(36) xor d(33) xor d(32) xor d(31) xor d(27) xor d(25) xor d(19) xor d(18) xor d(17) xor d(15) xor d(14) xor d(10) xor d(9) xor d(8) xor d(7) xor d(3) xor d(2) xor d(1) xor c(0) xor c(1) xor c(2) xor c(6) xor c(7) xor c(9) xor c(10) xor c(11) xor c(17) xor c(19) xor c(23) xor c(24) xor c(25) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(4) := d(39) xor d(38) xor d(33) xor d(31) xor d(30) xor d(29) xor d(25) xor d(24) xor d(20) xor d(19) xor d(18) xor d(15) xor d(12) xor d(11) xor d(8) xor d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(0) xor c(3) xor c(4) xor c(7) xor c(10) xor c(11) xor c(12) xor c(16) xor c(17) xor c(21) xor c(22) xor c(23) xor c(25) xor c(30) xor c(31);
    newcrc(5) := d(39) xor d(37) xor d(29) xor d(28) xor d(24) xor d(21) xor d(20) xor d(19) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(2) xor c(5) xor c(11) xor c(12) xor c(13) xor c(16) xor c(20) xor c(21) xor c(29) xor c(31);
    newcrc(6) := d(38) xor d(30) xor d(29) xor d(25) xor d(22) xor d(21) xor d(20) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(0) xor c(3) xor c(6) xor c(12) xor c(13) xor c(14) xor c(17) xor c(21) xor c(22) xor c(30);
    newcrc(7) := d(39) xor d(37) xor d(34) xor d(32) xor d(29) xor d(28) xor d(25) xor d(24) xor d(23) xor d(22) xor d(21) xor d(16) xor d(15) xor d(10) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(7) xor c(8) xor c(13) xor c(14) xor c(15) xor c(16) xor c(17) xor c(20) xor c(21) xor c(24) xor c(26) xor c(29) xor c(31);
    newcrc(8) := d(38) xor d(37) xor d(35) xor d(34) xor d(33) xor d(32) xor d(31) xor d(28) xor d(23) xor d(22) xor d(17) xor d(12) xor d(11) xor d(10) xor d(8) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(2) xor c(3) xor c(4) xor c(9) xor c(14) xor c(15) xor c(20) xor c(23) xor c(24) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30);
    newcrc(9) := d(39) xor d(38) xor d(36) xor d(35) xor d(34) xor d(33) xor d(32) xor d(29) xor d(24) xor d(23) xor d(18) xor d(13) xor d(12) xor d(11) xor d(9) xor d(5) xor d(4) xor d(2) xor d(1) xor c(1) xor c(3) xor c(4) xor c(5) xor c(10) xor c(15) xor c(16) xor c(21) xor c(24) xor c(25) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
    newcrc(10) := d(39) xor d(36) xor d(35) xor d(33) xor d(32) xor d(31) xor d(29) xor d(28) xor d(26) xor d(19) xor d(16) xor d(14) xor d(13) xor d(9) xor d(5) xor d(3) xor d(2) xor d(0) xor c(1) xor c(5) xor c(6) xor c(8) xor c(11) xor c(18) xor c(20) xor c(21) xor c(23) xor c(24) xor c(25) xor c(27) xor c(28) xor c(31);
    newcrc(11) := d(36) xor d(33) xor d(31) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(20) xor d(17) xor d(16) xor d(15) xor d(14) xor d(12) xor d(9) xor d(4) xor d(3) xor d(1) xor d(0) xor c(1) xor c(4) xor c(6) xor c(7) xor c(8) xor c(9) xor c(12) xor c(16) xor c(17) xor c(18) xor c(19) xor c(20) xor c(23) xor c(25) xor c(28);
    newcrc(12) := d(31) xor d(30) xor d(27) xor d(24) xor d(21) xor d(18) xor d(17) xor d(15) xor d(13) xor d(12) xor d(9) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(1) xor c(4) xor c(5) xor c(7) xor c(9) xor c(10) xor c(13) xor c(16) xor c(19) xor c(22) xor c(23);
    newcrc(13) := d(32) xor d(31) xor d(28) xor d(25) xor d(22) xor d(19) xor d(18) xor d(16) xor d(14) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(2) xor c(5) xor c(6) xor c(8) xor c(10) xor c(11) xor c(14) xor c(17) xor c(20) xor c(23) xor c(24);
    newcrc(14) := d(33) xor d(32) xor d(29) xor d(26) xor d(23) xor d(20) xor d(19) xor d(17) xor d(15) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(0) xor c(3) xor c(6) xor c(7) xor c(9) xor c(11) xor c(12) xor c(15) xor c(18) xor c(21) xor c(24) xor c(25);
    newcrc(15) := d(34) xor d(33) xor d(30) xor d(27) xor d(24) xor d(21) xor d(20) xor d(18) xor d(16) xor d(15) xor d(12) xor d(9) xor d(8) xor d(7) xor d(5) xor d(4) xor d(3) xor c(0) xor c(1) xor c(4) xor c(7) xor c(8) xor c(10) xor c(12) xor c(13) xor c(16) xor c(19) xor c(22) xor c(25) xor c(26);
    newcrc(16) := d(37) xor d(35) xor d(32) xor d(30) xor d(29) xor d(26) xor d(24) xor d(22) xor d(21) xor d(19) xor d(17) xor d(13) xor d(12) xor d(8) xor d(5) xor d(4) xor d(0) xor c(0) xor c(4) xor c(5) xor c(9) xor c(11) xor c(13) xor c(14) xor c(16) xor c(18) xor c(21) xor c(22) xor c(24) xor c(27) xor c(29);
    newcrc(17) := d(38) xor d(36) xor d(33) xor d(31) xor d(30) xor d(27) xor d(25) xor d(23) xor d(22) xor d(20) xor d(18) xor d(14) xor d(13) xor d(9) xor d(6) xor d(5) xor d(1) xor c(1) xor c(5) xor c(6) xor c(10) xor c(12) xor c(14) xor c(15) xor c(17) xor c(19) xor c(22) xor c(23) xor c(25) xor c(28) xor c(30);
    newcrc(18) := d(39) xor d(37) xor d(34) xor d(32) xor d(31) xor d(28) xor d(26) xor d(24) xor d(23) xor d(21) xor d(19) xor d(15) xor d(14) xor d(10) xor d(7) xor d(6) xor d(2) xor c(2) xor c(6) xor c(7) xor c(11) xor c(13) xor c(15) xor c(16) xor c(18) xor c(20) xor c(23) xor c(24) xor c(26) xor c(29) xor c(31);
    newcrc(19) := d(38) xor d(35) xor d(33) xor d(32) xor d(29) xor d(27) xor d(25) xor d(24) xor d(22) xor d(20) xor d(16) xor d(15) xor d(11) xor d(8) xor d(7) xor d(3) xor c(0) xor c(3) xor c(7) xor c(8) xor c(12) xor c(14) xor c(16) xor c(17) xor c(19) xor c(21) xor c(24) xor c(25) xor c(27) xor c(30);
    newcrc(20) := d(39) xor d(36) xor d(34) xor d(33) xor d(30) xor d(28) xor d(26) xor d(25) xor d(23) xor d(21) xor d(17) xor d(16) xor d(12) xor d(9) xor d(8) xor d(4) xor c(0) xor c(1) xor c(4) xor c(8) xor c(9) xor c(13) xor c(15) xor c(17) xor c(18) xor c(20) xor c(22) xor c(25) xor c(26) xor c(28) xor c(31);
    newcrc(21) := d(37) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(22) xor d(18) xor d(17) xor d(13) xor d(10) xor d(9) xor d(5) xor c(1) xor c(2) xor c(5) xor c(9) xor c(10) xor c(14) xor c(16) xor c(18) xor c(19) xor c(21) xor c(23) xor c(26) xor c(27) xor c(29);
    newcrc(22) := d(38) xor d(37) xor d(36) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(23) xor d(19) xor d(18) xor d(16) xor d(14) xor d(12) xor d(11) xor d(9) xor d(0) xor c(1) xor c(3) xor c(4) xor c(6) xor c(8) xor c(10) xor c(11) xor c(15) xor c(16) xor c(18) xor c(19) xor c(21) xor c(23) xor c(26) xor c(27) xor c(28) xor c(29) xor c(30);
    newcrc(23) := d(39) xor d(38) xor d(36) xor d(35) xor d(34) xor d(31) xor d(29) xor d(27) xor d(26) xor d(20) xor d(19) xor d(17) xor d(16) xor d(15) xor d(13) xor d(9) xor d(6) xor d(1) xor d(0) xor c(1) xor c(5) xor c(7) xor c(8) xor c(9) xor c(11) xor c(12) xor c(18) xor c(19) xor c(21) xor c(23) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
    newcrc(24) := d(39) xor d(37) xor d(36) xor d(35) xor d(32) xor d(30) xor d(28) xor d(27) xor d(21) xor d(20) xor d(18) xor d(17) xor d(16) xor d(14) xor d(10) xor d(7) xor d(2) xor d(1) xor c(2) xor c(6) xor c(8) xor c(9) xor c(10) xor c(12) xor c(13) xor c(19) xor c(20) xor c(22) xor c(24) xor c(27) xor c(28) xor c(29) xor c(31);
    newcrc(25) := d(38) xor d(37) xor d(36) xor d(33) xor d(31) xor d(29) xor d(28) xor d(22) xor d(21) xor d(19) xor d(18) xor d(17) xor d(15) xor d(11) xor d(8) xor d(3) xor d(2) xor c(0) xor c(3) xor c(7) xor c(9) xor c(10) xor c(11) xor c(13) xor c(14) xor c(20) xor c(21) xor c(23) xor c(25) xor c(28) xor c(29) xor c(30);
    newcrc(26) := d(39) xor d(38) xor d(31) xor d(28) xor d(26) xor d(25) xor d(24) xor d(23) xor d(22) xor d(20) xor d(19) xor d(18) xor d(10) xor d(6) xor d(4) xor d(3) xor d(0) xor c(2) xor c(10) xor c(11) xor c(12) xor c(14) xor c(15) xor c(16) xor c(17) xor c(18) xor c(20) xor c(23) xor c(30) xor c(31);
    newcrc(27) := d(39) xor d(32) xor d(29) xor d(27) xor d(26) xor d(25) xor d(24) xor d(23) xor d(21) xor d(20) xor d(19) xor d(11) xor d(7) xor d(5) xor d(4) xor d(1) xor c(3) xor c(11) xor c(12) xor c(13) xor c(15) xor c(16) xor c(17) xor c(18) xor c(19) xor c(21) xor c(24) xor c(31);
    newcrc(28) := d(33) xor d(30) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(22) xor d(21) xor d(20) xor d(12) xor d(8) xor d(6) xor d(5) xor d(2) xor c(0) xor c(4) xor c(12) xor c(13) xor c(14) xor c(16) xor c(17) xor c(18) xor c(19) xor c(20) xor c(22) xor c(25);
    newcrc(29) := d(34) xor d(31) xor d(29) xor d(28) xor d(27) xor d(26) xor d(25) xor d(23) xor d(22) xor d(21) xor d(13) xor d(9) xor d(7) xor d(6) xor d(3) xor c(1) xor c(5) xor c(13) xor c(14) xor c(15) xor c(17) xor c(18) xor c(19) xor c(20) xor c(21) xor c(23) xor c(26);
    newcrc(30) := d(35) xor d(32) xor d(30) xor d(29) xor d(28) xor d(27) xor d(26) xor d(24) xor d(23) xor d(22) xor d(14) xor d(10) xor d(8) xor d(7) xor d(4) xor c(0) xor c(2) xor c(6) xor c(14) xor c(15) xor c(16) xor c(18) xor c(19) xor c(20) xor c(21) xor c(22) xor c(24) xor c(27);
    newcrc(31) := d(36) xor d(33) xor d(31) xor d(30) xor d(29) xor d(28) xor d(27) xor d(25) xor d(24) xor d(23) xor d(15) xor d(11) xor d(9) xor d(8) xor d(5) xor c(0) xor c(1) xor c(3) xor c(7) xor c(15) xor c(16) xor c(17) xor c(19) xor c(20) xor c(21) xor c(22) xor c(23) xor c(25) xor c(28);
    return newcrc;
  end nextCRC32_D40;
  
  
  -- polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  -- data width: 32
  -- convention: the first serial bit is D[31]
  function nextCRC32_D32
    (Data: std_logic_vector(31 downto 0);
     crc:  std_logic_vector(31 downto 0))
    return std_logic_vector is

    variable d:      std_logic_vector(31 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(31) xor d(30) xor d(29) xor d(28) xor d(26) xor d(25) xor d(24) xor d(16) xor d(12) xor d(10) xor d(9) xor d(6) xor d(0) xor c(0) xor c(6) xor c(9) xor c(10) xor c(12) xor c(16) xor c(24) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(1) := d(28) xor d(27) xor d(24) xor d(17) xor d(16) xor d(13) xor d(12) xor d(11) xor d(9) xor d(7) xor d(6) xor d(1) xor d(0) xor c(0) xor c(1) xor c(6) xor c(7) xor c(9) xor c(11) xor c(12) xor c(13) xor c(16) xor c(17) xor c(24) xor c(27) xor c(28);
    newcrc(2) := d(31) xor d(30) xor d(26) xor d(24) xor d(18) xor d(17) xor d(16) xor d(14) xor d(13) xor d(9) xor d(8) xor d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(6) xor c(7) xor c(8) xor c(9) xor c(13) xor c(14) xor c(16) xor c(17) xor c(18) xor c(24) xor c(26) xor c(30) xor c(31);
    newcrc(3) := d(31) xor d(27) xor d(25) xor d(19) xor d(18) xor d(17) xor d(15) xor d(14) xor d(10) xor d(9) xor d(8) xor d(7) xor d(3) xor d(2) xor d(1) xor c(1) xor c(2) xor c(3) xor c(7) xor c(8) xor c(9) xor c(10) xor c(14) xor c(15) xor c(17) xor c(18) xor c(19) xor c(25) xor c(27) xor c(31);
    newcrc(4) := d(31) xor d(30) xor d(29) xor d(25) xor d(24) xor d(20) xor d(19) xor d(18) xor d(15) xor d(12) xor d(11) xor d(8) xor d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(3) xor c(4) xor c(6) xor c(8) xor c(11) xor c(12) xor c(15) xor c(18) xor c(19) xor c(20) xor c(24) xor c(25) xor c(29) xor c(30) xor c(31);
    newcrc(5) := d(29) xor d(28) xor d(24) xor d(21) xor d(20) xor d(19) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(3) xor c(4) xor c(5) xor c(6) xor c(7) xor c(10) xor c(13) xor c(19) xor c(20) xor c(21) xor c(24) xor c(28) xor c(29);
    newcrc(6) := d(30) xor d(29) xor d(25) xor d(22) xor d(21) xor d(20) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(1) xor c(2) xor c(4) xor c(5) xor c(6) xor c(7) xor c(8) xor c(11) xor c(14) xor c(20) xor c(21) xor c(22) xor c(25) xor c(29) xor c(30);
    newcrc(7) := d(29) xor d(28) xor d(25) xor d(24) xor d(23) xor d(22) xor d(21) xor d(16) xor d(15) xor d(10) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(3) xor c(5) xor c(7) xor c(8) xor c(10) xor c(15) xor c(16) xor c(21) xor c(22) xor c(23) xor c(24) xor c(25) xor c(28) xor c(29);
    newcrc(8) := d(31) xor d(28) xor d(23) xor d(22) xor d(17) xor d(12) xor d(11) xor d(10) xor d(8) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(3) xor c(4) xor c(8) xor c(10) xor c(11) xor c(12) xor c(17) xor c(22) xor c(23) xor c(28) xor c(31);
    newcrc(9) := d(29) xor d(24) xor d(23) xor d(18) xor d(13) xor d(12) xor d(11) xor d(9) xor d(5) xor d(4) xor d(2) xor d(1) xor c(1) xor c(2) xor c(4) xor c(5) xor c(9) xor c(11) xor c(12) xor c(13) xor c(18) xor c(23) xor c(24) xor c(29);
    newcrc(10) := d(31) xor d(29) xor d(28) xor d(26) xor d(19) xor d(16) xor d(14) xor d(13) xor d(9) xor d(5) xor d(3) xor d(2) xor d(0) xor c(0) xor c(2) xor c(3) xor c(5) xor c(9) xor c(13) xor c(14) xor c(16) xor c(19) xor c(26) xor c(28) xor c(29) xor c(31);
    newcrc(11) := d(31) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(20) xor d(17) xor d(16) xor d(15) xor d(14) xor d(12) xor d(9) xor d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(1) xor c(3) xor c(4) xor c(9) xor c(12) xor c(14) xor c(15) xor c(16) xor c(17) xor c(20) xor c(24) xor c(25) xor c(26) xor c(27) xor c(28) xor c(31);
    newcrc(12) := d(31) xor d(30) xor d(27) xor d(24) xor d(21) xor d(18) xor d(17) xor d(15) xor d(13) xor d(12) xor d(9) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(0) xor c(1) xor c(2) xor c(4) xor c(5) xor c(6) xor c(9) xor c(12) xor c(13) xor c(15) xor c(17) xor c(18) xor c(21) xor c(24) xor c(27) xor c(30) xor c(31);
    newcrc(13) := d(31) xor d(28) xor d(25) xor d(22) xor d(19) xor d(18) xor d(16) xor d(14) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(1) xor c(2) xor c(3) xor c(5) xor c(6) xor c(7) xor c(10) xor c(13) xor c(14) xor c(16) xor c(18) xor c(19) xor c(22) xor c(25) xor c(28) xor c(31);
    newcrc(14) := d(29) xor d(26) xor d(23) xor d(20) xor d(19) xor d(17) xor d(15) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(2) xor c(3) xor c(4) xor c(6) xor c(7) xor c(8) xor c(11) xor c(14) xor c(15) xor c(17) xor c(19) xor c(20) xor c(23) xor c(26) xor c(29);
    newcrc(15) := d(30) xor d(27) xor d(24) xor d(21) xor d(20) xor d(18) xor d(16) xor d(15) xor d(12) xor d(9) xor d(8) xor d(7) xor d(5) xor d(4) xor d(3) xor c(3) xor c(4) xor c(5) xor c(7) xor c(8) xor c(9) xor c(12) xor c(15) xor c(16) xor c(18) xor c(20) xor c(21) xor c(24) xor c(27) xor c(30);
    newcrc(16) := d(30) xor d(29) xor d(26) xor d(24) xor d(22) xor d(21) xor d(19) xor d(17) xor d(13) xor d(12) xor d(8) xor d(5) xor d(4) xor d(0) xor c(0) xor c(4) xor c(5) xor c(8) xor c(12) xor c(13) xor c(17) xor c(19) xor c(21) xor c(22) xor c(24) xor c(26) xor c(29) xor c(30);
    newcrc(17) := d(31) xor d(30) xor d(27) xor d(25) xor d(23) xor d(22) xor d(20) xor d(18) xor d(14) xor d(13) xor d(9) xor d(6) xor d(5) xor d(1) xor c(1) xor c(5) xor c(6) xor c(9) xor c(13) xor c(14) xor c(18) xor c(20) xor c(22) xor c(23) xor c(25) xor c(27) xor c(30) xor c(31);
    newcrc(18) := d(31) xor d(28) xor d(26) xor d(24) xor d(23) xor d(21) xor d(19) xor d(15) xor d(14) xor d(10) xor d(7) xor d(6) xor d(2) xor c(2) xor c(6) xor c(7) xor c(10) xor c(14) xor c(15) xor c(19) xor c(21) xor c(23) xor c(24) xor c(26) xor c(28) xor c(31);
    newcrc(19) := d(29) xor d(27) xor d(25) xor d(24) xor d(22) xor d(20) xor d(16) xor d(15) xor d(11) xor d(8) xor d(7) xor d(3) xor c(3) xor c(7) xor c(8) xor c(11) xor c(15) xor c(16) xor c(20) xor c(22) xor c(24) xor c(25) xor c(27) xor c(29);
    newcrc(20) := d(30) xor d(28) xor d(26) xor d(25) xor d(23) xor d(21) xor d(17) xor d(16) xor d(12) xor d(9) xor d(8) xor d(4) xor c(4) xor c(8) xor c(9) xor c(12) xor c(16) xor c(17) xor c(21) xor c(23) xor c(25) xor c(26) xor c(28) xor c(30);
    newcrc(21) := d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(22) xor d(18) xor d(17) xor d(13) xor d(10) xor d(9) xor d(5) xor c(5) xor c(9) xor c(10) xor c(13) xor c(17) xor c(18) xor c(22) xor c(24) xor c(26) xor c(27) xor c(29) xor c(31);
    newcrc(22) := d(31) xor d(29) xor d(27) xor d(26) xor d(24) xor d(23) xor d(19) xor d(18) xor d(16) xor d(14) xor d(12) xor d(11) xor d(9) xor d(0) xor c(0) xor c(9) xor c(11) xor c(12) xor c(14) xor c(16) xor c(18) xor c(19) xor c(23) xor c(24) xor c(26) xor c(27) xor c(29) xor c(31);
    newcrc(23) := d(31) xor d(29) xor d(27) xor d(26) xor d(20) xor d(19) xor d(17) xor d(16) xor d(15) xor d(13) xor d(9) xor d(6) xor d(1) xor d(0) xor c(0) xor c(1) xor c(6) xor c(9) xor c(13) xor c(15) xor c(16) xor c(17) xor c(19) xor c(20) xor c(26) xor c(27) xor c(29) xor c(31);
    newcrc(24) := d(30) xor d(28) xor d(27) xor d(21) xor d(20) xor d(18) xor d(17) xor d(16) xor d(14) xor d(10) xor d(7) xor d(2) xor d(1) xor c(1) xor c(2) xor c(7) xor c(10) xor c(14) xor c(16) xor c(17) xor c(18) xor c(20) xor c(21) xor c(27) xor c(28) xor c(30);
    newcrc(25) := d(31) xor d(29) xor d(28) xor d(22) xor d(21) xor d(19) xor d(18) xor d(17) xor d(15) xor d(11) xor d(8) xor d(3) xor d(2) xor c(2) xor c(3) xor c(8) xor c(11) xor c(15) xor c(17) xor c(18) xor c(19) xor c(21) xor c(22) xor c(28) xor c(29) xor c(31);
    newcrc(26) := d(31) xor d(28) xor d(26) xor d(25) xor d(24) xor d(23) xor d(22) xor d(20) xor d(19) xor d(18) xor d(10) xor d(6) xor d(4) xor d(3) xor d(0) xor c(0) xor c(3) xor c(4) xor c(6) xor c(10) xor c(18) xor c(19) xor c(20) xor c(22) xor c(23) xor c(24) xor c(25) xor c(26) xor c(28) xor c(31);
    newcrc(27) := d(29) xor d(27) xor d(26) xor d(25) xor d(24) xor d(23) xor d(21) xor d(20) xor d(19) xor d(11) xor d(7) xor d(5) xor d(4) xor d(1) xor c(1) xor c(4) xor c(5) xor c(7) xor c(11) xor c(19) xor c(20) xor c(21) xor c(23) xor c(24) xor c(25) xor c(26) xor c(27) xor c(29);
    newcrc(28) := d(30) xor d(28) xor d(27) xor d(26) xor d(25) xor d(24) xor d(22) xor d(21) xor d(20) xor d(12) xor d(8) xor d(6) xor d(5) xor d(2) xor c(2) xor c(5) xor c(6) xor c(8) xor c(12) xor c(20) xor c(21) xor c(22) xor c(24) xor c(25) xor c(26) xor c(27) xor c(28) xor c(30);
    newcrc(29) := d(31) xor d(29) xor d(28) xor d(27) xor d(26) xor d(25) xor d(23) xor d(22) xor d(21) xor d(13) xor d(9) xor d(7) xor d(6) xor d(3) xor c(3) xor c(6) xor c(7) xor c(9) xor c(13) xor c(21) xor c(22) xor c(23) xor c(25) xor c(26) xor c(27) xor c(28) xor c(29) xor c(31);
    newcrc(30) := d(30) xor d(29) xor d(28) xor d(27) xor d(26) xor d(24) xor d(23) xor d(22) xor d(14) xor d(10) xor d(8) xor d(7) xor d(4) xor c(4) xor c(7) xor c(8) xor c(10) xor c(14) xor c(22) xor c(23) xor c(24) xor c(26) xor c(27) xor c(28) xor c(29) xor c(30);
    newcrc(31) := d(31) xor d(30) xor d(29) xor d(28) xor d(27) xor d(25) xor d(24) xor d(23) xor d(15) xor d(11) xor d(9) xor d(8) xor d(5) xor c(5) xor c(8) xor c(9) xor c(11) xor c(15) xor c(23) xor c(24) xor c(25) xor c(27) xor c(28) xor c(29) xor c(30) xor c(31);
    return newcrc;
  end nextCRC32_D32;
  
  
  -- polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  -- data width: 24
  -- convention: the first serial bit is D[23]
  function nextCRC32_D24
    (Data: std_logic_vector(23 downto 0);
     crc:  std_logic_vector(31 downto 0))
    return std_logic_vector is

    variable d:      std_logic_vector(23 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(16) xor d(12) xor d(10) xor d(9) xor d(6) xor d(0) xor c(8) xor c(14) xor c(17) xor c(18) xor c(20) xor c(24);
    newcrc(1) := d(17) xor d(16) xor d(13) xor d(12) xor d(11) xor d(9) xor d(7) xor d(6) xor d(1) xor d(0) xor c(8) xor c(9) xor c(14) xor c(15) xor c(17) xor c(19) xor c(20) xor c(21) xor c(24) xor c(25);
    newcrc(2) := d(18) xor d(17) xor d(16) xor d(14) xor d(13) xor d(9) xor d(8) xor d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(8) xor c(9) xor c(10) xor c(14) xor c(15) xor c(16) xor c(17) xor c(21) xor c(22) xor c(24) xor c(25) xor c(26);
    newcrc(3) := d(19) xor d(18) xor d(17) xor d(15) xor d(14) xor d(10) xor d(9) xor d(8) xor d(7) xor d(3) xor d(2) xor d(1) xor c(9) xor c(10) xor c(11) xor c(15) xor c(16) xor c(17) xor c(18) xor c(22) xor c(23) xor c(25) xor c(26) xor c(27);
    newcrc(4) := d(20) xor d(19) xor d(18) xor d(15) xor d(12) xor d(11) xor d(8) xor d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(8) xor c(10) xor c(11) xor c(12) xor c(14) xor c(16) xor c(19) xor c(20) xor c(23) xor c(26) xor c(27) xor c(28);
    newcrc(5) := d(21) xor d(20) xor d(19) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(8) xor c(9) xor c(11) xor c(12) xor c(13) xor c(14) xor c(15) xor c(18) xor c(21) xor c(27) xor c(28) xor c(29);
    newcrc(6) := d(22) xor d(21) xor d(20) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(9) xor c(10) xor c(12) xor c(13) xor c(14) xor c(15) xor c(16) xor c(19) xor c(22) xor c(28) xor c(29) xor c(30);
    newcrc(7) := d(23) xor d(22) xor d(21) xor d(16) xor d(15) xor d(10) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(8) xor c(10) xor c(11) xor c(13) xor c(15) xor c(16) xor c(18) xor c(23) xor c(24) xor c(29) xor c(30) xor c(31);
    newcrc(8) := d(23) xor d(22) xor d(17) xor d(12) xor d(11) xor d(10) xor d(8) xor d(4) xor d(3) xor d(1) xor d(0) xor c(8) xor c(9) xor c(11) xor c(12) xor c(16) xor c(18) xor c(19) xor c(20) xor c(25) xor c(30) xor c(31);
    newcrc(9) := d(23) xor d(18) xor d(13) xor d(12) xor d(11) xor d(9) xor d(5) xor d(4) xor d(2) xor d(1) xor c(9) xor c(10) xor c(12) xor c(13) xor c(17) xor c(19) xor c(20) xor c(21) xor c(26) xor c(31);
    newcrc(10) := d(19) xor d(16) xor d(14) xor d(13) xor d(9) xor d(5) xor d(3) xor d(2) xor d(0) xor c(8) xor c(10) xor c(11) xor c(13) xor c(17) xor c(21) xor c(22) xor c(24) xor c(27);
    newcrc(11) := d(20) xor d(17) xor d(16) xor d(15) xor d(14) xor d(12) xor d(9) xor d(4) xor d(3) xor d(1) xor d(0) xor c(8) xor c(9) xor c(11) xor c(12) xor c(17) xor c(20) xor c(22) xor c(23) xor c(24) xor c(25) xor c(28);
    newcrc(12) := d(21) xor d(18) xor d(17) xor d(15) xor d(13) xor d(12) xor d(9) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(8) xor c(9) xor c(10) xor c(12) xor c(13) xor c(14) xor c(17) xor c(20) xor c(21) xor c(23) xor c(25) xor c(26) xor c(29);
    newcrc(13) := d(22) xor d(19) xor d(18) xor d(16) xor d(14) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(9) xor c(10) xor c(11) xor c(13) xor c(14) xor c(15) xor c(18) xor c(21) xor c(22) xor c(24) xor c(26) xor c(27) xor c(30);
    newcrc(14) := d(23) xor d(20) xor d(19) xor d(17) xor d(15) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(10) xor c(11) xor c(12) xor c(14) xor c(15) xor c(16) xor c(19) xor c(22) xor c(23) xor c(25) xor c(27) xor c(28) xor c(31);
    newcrc(15) := d(21) xor d(20) xor d(18) xor d(16) xor d(15) xor d(12) xor d(9) xor d(8) xor d(7) xor d(5) xor d(4) xor d(3) xor c(11) xor c(12) xor c(13) xor c(15) xor c(16) xor c(17) xor c(20) xor c(23) xor c(24) xor c(26) xor c(28) xor c(29);
    newcrc(16) := d(22) xor d(21) xor d(19) xor d(17) xor d(13) xor d(12) xor d(8) xor d(5) xor d(4) xor d(0) xor c(8) xor c(12) xor c(13) xor c(16) xor c(20) xor c(21) xor c(25) xor c(27) xor c(29) xor c(30);
    newcrc(17) := d(23) xor d(22) xor d(20) xor d(18) xor d(14) xor d(13) xor d(9) xor d(6) xor d(5) xor d(1) xor c(9) xor c(13) xor c(14) xor c(17) xor c(21) xor c(22) xor c(26) xor c(28) xor c(30) xor c(31);
    newcrc(18) := d(23) xor d(21) xor d(19) xor d(15) xor d(14) xor d(10) xor d(7) xor d(6) xor d(2) xor c(10) xor c(14) xor c(15) xor c(18) xor c(22) xor c(23) xor c(27) xor c(29) xor c(31);
    newcrc(19) := d(22) xor d(20) xor d(16) xor d(15) xor d(11) xor d(8) xor d(7) xor d(3) xor c(11) xor c(15) xor c(16) xor c(19) xor c(23) xor c(24) xor c(28) xor c(30);
    newcrc(20) := d(23) xor d(21) xor d(17) xor d(16) xor d(12) xor d(9) xor d(8) xor d(4) xor c(12) xor c(16) xor c(17) xor c(20) xor c(24) xor c(25) xor c(29) xor c(31);
    newcrc(21) := d(22) xor d(18) xor d(17) xor d(13) xor d(10) xor d(9) xor d(5) xor c(13) xor c(17) xor c(18) xor c(21) xor c(25) xor c(26) xor c(30);
    newcrc(22) := d(23) xor d(19) xor d(18) xor d(16) xor d(14) xor d(12) xor d(11) xor d(9) xor d(0) xor c(8) xor c(17) xor c(19) xor c(20) xor c(22) xor c(24) xor c(26) xor c(27) xor c(31);
    newcrc(23) := d(20) xor d(19) xor d(17) xor d(16) xor d(15) xor d(13) xor d(9) xor d(6) xor d(1) xor d(0) xor c(8) xor c(9) xor c(14) xor c(17) xor c(21) xor c(23) xor c(24) xor c(25) xor c(27) xor c(28);
    newcrc(24) := d(21) xor d(20) xor d(18) xor d(17) xor d(16) xor d(14) xor d(10) xor d(7) xor d(2) xor d(1) xor c(0) xor c(9) xor c(10) xor c(15) xor c(18) xor c(22) xor c(24) xor c(25) xor c(26) xor c(28) xor c(29);
    newcrc(25) := d(22) xor d(21) xor d(19) xor d(18) xor d(17) xor d(15) xor d(11) xor d(8) xor d(3) xor d(2) xor c(1) xor c(10) xor c(11) xor c(16) xor c(19) xor c(23) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30);
    newcrc(26) := d(23) xor d(22) xor d(20) xor d(19) xor d(18) xor d(10) xor d(6) xor d(4) xor d(3) xor d(0) xor c(2) xor c(8) xor c(11) xor c(12) xor c(14) xor c(18) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
    newcrc(27) := d(23) xor d(21) xor d(20) xor d(19) xor d(11) xor d(7) xor d(5) xor d(4) xor d(1) xor c(3) xor c(9) xor c(12) xor c(13) xor c(15) xor c(19) xor c(27) xor c(28) xor c(29) xor c(31);
    newcrc(28) := d(22) xor d(21) xor d(20) xor d(12) xor d(8) xor d(6) xor d(5) xor d(2) xor c(4) xor c(10) xor c(13) xor c(14) xor c(16) xor c(20) xor c(28) xor c(29) xor c(30);
    newcrc(29) := d(23) xor d(22) xor d(21) xor d(13) xor d(9) xor d(7) xor d(6) xor d(3) xor c(5) xor c(11) xor c(14) xor c(15) xor c(17) xor c(21) xor c(29) xor c(30) xor c(31);
    newcrc(30) := d(23) xor d(22) xor d(14) xor d(10) xor d(8) xor d(7) xor d(4) xor c(6) xor c(12) xor c(15) xor c(16) xor c(18) xor c(22) xor c(30) xor c(31);
    newcrc(31) := d(23) xor d(15) xor d(11) xor d(9) xor d(8) xor d(5) xor c(7) xor c(13) xor c(16) xor c(17) xor c(19) xor c(23) xor c(31);
    return newcrc;
  end nextCRC32_D24;
  
  
  -- polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  -- data width: 16
  -- convention: the first serial bit is D[15]
  function nextCRC32_D16
    (Data: std_logic_vector(15 downto 0);
     crc:  std_logic_vector(31 downto 0))
    return std_logic_vector is

    variable d:      std_logic_vector(15 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(12) xor d(10) xor d(9) xor d(6) xor d(0) xor c(16) xor c(22) xor c(25) xor c(26) xor c(28);
    newcrc(1) := d(13) xor d(12) xor d(11) xor d(9) xor d(7) xor d(6) xor d(1) xor d(0) xor c(16) xor c(17) xor c(22) xor c(23) xor c(25) xor c(27) xor c(28) xor c(29);
    newcrc(2) := d(14) xor d(13) xor d(9) xor d(8) xor d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(16) xor c(17) xor c(18) xor c(22) xor c(23) xor c(24) xor c(25) xor c(29) xor c(30);
    newcrc(3) := d(15) xor d(14) xor d(10) xor d(9) xor d(8) xor d(7) xor d(3) xor d(2) xor d(1) xor c(17) xor c(18) xor c(19) xor c(23) xor c(24) xor c(25) xor c(26) xor c(30) xor c(31);
    newcrc(4) := d(15) xor d(12) xor d(11) xor d(8) xor d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(16) xor c(18) xor c(19) xor c(20) xor c(22) xor c(24) xor c(27) xor c(28) xor c(31);
    newcrc(5) := d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(16) xor c(17) xor c(19) xor c(20) xor c(21) xor c(22) xor c(23) xor c(26) xor c(29);
    newcrc(6) := d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(17) xor c(18) xor c(20) xor c(21) xor c(22) xor c(23) xor c(24) xor c(27) xor c(30);
    newcrc(7) := d(15) xor d(10) xor d(8) xor d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(16) xor c(18) xor c(19) xor c(21) xor c(23) xor c(24) xor c(26) xor c(31);
    newcrc(8) := d(12) xor d(11) xor d(10) xor d(8) xor d(4) xor d(3) xor d(1) xor d(0) xor c(16) xor c(17) xor c(19) xor c(20) xor c(24) xor c(26) xor c(27) xor c(28);
    newcrc(9) := d(13) xor d(12) xor d(11) xor d(9) xor d(5) xor d(4) xor d(2) xor d(1) xor c(17) xor c(18) xor c(20) xor c(21) xor c(25) xor c(27) xor c(28) xor c(29);
    newcrc(10) := d(14) xor d(13) xor d(9) xor d(5) xor d(3) xor d(2) xor d(0) xor c(16) xor c(18) xor c(19) xor c(21) xor c(25) xor c(29) xor c(30);
    newcrc(11) := d(15) xor d(14) xor d(12) xor d(9) xor d(4) xor d(3) xor d(1) xor d(0) xor c(16) xor c(17) xor c(19) xor c(20) xor c(25) xor c(28) xor c(30) xor c(31);
    newcrc(12) := d(15) xor d(13) xor d(12) xor d(9) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(16) xor c(17) xor c(18) xor c(20) xor c(21) xor c(22) xor c(25) xor c(28) xor c(29) xor c(31);
    newcrc(13) := d(14) xor d(13) xor d(10) xor d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(17) xor c(18) xor c(19) xor c(21) xor c(22) xor c(23) xor c(26) xor c(29) xor c(30);
    newcrc(14) := d(15) xor d(14) xor d(11) xor d(8) xor d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(18) xor c(19) xor c(20) xor c(22) xor c(23) xor c(24) xor c(27) xor c(30) xor c(31);
    newcrc(15) := d(15) xor d(12) xor d(9) xor d(8) xor d(7) xor d(5) xor d(4) xor d(3) xor c(19) xor c(20) xor c(21) xor c(23) xor c(24) xor c(25) xor c(28) xor c(31);
    newcrc(16) := d(13) xor d(12) xor d(8) xor d(5) xor d(4) xor d(0) xor c(0) xor c(16) xor c(20) xor c(21) xor c(24) xor c(28) xor c(29);
    newcrc(17) := d(14) xor d(13) xor d(9) xor d(6) xor d(5) xor d(1) xor c(1) xor c(17) xor c(21) xor c(22) xor c(25) xor c(29) xor c(30);
    newcrc(18) := d(15) xor d(14) xor d(10) xor d(7) xor d(6) xor d(2) xor c(2) xor c(18) xor c(22) xor c(23) xor c(26) xor c(30) xor c(31);
    newcrc(19) := d(15) xor d(11) xor d(8) xor d(7) xor d(3) xor c(3) xor c(19) xor c(23) xor c(24) xor c(27) xor c(31);
    newcrc(20) := d(12) xor d(9) xor d(8) xor d(4) xor c(4) xor c(20) xor c(24) xor c(25) xor c(28);
    newcrc(21) := d(13) xor d(10) xor d(9) xor d(5) xor c(5) xor c(21) xor c(25) xor c(26) xor c(29);
    newcrc(22) := d(14) xor d(12) xor d(11) xor d(9) xor d(0) xor c(6) xor c(16) xor c(25) xor c(27) xor c(28) xor c(30);
    newcrc(23) := d(15) xor d(13) xor d(9) xor d(6) xor d(1) xor d(0) xor c(7) xor c(16) xor c(17) xor c(22) xor c(25) xor c(29) xor c(31);
    newcrc(24) := d(14) xor d(10) xor d(7) xor d(2) xor d(1) xor c(8) xor c(17) xor c(18) xor c(23) xor c(26) xor c(30);
    newcrc(25) := d(15) xor d(11) xor d(8) xor d(3) xor d(2) xor c(9) xor c(18) xor c(19) xor c(24) xor c(27) xor c(31);
    newcrc(26) := d(10) xor d(6) xor d(4) xor d(3) xor d(0) xor c(10) xor c(16) xor c(19) xor c(20) xor c(22) xor c(26);
    newcrc(27) := d(11) xor d(7) xor d(5) xor d(4) xor d(1) xor c(11) xor c(17) xor c(20) xor c(21) xor c(23) xor c(27);
    newcrc(28) := d(12) xor d(8) xor d(6) xor d(5) xor d(2) xor c(12) xor c(18) xor c(21) xor c(22) xor c(24) xor c(28);
    newcrc(29) := d(13) xor d(9) xor d(7) xor d(6) xor d(3) xor c(13) xor c(19) xor c(22) xor c(23) xor c(25) xor c(29);
    newcrc(30) := d(14) xor d(10) xor d(8) xor d(7) xor d(4) xor c(14) xor c(20) xor c(23) xor c(24) xor c(26) xor c(30);
    newcrc(31) := d(15) xor d(11) xor d(9) xor d(8) xor d(5) xor c(15) xor c(21) xor c(24) xor c(25) xor c(27) xor c(31);
    return newcrc;
  end nextCRC32_D16;
  
  
  -- polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
  -- data width: 8
  -- convention: the first serial bit is D[7]
  function nextCRC32_D8
    (Data: std_logic_vector(7 downto 0);
     crc:  std_logic_vector(31 downto 0))
    return std_logic_vector is

    variable d:      std_logic_vector(7 downto 0);
    variable c:      std_logic_vector(31 downto 0);
    variable newcrc: std_logic_vector(31 downto 0);

  begin
    d := Data;
    c := crc;

    newcrc(0) := d(6) xor d(0) xor c(24) xor c(30);
    newcrc(1) := d(7) xor d(6) xor d(1) xor d(0) xor c(24) xor c(25) xor c(30) xor c(31);
    newcrc(2) := d(7) xor d(6) xor d(2) xor d(1) xor d(0) xor c(24) xor c(25) xor c(26) xor c(30) xor c(31);
    newcrc(3) := d(7) xor d(3) xor d(2) xor d(1) xor c(25) xor c(26) xor c(27) xor c(31);
    newcrc(4) := d(6) xor d(4) xor d(3) xor d(2) xor d(0) xor c(24) xor c(26) xor c(27) xor c(28) xor c(30);
    newcrc(5) := d(7) xor d(6) xor d(5) xor d(4) xor d(3) xor d(1) xor d(0) xor c(24) xor c(25) xor c(27) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(6) := d(7) xor d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30) xor c(31);
    newcrc(7) := d(7) xor d(5) xor d(3) xor d(2) xor d(0) xor c(24) xor c(26) xor c(27) xor c(29) xor c(31);
    newcrc(8) := d(4) xor d(3) xor d(1) xor d(0) xor c(0) xor c(24) xor c(25) xor c(27) xor c(28);
    newcrc(9) := d(5) xor d(4) xor d(2) xor d(1) xor c(1) xor c(25) xor c(26) xor c(28) xor c(29);
    newcrc(10) := d(5) xor d(3) xor d(2) xor d(0) xor c(2) xor c(24) xor c(26) xor c(27) xor c(29);
    newcrc(11) := d(4) xor d(3) xor d(1) xor d(0) xor c(3) xor c(24) xor c(25) xor c(27) xor c(28);
    newcrc(12) := d(6) xor d(5) xor d(4) xor d(2) xor d(1) xor d(0) xor c(4) xor c(24) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30);
    newcrc(13) := d(7) xor d(6) xor d(5) xor d(3) xor d(2) xor d(1) xor c(5) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30) xor c(31);
    newcrc(14) := d(7) xor d(6) xor d(4) xor d(3) xor d(2) xor c(6) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31);
    newcrc(15) := d(7) xor d(5) xor d(4) xor d(3) xor c(7) xor c(27) xor c(28) xor c(29) xor c(31);
    newcrc(16) := d(5) xor d(4) xor d(0) xor c(8) xor c(24) xor c(28) xor c(29);
    newcrc(17) := d(6) xor d(5) xor d(1) xor c(9) xor c(25) xor c(29) xor c(30);
    newcrc(18) := d(7) xor d(6) xor d(2) xor c(10) xor c(26) xor c(30) xor c(31);
    newcrc(19) := d(7) xor d(3) xor c(11) xor c(27) xor c(31);
    newcrc(20) := d(4) xor c(12) xor c(28);
    newcrc(21) := d(5) xor c(13) xor c(29);
    newcrc(22) := d(0) xor c(14) xor c(24);
    newcrc(23) := d(6) xor d(1) xor d(0) xor c(15) xor c(24) xor c(25) xor c(30);
    newcrc(24) := d(7) xor d(2) xor d(1) xor c(16) xor c(25) xor c(26) xor c(31);
    newcrc(25) := d(3) xor d(2) xor c(17) xor c(26) xor c(27);
    newcrc(26) := d(6) xor d(4) xor d(3) xor d(0) xor c(18) xor c(24) xor c(27) xor c(28) xor c(30);
    newcrc(27) := d(7) xor d(5) xor d(4) xor d(1) xor c(19) xor c(25) xor c(28) xor c(29) xor c(31);
    newcrc(28) := d(6) xor d(5) xor d(2) xor c(20) xor c(26) xor c(29) xor c(30);
    newcrc(29) := d(7) xor d(6) xor d(3) xor c(21) xor c(27) xor c(30) xor c(31);
    newcrc(30) := d(7) xor d(4) xor c(22) xor c(28) xor c(31);
    newcrc(31) := d(5) xor c(23) xor c(29);
    return newcrc;
  end nextCRC32_D8;
	
	

component dataregclren is
generic(n: POSITIVE);
port (
DI: in std_logic_vector(n-1 downto 0);
DO: out std_logic_vector(n-1 downto 0);
CLK, CLR, CE: in std_logic);
end component dataregclren;
	

signal crc_regi : std_logic_vector(31 downto 0);
signal crc_reg : std_logic_vector(31 downto 0);
	

begin


crc_out <= crc_reg;
crc_regi <= nextCRC32_D32(data_in, crc_reg);



datac: dataregclren
generic map (n=>32)
port map (DI=>crc_regi, DO=>crc_reg, CLK=>CLK, 
CLR=>CLR, CE=>EN);
			
end archi;


library IEEE;
use IEEE.std_logic_1164.all;

entity dataregclren is
generic(n: POSITIVE);
port (
DI: in std_logic_vector(n-1 downto 0);
DO: out std_logic_vector(n-1 downto 0);
CLK, CLR, CE: in std_logic);
end dataregclren;

architecture rtl of dataregclren is
begin
process (CLK, CLR) 
begin
if (CLR = '1') then
DO<= (others=> '1');
elsif (CLK'event and CLK = '1') then 
if (CE = '1') then
DO <= DI;
end if;
end if;
end process;
end rtl;




