library IEEE;
use ieee.std_logic_1164.all;

entity calendario is
	port(
		clk	: in std_logic;
		data  : in std_logic;
		sel	: in std_logic;
		add	: in std_logic;
		disp1	: out std_logic_vector(7 downto 0);
		disp2	: out std_logic_vector(7 downto 0);
		disp3	: out std_logic_vector(7 downto 0);
		disp4	: out std_logic_vector(7 downto 0);
		disp5	: out std_logic_vector(7 downto 0);
		disp6	: out std_logic_vector(7 downto 0)
		);
end calendario;

architecture logic of calendario is

	constant freq: integer := 50e6;
	
	type Estado_type is (D, Me, A, H, Mi);
	
	signal E: Estado_type := H;
	signal cnt: integer := 0;
	signal msc: integer := 0;
	signal flag: integer := 0;
	signal dia: positive range 1 to 32;
	signal mes: positive range 1 to 13;
	signal ano: natural range 0 to 100;
	signal hor: natural range 0 to 24 ;
	signal min: natural range 0 to 60 ;
	signal sec: natural range 0 to 60 ;
	
	signal diaF: positive range 1 to 32;
	signal mesF: positive range 1 to 13;
	signal anoF: natural range 0 to 100;
	signal horF: natural range 0 to 24;
	signal minF: natural range 0 to 60;
	
	signal diaO: natural range 0 to 31;
	signal mesO: natural range 0 to 12;
	signal anoO: natural range 0 to 100;
	signal horO: natural range 0 to 24;
	signal minO: natural range 0 to 60;
	
	begin
		process(clk) is
			begin
				--RELÓGIO--
				if rising_edge(clk) and not(cnt = 1) then
					msc <= msc + 1;
					if msc = freq - 1 then
						msc <= 0;
						sec <= sec + 1;
					end if;
					if sec = 60 then
						sec <= 0;
						min <= min + 1;
					end if;
					if min = 60 then
						min <= 0;
						hor <= hor + 1;
					end if;
					if hor = 24 then
						hor <= 0;
						dia <= dia + 1;
					end if;
					-- Dias
					if (dia = 29 and mes = 2 and not(ano rem 4 = 0)) or (dia = 30 and mes = 2 and ano rem 4 = 0) then
						dia <= 1;
						mes <= 3;
					elsif dia = 31 and (mes = 4 or mes = 6 or mes = 9 or mes = 11) then
						dia <= 1;
						mes <= mes + 1;
					elsif dia = 32 then
						dia <= 1;
						mes <= mes + 1;
					end if;
					if mes = 13 then
						mes <= 1;
						ano <= ano + 1;
					end if;
				end if;
			--EDIÇÃO--
				
			end process;	
			
			process(sel) is
				begin
				if rising_edge(sel) then
					if data = '0' then
						case E is
							when H => E <= Mi;
							when others => E <= H;
						end case;
					elsif data = '1' then
						case E is
							when D => E <= Me;
							when Me => E <= A;
							when others => E <= D;
						end case;
					end if;
				end if;
			end process;
			
			process(add) is
				begin
					if rising_edge(add) then
						case E is
							when H 	=>
								horO <= horO + 1;
								if horO > 24 - hor then
									horO <= 0;
								end if;
							when Mi 	=>
								minO <= minO + 1;
								if minO > 60 - min then
									minO <= 0;
								end if;
							when D 	=>
								diaO <= diaO + 1;
								if (diaO > 28 - dia and mes = 2 and not(ano rem 4 = 0)) or (diaO > 29 - dia and mes = 2 and ano rem 4 = 0) then
									diaO <= 0;
								elsif diaO > 30 - dia and (mes = 4 or mes = 6 or mes = 9 or mes = 11) then
									diaO <= 0;
								elsif dia > 31 - dia then
									diaO <= 0;
								end if;
							when Me 	=> 
								mesO <= mesO + 1;
								if mesO > 12 - mes then
									mesO <= 0;
								end if;
							when A 	=> 
								anoO <= anoO + 1;
							end case;			
					end if;	
			end process;
			
			process(clk) is
			begin
			-- AQUI COMEÇAM OS DISPLAYS --
				if rising_edge(clk) and data = '0' then -- hora
						horF <= hor + horO;
							if horF = 24 then
								horF <= 0;
							end if;
						if horF = 0 then
							  disp1 <= "11000000";
							  disp2 <= "11000000";
						elsif horF = 1 then		
							  disp1 <= "11000000";
							  disp2 <= "11111001";
						elsif horF = 2 then				 
							  disp1 <= "11000000";
							  disp2 <= "10100100";
						elsif horF = 3 then				 
							  disp1 <= "11000000";
							  disp2 <= "10110000";
						elsif horF = 4 then				 
							  disp1 <= "11000000";
							  disp2 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif horF = 5 then				 
							  disp1 <= "11000000";
							  disp2 <= "10010010";
						elsif horF = 6 then				 
							  disp1 <= "11000000";
							  disp2 <= "10000010";
						elsif horF = 7 then				 
							  disp1 <= "11000000";
							  disp2 <= "11111000";
						elsif horF = 8 then				 
							  disp1 <= "11000000";
							  disp2 <= "10000000";
						elsif horF = 9 then				 
							  disp1 <= "11000000";
							  disp2 <= "10011000";
						--10---------------------------------------------------------------------
						elsif horF = 10 then				 
							  disp1 <= "11111001";
							  disp2 <= "11000000";
						elsif horF = 11 then				 
							  disp1 <= "11111001";
							  disp2 <= "11111001";
						elsif horF = 12 then				 
							  disp1 <= "11111001";
							  disp2 <= "10100100";
						elsif horF = 13 then				 
							  disp1 <= "11111001";
							  disp2 <= "10110000";
						elsif horF = 14 then				 
							  disp1 <= "11111001";
							  disp2 <= "10011001";
						 --15-----------------------------------------------------
						elsif horF = 15 then				 
							  disp1 <= "11111001";
							  disp2 <= "10010010";
						elsif horF = 16 then				 
							  disp1 <= "11111001";
							  disp2 <= "10000010";
						elsif horF = 17 then				 
							  disp1 <= "11111001";
							  disp2 <= "11111000";
						elsif horF = 18 then				 
							  disp1 <= "11111001";
							  disp2 <= "10000000";
						elsif horF = 19 then				 
							  disp1 <= "11111001";
							  disp2 <= "10011000";
						 ---20----------------------------------------------------
						elsif horF = 20 then				 
							  disp1 <= "10100100";
							  disp2 <= "11000000";
						elsif horF = 21 then				 
							  disp1 <= "10100100";
							  disp2 <= "11111001";
						elsif horF = 22 then				 
							  disp1 <= "10100100";
							  disp2 <= "10100100";
						elsif horF = 23 then                
							  disp1 <= "10100100";
							  disp2 <= "10110000";
						end if; -- acabou as horas
						-----------------------------------------------------------
						minF <= min + minO;
								if minF = 60 then
									minF <= 0;
								end if;
						if minF = 0 then
							  disp3 <= "11000000";
							  disp4 <= "11000000";
						elsif minF = 1 then		
							  disp3 <= "11000000";
							  disp4 <= "11111001";
						elsif minF = 2 then				 
							  disp3 <= "11000000";
							  disp4 <= "10100100";
						elsif minF = 3 then				 
							  disp3 <= "11000000";
							  disp4 <= "10110000";
						elsif minF = 4 then				 
							  disp3 <= "11000000";
							  disp4 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif minF = 5 then				 
							  disp3 <= "11000000";
							  disp4 <= "10010010";
						elsif minF = 6 then				 
							  disp3 <= "11000000";
							  disp4 <= "10000010";
						elsif minF = 7 then				 
							  disp3 <= "11000000";
							  disp4 <= "11111000";
						elsif minF = 8 then				 
							  disp3 <= "11000000";
							  disp4 <= "10000000";
						elsif minF = 9 then				 
							  disp3 <= "11000000";
							  disp4 <= "10011000";
						--10---------------------------------------------------------------------
						elsif minF = 10 then				 
							  disp3 <= "11111001";
							  disp4 <= "11000000";
						elsif minF = 11 then				 
							  disp3 <= "11111001";
							  disp4 <= "11111001";
						elsif minF = 12 then				 
							  disp3 <= "11111001";
							  disp4 <= "10100100";
						elsif minF = 13 then				 
							  disp3 <= "11111001";
							  disp4 <= "10110000";
						elsif minF = 14 then				 
							  disp3 <= "11111001";
							  disp4 <= "10011001";
						 --15-----------------------------------------------------
						elsif minF = 15 then				 
							  disp3 <= "11111001";
							  disp4 <= "10010010";
						elsif minF = 16 then				 
							  disp3 <= "11111001";
							  disp4 <= "10000010";
						elsif minF = 17 then				 
							  disp3 <= "11111001";
							  disp4 <= "11111000";
						elsif minF = 18 then				 
							  disp3 <= "11111001";
							  disp4 <= "10000000";
						elsif minF = 19 then				 
							  disp3 <= "11111001";
							  disp4 <= "10011000";
						 ---20----------------------------------------------------
						elsif minF = 20 then				 
							  disp3 <= "10100100";
							  disp4 <= "11000000";
						elsif minF = 21 then				 
							  disp3 <= "10100100";
							  disp4 <= "11111001";
						elsif minF = 22 then				 
							  disp3 <= "10100100";
							  disp4 <= "10100100";
						elsif minF = 23 then                
							  disp3 <= "10100100";
							  disp4 <= "10110000";
						elsif minF = 24 then
							  disp3 <= "10100100";
							  disp4 <= "10011001";
			---25-----------------------------------------------------
						elsif minF = 25 then               
							  disp3 <= "10100100";
							  disp4 <= "10010010";
						elsif minF = 26 then                
							  disp3 <= "10100100";
							  disp4 <= "10000010";
						elsif minF = 27 then               
							  disp3 <= "10100100";
							  disp4 <= "11111000";
						elsif minF = 28 then                
							  disp3 <= "10100100";
							  disp4 <= "10000000";
						elsif minF = 29 then               
							  disp3 <= "10100100";
							  disp4 <= "10011000";
						---30------------------------------------------------------
						elsif minF = 30 then
							  disp3 <= "10110000";
							  disp4 <= "11000000";
						elsif minF = 31 then
							  disp3 <= "10110000";
							  disp4 <= "11111001";
						elsif minF = 32 then
							  disp3 <= "10110000";
							  disp4 <= "10100100";
						elsif minF = 33 then
							  disp3 <= "10110000";
							  disp4 <= "10110000";
						elsif  minF = 34 then
							  disp3 <= "10110000";
							  disp4 <= "10011001";
						---35------------------------------------------------------
						elsif minF = 35 then
							  disp3 <= "10110000";
							  disp4 <= "10010010";
						elsif minF = 36 then
							  disp3 <= "10110000";
							  disp4 <= "10000010";
						elsif minF = 37 then
							  disp3 <= "10110000";
							  disp4 <= "11111000";
						elsif minF = 38 then
							  disp3 <= "10110000";
							  disp4 <= "10000000";
						elsif minF = 39 then
							  disp3 <= "10110000";
							  disp4 <= "10011000";
						--------------------- 40------------------------------------
						elsif minF = 40 then --40
							  disp3 <= "10011001";
							  disp4 <= "11000000";
						elsif minF = 41 then --41
							  disp3 <= "10011001";
							  disp4 <= "11111001";
						elsif minF = 42 then --42
							  disp3 <= "10011001";
							  disp4 <= "10100100";
						elsif minF = 43 then --43
							  disp3 <= "10011001";
							  disp4 <= "10110000";
						elsif minF = 44 then --44
							  disp3 <= "10011001";
							  disp4 <= "10011001";
						--------------------- 45-------------------------------------
						elsif minF = 45 then --45
							  disp3 <= "10011001";
							  disp4 <= "10010010";
						elsif minF = 46 then --46
							  disp3 <= "10011001";
							  disp4 <= "10000010";
						elsif minF = 47 then --47
							  disp3 <= "10011001";
							  disp4 <= "11111000";    
						elsif minF = 48 then --48
							  disp3 <= "10011001";
							  disp4 <= "10000000";
						elsif minF = 49 then --49
							  disp3 <= "10011001";
							  disp4 <= "10011000";
						--------------------- 50--------------------------------------			
						elsif minF = 50 then --50
							  disp3 <= "10010010";
							  disp4 <= "11000000";
						elsif minF = 51 then --51
							  disp3 <= "10010010";
							  disp4 <= "11111001";
						elsif minF = 52 then --52
							  disp3 <= "10010010";
							  disp4 <= "10100100";
						elsif minF = 53 then --53
							  disp3 <= "10010010";
							  disp4 <= "10110000";    
						elsif minF = 54 then --54
							  disp3 <= "10010010";
							  disp4 <= "10011001";
						--------------------- 55--------------------------------------
						elsif minF = 55 then --55
							  disp3 <= "10010010";
							  disp4 <= "10010010";
						elsif minF = 56 then --56
							  disp3 <= "10010010";
							  disp4 <= "10000010";    
						elsif minF = 57 then --57
							  disp3 <= "10010010";
							  disp4 <= "11111000";
						elsif minF = 58 then --58
							  disp3 <= "10010010";
							  disp4 <= "10000000";
						elsif minF = 59 then --59
							  disp3 <= "10010010";
							  disp4 <= "10011000";
						---------------------60--------------------------------------
						else --60
							  disp3 <= "10000010";
							  disp4 <= "11000000";
						end if; -- acabou os minutos
						if sec = 0 then
							  disp5 <= "11000000";
							  disp6 <= "11000000";
						elsif sec = 1 then		
							  disp5 <= "11000000";
							  disp6 <= "11111001";
						elsif sec = 2 then				 
							  disp5 <= "11000000";
							  disp6 <= "10100100";
						elsif sec = 3 then				 
							  disp5 <= "11000000";
							  disp6 <= "10110000";
						elsif sec = 4 then				 
							  disp5 <= "11000000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif sec = 5 then				 
							  disp5 <= "11000000";
							  disp6 <= "10010010";
						elsif sec = 6 then				 
							  disp5 <= "11000000";
							  disp6 <= "10000010";
						elsif sec = 7 then				 
							  disp5 <= "11000000";
							  disp6 <= "11111000";
						elsif sec = 8 then				 
							  disp5 <= "11000000";
							  disp6 <= "10000000";
						elsif sec = 9 then				 
							  disp5 <= "11000000";
							  disp6 <= "10011000";
						--10---------------------------------------------------------------------
						elsif sec = 10 then				 
							  disp5 <= "11111001";
							  disp6 <= "11000000";
						elsif sec = 11 then				 
							  disp5 <= "11111001";
							  disp6 <= "11111001";
						elsif sec = 12 then				 
							  disp5 <= "11111001";
							  disp6 <= "10100100";
						elsif sec = 13 then				 
							  disp5 <= "11111001";
							  disp6 <= "10110000";
						elsif sec = 14 then				 
							  disp5 <= "11111001";
							  disp6 <= "10011001";
						 --15-----------------------------------------------------
						elsif sec = 15 then				 
							  disp5 <= "11111001";
							  disp6 <= "10010010";
						elsif sec = 16 then				 
							  disp5 <= "11111001";
							  disp6 <= "10000010";
						elsif sec = 17 then				 
							  disp5 <= "11111001";
							  disp6 <= "11111000";
						elsif sec = 18 then				 
							  disp5 <= "11111001";
							  disp6 <= "10000000";
						elsif sec = 19 then				 
							  disp5 <= "11111001";
							  disp6 <= "10011000";
						 ---20----------------------------------------------------
						elsif sec = 20 then				 
							  disp5 <= "10100100";
							  disp6 <= "11000000";
						elsif sec = 21 then				 
							  disp5 <= "10100100";
							  disp6 <= "11111001";
						elsif sec = 22 then				 
							  disp5 <= "10100100";
							  disp6 <= "10100100";
						elsif sec = 23 then                
							  disp5 <= "10100100";
							  disp6 <= "10110000";
						elsif sec = 24 then
							  disp5 <= "10100100";
							  disp6 <= "10011001";
			---25-----------------------------------------------------
						elsif sec = 25 then               
							  disp5 <= "10100100";
							  disp6 <= "10010010";
						elsif sec = 26 then                
							  disp5 <= "10100100";
							  disp6 <= "10000010";
						elsif sec = 27 then               
							  disp5 <= "10100100";
							  disp6 <= "11111000";
						elsif sec = 28 then                
							  disp5 <= "10100100";
							  disp6 <= "10000000";
						elsif sec = 29 then               
							  disp5 <= "10100100";
							  disp6 <= "10011000";
						---30------------------------------------------------------
						elsif sec = 30 then
							  disp5 <= "10110000";
							  disp6 <= "11000000";
						elsif sec = 31 then
							  disp5 <= "10110000";
							  disp6 <= "11111001";
						elsif sec = 32 then
							  disp5 <= "10110000";
							  disp6 <= "10100100";
						elsif sec = 33 then
							  disp5 <= "10110000";
							  disp6 <= "10110000";
						elsif  sec = 34 then
							  disp5 <= "10110000";
							  disp6 <= "10011001";
						---35------------------------------------------------------
						elsif sec = 35 then
							  disp5 <= "10110000";
							  disp6 <= "10010010";
						elsif sec = 36 then
							  disp5 <= "10110000";
							  disp6 <= "10000010";
						elsif sec = 37 then
							  disp5 <= "10110000";
							  disp6 <= "11111000";
						elsif sec = 38 then
							  disp5 <= "10110000";
							  disp6 <= "10000000";
						elsif sec = 39 then
							  disp5 <= "10110000";
							  disp6 <= "10011000";
						--------------------- 40------------------------------------
						elsif sec = 40 then --40
							  disp5 <= "10011001";
							  disp6 <= "11000000";
						elsif sec = 41 then --41
							  disp5 <= "10011001";
							  disp6 <= "11111001";
						elsif sec = 42 then --42
							  disp5 <= "10011001";
							  disp6 <= "10100100";
						elsif sec = 43 then --43
							  disp5 <= "10011001";
							  disp6 <= "10110000";
						elsif sec = 44 then --44
							  disp5 <= "10011001";
							  disp6 <= "10011001";
						--------------------- 45-------------------------------------
						elsif sec = 45 then --45
							  disp5 <= "10011001";
							  disp6 <= "10010010";
						elsif sec = 46 then --46
							  disp5 <= "10011001";
							  disp6 <= "10000010";
						elsif sec = 47 then --47
							  disp5 <= "10011001";
							  disp6 <= "11111000";    
						elsif sec = 48 then --48
							  disp5 <= "10011001";
							  disp6 <= "10000000";
						elsif sec = 49 then --49
							  disp5 <= "10011001";
							  disp6 <= "10011000";
						--------------------- 50--------------------------------------			
						elsif sec = 50 then --50
							  disp5 <= "10010010";
							  disp6 <= "11000000";
						elsif sec = 51 then --51
							  disp5 <= "10010010";
							  disp6 <= "11111001";
						elsif sec = 52 then --52
							  disp5 <= "10010010";
							  disp6 <= "10100100";
						elsif sec = 53 then --53
							  disp5 <= "10010010";
							  disp6 <= "10110000";    
						elsif sec = 54 then --54
							  disp5 <= "10010010";
							  disp6 <= "10011001";
						--------------------- 55--------------------------------------
				
					elsif sec = 55 then --55
							  disp5 <= "10010010";
							  disp6 <= "10010010";
						elsif sec = 56 then --56
							  disp5 <= "10010010";
							  disp6 <= "10000010";    
						elsif sec = 57 then --57
							  disp5 <= "10010010";
							  disp6 <= "11111000";
						elsif sec = 58 then --58
							  disp5 <= "10010010";
							  disp6 <= "10000000";
						elsif sec = 59 then --59
							  disp5 <= "10010010";
							  disp6 <= "10011000";
						---------------------60--------------------------------------
						else --60
							  disp5 <= "10000010";
							  disp6 <= "11000000";
						end if; -- acabou os minutos
				elsif rising_edge(clk) and data = '1' then -- DIAAAAA ____________________________%%%%%%%%%%%%_____________$$$$$$$$$$__________#########3
						diaF <= dia + diaO;
						if (diaF = 29 and mes = 2 and not(ano rem 4 = 0)) or (diaF = 30 and mes = 2 and ano rem 4 = 0) then
							diaF <= 1;
						elsif diaF = 31 and (mes = 4 or mes = 6 or mes = 9 or mes = 11) then
							diaF <= 1;
						elsif diaF = 32 then
							diaF <= 1;
						end if;
						if diaF = 1 then		
							  disp1 <= "11000000";
							  disp2 <= "11111001";
						elsif diaF = 2 then				 
							  disp1 <= "11000000";
							  disp2 <= "10100100";
						elsif diaF = 3 then				 
							  disp1 <= "11000000";
							  disp2 <= "10110000";
						elsif diaF = 4 then				 
							  disp1 <= "11000000";
							  disp2 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif diaF = 5 then				 
							  disp1 <= "11000000";
							  disp2 <= "10010010";
						elsif diaF = 6 then				 
							  disp1 <= "11000000";
							  disp2 <= "10000010";
						elsif diaF = 7 then				 
							  disp1 <= "11000000";
							  disp2 <= "11111000";
						elsif diaF = 8 then				 
							  disp1 <= "11000000";
							  disp2 <= "10000000";
						elsif diaF = 9 then				 
							  disp1 <= "11000000";
							  disp2 <= "10011000";
						--10---------------------------------------------------------------------
						elsif diaF = 10 then				 
							  disp1 <= "11111001";
							  disp2 <= "11000000";
						elsif diaF = 11 then				 
							  disp1 <= "11111001";
							  disp2 <= "11111001";
						elsif diaF = 12 then				 
							  disp1 <= "11111001";
							  disp2 <= "10100100";
						elsif diaF = 13 then				 
							  disp1 <= "11111001";
							  disp2 <= "10110000";
						elsif diaF = 14 then				 
							  disp1 <= "11111001";
							  disp2 <= "10011001";
						 --15-----------------------------------------------------
						elsif diaF = 15 then				 
							  disp1 <= "11111001";
							  disp2 <= "10010010";
						elsif diaF = 16 then				 
							  disp1 <= "11111001";
							  disp2 <= "10000010";
						elsif diaF = 17 then				 
							  disp1 <= "11111001";
							  disp2 <= "11111000";
						elsif diaF = 18 then				 
							  disp1 <= "11111001";
							  disp2 <= "10000000";
						elsif diaF = 19 then				 
							  disp1 <= "11111001";
							  disp2 <= "10011000";
						 ---20----------------------------------------------------
						elsif diaF = 20 then				 
							  disp1 <= "10100100";
							  disp2 <= "11000000";
						elsif diaF = 21 then				 
							  disp1 <= "10100100";
							  disp2 <= "11111001";
						elsif diaF = 22 then				 
							  disp1 <= "10100100";
							  disp2 <= "10100100";
						elsif diaF = 23 then                
							  disp1 <= "10100100";
							  disp2 <= "10110000";
						elsif diaF = 24 then
							  disp1 <= "10100100";
							  disp2 <= "10011001";
						---25-----------------------------------------------------
						elsif diaF = 25 then               
							  disp1 <= "10100100";
							  disp2 <= "10010010";
						elsif diaF = 26 then                
							  disp1 <= "10100100";
							  disp2 <= "10000010";
						elsif diaF = 27 then               
							  disp1 <= "10100100";
							  disp2 <= "11111000";
						elsif diaF = 28 then                
							  disp1 <= "10100100";
							  disp2 <= "10000000";
						elsif diaF = 29 then               
							  disp1 <= "10100100";
							  disp2 <= "10011000";
						---30------------------------------------------------------
						elsif diaF = 30 then
							  disp1 <= "10110000";
							  disp2 <= "11000000";
						else 
							  disp1 <= "10110000";
							  disp2 <= "11111001";
						end if; -- acabou os dias
						
						-----------------------------------------------------------
						mesF <= mes + mesO;
						if mesF = 13 then
							mesF <= 1;
						end if;
						if mesF = 1 then		
							  disp3 <= "11000000";
							  disp4 <= "11111001";
						elsif mesF = 2 then				 
							  disp3 <= "11000000";
							  disp4 <= "10100100";
						elsif mesF = 3 then				 
							  disp3 <= "11000000";
							  disp4 <= "10110000";
						elsif mesF = 4 then				 
							  disp3 <= "11000000";
							  disp4 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif mesF = 5 then				 
							  disp3 <= "11000000";
							  disp4 <= "10010010";
						elsif mesF = 6 then				 
							  disp3 <= "11000000";
							  disp4 <= "10000010";
						elsif mesF = 7 then				 
							  disp3 <= "11000000";
							  disp4 <= "11111000";
						elsif mesF = 8 then				 
							  disp3 <= "11000000";
							  disp4 <= "10000000";
						elsif mesF = 9 then				 
							  disp3 <= "11000000";
							  disp4 <= "10011000";
						--10---------------------------------------------------------------------
						elsif mesF = 10 then				 
							  disp3 <= "11111001";
							  disp4 <= "11000000";
						elsif mes = 11 then				 
							  disp3 <= "11111001";
							  disp4 <= "11111001";
						else				 
							  disp3 <= "11111001";
							  disp4 <= "10100100";
						end if; -- acabou os meses
						anoF <= ano + anoO;
						if anoF = 100 then
							anoF <= 0;
						end if;							
						if anoF = 0 then
							  disp5 <= "11000000";
							  disp6 <= "11000000";
						elsif anoF = 1 then		
							  disp5 <= "11000000";
							  disp6 <= "11111001";
						elsif anoF = 2 then				 
							  disp5 <= "11000000";
							  disp6 <= "10100100";
						elsif anoF = 3 then				 
							  disp5 <= "11000000";
							  disp6 <= "10110000";
						elsif anoF = 4 then				 
							  disp5 <= "11000000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif anoF = 5 then				 
							  disp5 <= "11000000";
							  disp6 <= "10010010";
						elsif anoF = 6 then				 
							  disp5 <= "11000000";
							  disp6 <= "10000010";
						elsif anoF = 7 then				 
							  disp5 <= "11000000";
							  disp6 <= "11111000";
						elsif anoF = 8 then				 
							  disp5 <= "11000000";
							  disp6 <= "10000000";
						elsif anoF = 9 then				 
							  disp5 <= "11000000";
							  disp6 <= "10011000";
						--10---------------------------------------------------------------------
						elsif anoF = 10 then				 
							  disp5 <= "11111001";
							  disp6 <= "11000000";
						elsif anoF = 11 then				 
							  disp5 <= "11111001";
							  disp6 <= "11111001";
						elsif anoF = 12 then				 
							  disp5 <= "11111001";
							  disp6 <= "10100100";
						elsif anoF = 13 then				 
							  disp5 <= "11111001";
							  disp6 <= "10110000";
						elsif anoF = 14 then				 
							  disp5 <= "11111001";
							  disp6 <= "10011001";
						 --15-----------------------------------------------------
						elsif anoF = 15 then				 
							  disp5 <= "11111001";
							  disp6 <= "10010010";
						elsif anoF = 16 then				 
							  disp5 <= "11111001";
							  disp6 <= "10000010";
						elsif anoF = 17 then				 
							  disp5 <= "11111001";
							  disp6 <= "11111000";
						elsif anoF = 18 then				 
							  disp5 <= "11111001";
							  disp6 <= "10000000";
						elsif anoF = 19 then				 
							  disp5 <= "11111001";
							  disp6 <= "10011000";
						 ---20----------------------------------------------------
						elsif anoF = 20 then				 
							  disp5 <= "10100100";
							  disp6 <= "11000000";
						elsif anoF = 21 then				 
							  disp5 <= "10100100";
							  disp6 <= "11111001";
						elsif anoF = 22 then				 
							  disp5 <= "10100100";
							  disp6 <= "10100100";
						elsif anoF = 23 then                
							  disp5 <= "10100100";
							  disp6 <= "10110000";
						elsif anoF = 24 then
							  disp5 <= "10100100";
							  disp6 <= "10011001";
			---25-----------------------------------------------------
						elsif anoF = 25 then               
							  disp5 <= "10100100";
							  disp6 <= "10010010";
						elsif anoF = 26 then                
							  disp5 <= "10100100";
							  disp6 <= "10000010";
						elsif anoF = 27 then               
							  disp5 <= "10100100";
							  disp6 <= "11111000";
						elsif anoF = 28 then                
							  disp5 <= "10100100";
							  disp6 <= "10000000";
						elsif anoF = 29 then               
							  disp5 <= "10100100";
							  disp6 <= "10011000";
						---30------------------------------------------------------
						elsif anoF = 30 then
							  disp5 <= "10110000";
							  disp6 <= "11000000";
						elsif anoF = 31 then
							  disp5 <= "10110000";
							  disp6 <= "11111001";
						elsif anoF = 32 then
							  disp5 <= "10110000";
							  disp6 <= "10100100";
						elsif anoF = 33 then
							  disp5 <= "10110000";
							  disp6 <= "10110000";
						elsif  anoF = 34 then
							  disp5 <= "10110000";
							  disp6 <= "10011001";
						---35------------------------------------------------------
						elsif anoF = 35 then
							  disp5 <= "10110000";
							  disp6 <= "10010010";
						elsif anoF = 36 then
							  disp5 <= "10110000";
							  disp6 <= "10000010";
						elsif anoF = 37 then
							  disp5 <= "10110000";
							  disp6 <= "11111000";
						elsif anoF = 38 then
							  disp5 <= "10110000";
							  disp6 <= "10000000";
						elsif anoF = 39 then
							  disp5 <= "10110000";
							  disp6 <= "10011000";
						--------------------- 40------------------------------------
						elsif anoF = 40 then --40
							  disp5 <= "10011001";
							  disp6 <= "11000000";
						elsif anoF = 41 then --41
							  disp5 <= "10011001";
							  disp6 <= "11111001";
						elsif anoF = 42 then --42
							  disp5 <= "10011001";
							  disp6 <= "10100100";
						elsif anoF = 43 then --43
							  disp5 <= "10011001";
							  disp6 <= "10110000";
						elsif anoF = 44 then --44
							  disp5 <= "10011001";
							  disp6 <= "10011001";
						--------------------- 45-------------------------------------
						elsif anoF = 45 then --45
							  disp5 <= "10011001";
							  disp6 <= "10010010";
						elsif anoF = 46 then --46
							  disp5 <= "10011001";
							  disp6 <= "10000010";
						elsif anoF = 47 then --47
							  disp5 <= "10011001";
							  disp6 <= "11111000";    
						elsif anoF = 48 then --48
							  disp5 <= "10011001";
							  disp6 <= "10000000";
						elsif anoF = 49 then --49
							  disp5 <= "10011001";
							  disp6 <= "10011000";
						--------------------- 50--------------------------------------			
						elsif anoF = 50 then --50
							  disp5 <= "10010010";
							  disp6 <= "11000000";
						elsif anoF = 51 then --51
							  disp5 <= "10010010";
							  disp6 <= "11111001";
						elsif anoF = 52 then --52
							  disp5 <= "10010010";
							  disp6 <= "10100100";
						elsif anoF = 53 then --53
							  disp5 <= "10010010";
							  disp6 <= "10110000";    
						elsif anoF = 54 then --54
							  disp5 <= "10010010";
							  disp6 <= "10011001";
						--------------------- 55--------------------------------------
						elsif anoF = 55 then --55
							  disp5 <= "10010010";
							  disp6 <= "10010010";
						elsif anoF = 56 then --56
							  disp5 <= "10010010";
							  disp6 <= "10000010";    
						elsif anoF = 57 then --57
							  disp5 <= "10010010";
							  disp6 <= "11111000";
						elsif anoF = 58 then --58
							  disp5 <= "10010010";
							  disp6 <= "10000000";
						elsif anoF = 59 then --59
							  disp5 <= "10010010";
							  disp6 <= "10011000";
						---------------------60--------------------------------------
						elsif anoF = 60 then --60
							  disp5 <= "10000010";
							  disp6 <= "11000000";
						elsif anoF = 61 then		
							  disp5 <= "10000010";
							  disp6 <= "11111001";
						elsif anoF = 62 then				 
							  disp5 <= "10000010";
							  disp6 <= "10100100";
						elsif anoF = 63 then				 
							  disp5 <= "10000010";
							  disp6 <= "10110000";
						elsif anoF = 64 then				 
							  disp5 <= "10000010";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif anoF = 65 then				 
							  disp5 <= "10000010";
							  disp6 <= "10010010";
						elsif anoF = 66 then				 
							  disp5 <= "10000010";
							  disp6 <= "10000010";
						elsif anoF = 67 then				 
							  disp5 <= "10000010";
							  disp6 <= "11111000";
						elsif anoF = 68 then				 
							  disp5 <= "10000010";
							  disp6 <= "10000000";
						elsif anoF = 69 then				 
							  disp5 <= "10000010";
							  disp6 <= "10011000";
						
						---------------------70--------------------------------------
						elsif anoF = 70 then --70
							  disp5 <= "11111000";
							  disp6 <= "11000000";
						elsif anoF = 71 then		
							  disp5 <= "11111000";
							  disp6 <= "11111001";
						elsif anoF = 72 then				 
							  disp5 <= "11111000";
							  disp6 <= "10100100";
						elsif anoF = 73 then				 
							  disp5 <= "11111000";
							  disp6 <= "10110000";
						elsif anoF = 74 then				 
							  disp5 <= "11111000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif anoF = 75 then				 
							  disp5 <= "11111000";
							  disp6 <= "10010010";
						elsif anoF = 76 then				 
							  disp5 <= "11111000";
							  disp6 <= "10000010";
						elsif anoF = 67 then				 
							  disp5 <= "11111000";
							  disp6 <= "11111000";
						elsif anoF = 78 then				 
							  disp5 <= "11111000";
							  disp6 <= "10000000";
						elsif anoF = 79 then				 
							  disp5 <= "11111000";
							  disp6 <= "10011000";
						---------------------80--------------------------------------
						elsif anoF = 80 then --80
							  disp5 <= "10000000";
							  disp6 <= "11000000";
						elsif anoF = 81 then		
							  disp5 <= "10000000";
							  disp6 <= "11111001";
						elsif anoF = 82 then				 
							  disp5 <= "10000000";
							  disp6 <= "10100100";
						elsif anoF = 83 then				 
							  disp5 <= "10000000";
							  disp6 <= "10110000";
						elsif anoF = 84 then				 
							  disp5 <= "10000000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif anoF = 85 then				 
							  disp5 <= "10000000";
							  disp6 <= "10010010";
						elsif anoF = 86 then				 
							  disp5 <= "10000000";
							  disp6 <= "10000010";
						elsif anoF = 87 then				 
							  disp5 <= "10000000";
							  disp6 <= "11111000";
						elsif anoF = 88 then				 
							  disp5 <= "10000000";
							  disp6 <= "10000000";
						elsif anoF = 89 then				 
							  disp5 <= "10000000";
							  disp6 <= "10011000";
						---------------------90--------------------------------------
						elsif anoF = 90 then
							  disp5 <= "10011000";
							  disp6 <= "11000000";
						elsif anoF = 91 then		
							  disp5 <= "10011000";
							  disp6 <= "11111001";
						elsif anoF = 92 then				 
							  disp5 <= "10011000";
							  disp6 <= "10100100";
						elsif anoF = 93 then				 
							  disp5 <= "10011000";
							  disp6 <= "10110000";
						elsif anoF = 94 then				 
							  disp5 <= "10011000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif anoF = 95 then				 
							  disp5 <= "10011000";
							  disp6 <= "10010010";
						elsif anoF = 96 then				 
							  disp5 <= "10011000";
							  disp6 <= "10000010";
						elsif anoF = 97 then				 
							  disp5 <= "10011000";
							  disp6 <= "11111000";
						elsif anoF = 98 then				 
							  disp5 <= "10011000";
							  disp6 <= "10000000";
						else				 
							  disp5 <= "10011000";
							  disp6 <= "10011000";
						end if; -- acabou os anos
				end if;
				
				case E is
					when D|H =>
						disp2(7) <= '0';
						disp4(7) <= '1';
						disp6(7) <= '1';
					when Me|Mi => 
						disp2(7) <= '1';
						disp4(7) <= '0';
						disp6(7) <= '1';
					when A =>
						disp2(7) <= '1';
						disp4(7) <= '1';
						disp6(7) <= '0';
				end case;
			end process;
		
			
end logic;
