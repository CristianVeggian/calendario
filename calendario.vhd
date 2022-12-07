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
	
	type EH_type is (H, M, S);
	type ED_type is (D, M, A);
	
	signal EH: EH_type;
	signal ED: ED_type;
	signal cont: std_logic := '0';
	signal msc: integer := 0;
	signal dia: positive range 1 to 32 := 11;
	signal mes: positive range 1 to 13 := 9;
	signal ano: natural range 0 to 99 := 22;
	signal hor: natural range 0 to 24 := 12;
	signal min: natural range 0 to 60 := 30;
	signal sec: natural range 0 to 60 := 15;
	
	begin
		process(clk, data, sel, add)
			begin
				if sel = '0' and cont = '0' then
					cont <= '1';
					if data = '0' then
						if EH = H then
							EH <= M;
						elsif EH = M then
							EH <= S;
						else
							EH <= H;
						end if;
					else
						if ED = D then
							ED <= M;
						elsif ED = M then
							ED <= A;
						else
							ED <= D;
						end if;
					end if;
				elsif add = '0' and cont = '0' then
					cont <= '1';
					if data = '0' then
						if EH = H then
							hor <= hor + 1;
							if hor = 24 then
								hor <= 0;
							end if;
						elsif EH = M then
							min <= min + 1;
							if min = 60 then
								min <= 0;
							end if;
						else
							sec <= sec + 1;
							if sec = 60 then
								sec <= 0;
							end if;
						end if;
					else
						if ED = D then
							dia <= dia + 1;
							if (dia = 29 and mes = 2 and not(ano rem 4 = 0)) or (dia = 30 and mes = 2 and ano rem 4 = 0) then
								dia <= 1;
							elsif dia = 31 and (mes = 4 or mes = 6 or mes = 9 or mes = 11) then
								dia <= 1;
							elsif dia = 32 then
								dia <= 1;
							end if;
						elsif ED = M then
							mes <= mes + 1;
							if mes = 13 then
								mes <= 1;
							end if;
						else
							ano <= ano + 1;
						end if;
					end if;
				elsif rising_edge(clk) then
					cont <= '0';
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
			-- AQUI COMEÇAM OS DISPLAYS --
				if data = '0' then -- hora
						if hor = 0 then
							  disp1 <= "11000000";
							  disp2 <= "11000000";
						elsif hor = 1 then		
							  disp1 <= "11000000";
							  disp2 <= "11111001";
						elsif hor = 2 then				 
							  disp1 <= "11000000";
							  disp2 <= "10100100";
						elsif hor = 3 then				 
							  disp1 <= "11000000";
							  disp2 <= "10110000";
						elsif hor = 4 then				 
							  disp1 <= "11000000";
							  disp2 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif hor = 5 then				 
							  disp1 <= "11000000";
							  disp2 <= "10010010";
						elsif hor = 6 then				 
							  disp1 <= "11000000";
							  disp2 <= "10000010";
						elsif hor = 7 then				 
							  disp1 <= "11000000";
							  disp2 <= "11111000";
						elsif hor = 8 then				 
							  disp1 <= "11000000";
							  disp2 <= "10000000";
						elsif hor = 9 then				 
							  disp1 <= "11000000";
							  disp2 <= "10011000";
						--10---------------------------------------------------------------------
						elsif hor = 10 then				 
							  disp1 <= "11111001";
							  disp2 <= "11000000";
						elsif hor = 11 then				 
							  disp1 <= "11111001";
							  disp2 <= "11111001";
						elsif hor = 12 then				 
							  disp1 <= "11111001";
							  disp2 <= "10100100";
						elsif hor = 13 then				 
							  disp1 <= "11111001";
							  disp2 <= "10110000";
						elsif hor = 14 then				 
							  disp1 <= "11111001";
							  disp2 <= "10011001";
						 --15-----------------------------------------------------
						elsif hor = 15 then				 
							  disp1 <= "11111001";
							  disp2 <= "10010010";
						elsif hor = 16 then				 
							  disp1 <= "11111001";
							  disp2 <= "10000010";
						elsif hor = 17 then				 
							  disp1 <= "11111001";
							  disp2 <= "11111000";
						elsif hor = 18 then				 
							  disp1 <= "11111001";
							  disp2 <= "10000000";
						elsif hor = 19 then				 
							  disp1 <= "11111001";
							  disp2 <= "10011000";
						 ---20----------------------------------------------------
						elsif hor = 20 then				 
							  disp1 <= "10100100";
							  disp2 <= "11000000";
						elsif hor = 21 then				 
							  disp1 <= "10100100";
							  disp2 <= "11111001";
						elsif hor = 22 then				 
							  disp1 <= "10100100";
							  disp2 <= "10100100";
						elsif hor = 23 then                
							  disp1 <= "10100100";
							  disp2 <= "10110000";
						end if; -- acabou as horas
						
						-----------------------------------------------------------
						
						if min = 0 then
							  disp3 <= "11000000";
							  disp4 <= "11000000";
						elsif min = 1 then		
							  disp3 <= "11000000";
							  disp4 <= "11111001";
						elsif min = 2 then				 
							  disp3 <= "11000000";
							  disp4 <= "10100100";
						elsif min = 3 then				 
							  disp3 <= "11000000";
							  disp4 <= "10110000";
						elsif min = 4 then				 
							  disp3 <= "11000000";
							  disp4 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif min = 5 then				 
							  disp3 <= "11000000";
							  disp4 <= "10010010";
						elsif min = 6 then				 
							  disp3 <= "11000000";
							  disp4 <= "10000010";
						elsif min = 7 then				 
							  disp3 <= "11000000";
							  disp4 <= "11111000";
						elsif min = 8 then				 
							  disp3 <= "11000000";
							  disp4 <= "10000000";
						elsif min = 9 then				 
							  disp3 <= "11000000";
							  disp4 <= "10011000";
						--10---------------------------------------------------------------------
						elsif min = 10 then				 
							  disp3 <= "11111001";
							  disp4 <= "11000000";
						elsif min = 11 then				 
							  disp3 <= "11111001";
							  disp4 <= "11111001";
						elsif min = 12 then				 
							  disp3 <= "11111001";
							  disp4 <= "10100100";
						elsif min = 13 then				 
							  disp3 <= "11111001";
							  disp4 <= "10110000";
						elsif min = 14 then				 
							  disp3 <= "11111001";
							  disp4 <= "10011001";
						 --15-----------------------------------------------------
						elsif min = 15 then				 
							  disp3 <= "11111001";
							  disp4 <= "10010010";
						elsif min = 16 then				 
							  disp3 <= "11111001";
							  disp4 <= "10000010";
						elsif min = 17 then				 
							  disp3 <= "11111001";
							  disp4 <= "11111000";
						elsif min = 18 then				 
							  disp3 <= "11111001";
							  disp4 <= "10000000";
						elsif min = 19 then				 
							  disp3 <= "11111001";
							  disp4 <= "10011000";
						 ---20----------------------------------------------------
						elsif min = 20 then				 
							  disp3 <= "10100100";
							  disp4 <= "11000000";
						elsif min = 21 then				 
							  disp3 <= "10100100";
							  disp4 <= "11111001";
						elsif min = 22 then				 
							  disp3 <= "10100100";
							  disp4 <= "10100100";
						elsif min = 23 then                
							  disp3 <= "10100100";
							  disp4 <= "10110000";
						elsif min = 24 then
							  disp3 <= "10100100";
							  disp4 <= "10011001";
			---25-----------------------------------------------------
						elsif min = 25 then               
							  disp3 <= "10100100";
							  disp4 <= "10010010";
						elsif min = 26 then                
							  disp3 <= "10100100";
							  disp4 <= "10000010";
						elsif min = 27 then               
							  disp3 <= "10100100";
							  disp4 <= "11111000";
						elsif min = 28 then                
							  disp3 <= "10100100";
							  disp4 <= "10000000";
						elsif min = 29 then               
							  disp3 <= "10100100";
							  disp4 <= "10011000";
						---30------------------------------------------------------
						elsif min = 30 then
							  disp3 <= "10110000";
							  disp4 <= "11000000";
						elsif min = 31 then
							  disp3 <= "10110000";
							  disp4 <= "11111001";
						elsif min = 32 then
							  disp3 <= "10110000";
							  disp4 <= "10100100";
						elsif min = 33 then
							  disp3 <= "10110000";
							  disp4 <= "10110000";
						elsif  min = 34 then
							  disp3 <= "10110000";
							  disp4 <= "10011001";
						---35------------------------------------------------------
						elsif min = 35 then
							  disp3 <= "10110000";
							  disp4 <= "10010010";
						elsif min = 36 then
							  disp3 <= "10110000";
							  disp4 <= "10000010";
						elsif min = 37 then
							  disp3 <= "10110000";
							  disp4 <= "11111000";
						elsif min = 38 then
							  disp3 <= "10110000";
							  disp4 <= "10000000";
						elsif min = 39 then
							  disp3 <= "10110000";
							  disp4 <= "10011000";
						--------------------- 40------------------------------------
						elsif min = 40 then --40
							  disp3 <= "10011001";
							  disp4 <= "11000000";
						elsif min = 41 then --41
							  disp3 <= "10011001";
							  disp4 <= "11111001";
						elsif min = 42 then --42
							  disp3 <= "10011001";
							  disp4 <= "10100100";
						elsif min = 43 then --43
							  disp3 <= "10011001";
							  disp4 <= "10110000";
						elsif min = 44 then --44
							  disp3 <= "10011001";
							  disp4 <= "10011001";
						--------------------- 45-------------------------------------
						elsif min = 45 then --45
							  disp3 <= "10011001";
							  disp4 <= "10010010";
						elsif min = 46 then --46
							  disp3 <= "10011001";
							  disp4 <= "10000010";
						elsif min = 47 then --47
							  disp3 <= "10011001";
							  disp4 <= "11111000";    
						elsif min = 48 then --48
							  disp3 <= "10011001";
							  disp4 <= "10000000";
						elsif min = 49 then --49
							  disp3 <= "10011001";
							  disp4 <= "10011000";
						--------------------- 50--------------------------------------			
						elsif min = 50 then --50
							  disp3 <= "10010010";
							  disp4 <= "11000000";
						elsif min = 51 then --51
							  disp3 <= "10010010";
							  disp4 <= "11111001";
						elsif min = 52 then --52
							  disp3 <= "10010010";
							  disp4 <= "10100100";
						elsif min = 53 then --53
							  disp3 <= "10010010";
							  disp4 <= "10110000";    
						elsif min = 54 then --54
							  disp3 <= "10010010";
							  disp4 <= "10011001";
						--------------------- 55--------------------------------------
				
					elsif min = 55 then --55
							  disp3 <= "10010010";
							  disp4 <= "10010010";
						elsif min = 56 then --56
							  disp3 <= "10010010";
							  disp4 <= "10000010";    
						elsif min = 57 then --57
							  disp3 <= "10010010";
							  disp4 <= "11111000";
						elsif min = 58 then --58
							  disp3 <= "10010010";
							  disp4 <= "10000000";
						elsif min = 59 then --59
							  disp3 <= "10010010";
							  disp4 <= "10011000";
						---------------------60--------------------------------------
						elsif min = 60 then --60
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
						elsif sec = 60 then --60
							  disp5 <= "10000010";
							  disp6 <= "11000000";
						end if; -- acabou os minutos
				else -- DIAAAAA ____________________________%%%%%%%%%%%%_____________$$$$$$$$$$__________#########3
						if dia = 1 then		
							  disp1 <= "11000000";
							  disp2 <= "11111001";
						elsif dia = 2 then				 
							  disp1 <= "11000000";
							  disp2 <= "10100100";
						elsif dia = 3 then				 
							  disp1 <= "11000000";
							  disp2 <= "10110000";
						elsif dia = 4 then				 
							  disp1 <= "11000000";
							  disp2 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif dia = 5 then				 
							  disp1 <= "11000000";
							  disp2 <= "10010010";
						elsif dia = 6 then				 
							  disp1 <= "11000000";
							  disp2 <= "10000010";
						elsif dia = 7 then				 
							  disp1 <= "11000000";
							  disp2 <= "11111000";
						elsif dia = 8 then				 
							  disp1 <= "11000000";
							  disp2 <= "10000000";
						elsif dia = 9 then				 
							  disp1 <= "11000000";
							  disp2 <= "10011000";
						--10---------------------------------------------------------------------
						elsif dia = 10 then				 
							  disp1 <= "11111001";
							  disp2 <= "11000000";
						elsif dia = 11 then				 
							  disp1 <= "11111001";
							  disp2 <= "11111001";
						elsif dia = 12 then				 
							  disp1 <= "11111001";
							  disp2 <= "10100100";
						elsif dia = 13 then				 
							  disp1 <= "11111001";
							  disp2 <= "10110000";
						elsif dia = 14 then				 
							  disp1 <= "11111001";
							  disp2 <= "10011001";
						 --15-----------------------------------------------------
						elsif dia = 15 then				 
							  disp1 <= "11111001";
							  disp2 <= "10010010";
						elsif dia = 16 then				 
							  disp1 <= "11111001";
							  disp2 <= "10000010";
						elsif dia = 17 then				 
							  disp1 <= "11111001";
							  disp2 <= "11111000";
						elsif dia = 18 then				 
							  disp1 <= "11111001";
							  disp2 <= "10000000";
						elsif dia = 19 then				 
							  disp1 <= "11111001";
							  disp2 <= "10011000";
						 ---20----------------------------------------------------
						elsif dia = 20 then				 
							  disp1 <= "10100100";
							  disp2 <= "11000000";
						elsif dia = 21 then				 
							  disp1 <= "10100100";
							  disp2 <= "11111001";
						elsif dia = 22 then				 
							  disp1 <= "10100100";
							  disp2 <= "10100100";
						elsif dia = 23 then                
							  disp1 <= "10100100";
							  disp2 <= "10110000";
						elsif dia = 24 then
							  disp1 <= "10100100";
							  disp2 <= "10011001";
						---25-----------------------------------------------------
						elsif dia = 25 then               
							  disp1 <= "10100100";
							  disp2 <= "10010010";
						elsif dia = 26 then                
							  disp1 <= "10100100";
							  disp2 <= "10000010";
						elsif dia = 27 then               
							  disp1 <= "10100100";
							  disp2 <= "11111000";
						elsif dia = 28 then                
							  disp1 <= "10100100";
							  disp2 <= "10000000";
						elsif dia = 29 then               
							  disp1 <= "10100100";
							  disp2 <= "10011000";
						---30------------------------------------------------------
						elsif dia = 30 then
							  disp1 <= "10110000";
							  disp2 <= "11000000";
						elsif dia = 31 then
							  disp1 <= "10110000";
							  disp2 <= "11111001";
						end if; -- acabou as horas
						
						-----------------------------------------------------------
						if mes = 1 then		
							  disp3 <= "11000000";
							  disp4 <= "11111001";
						elsif mes = 2 then				 
							  disp3 <= "11000000";
							  disp4 <= "10100100";
						elsif mes = 3 then				 
							  disp3 <= "11000000";
							  disp4 <= "10110000";
						elsif mes = 4 then				 
							  disp3 <= "11000000";
							  disp4 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif mes = 5 then				 
							  disp3 <= "11000000";
							  disp4 <= "10010010";
						elsif mes = 6 then				 
							  disp3 <= "11000000";
							  disp4 <= "10000010";
						elsif mes = 7 then				 
							  disp3 <= "11000000";
							  disp4 <= "11111000";
						elsif mes = 8 then				 
							  disp3 <= "11000000";
							  disp4 <= "10000000";
						elsif mes = 9 then				 
							  disp3 <= "11000000";
							  disp4 <= "10011000";
						--10---------------------------------------------------------------------
						elsif mes = 10 then				 
							  disp3 <= "11111001";
							  disp4 <= "11000000";
						elsif mes = 11 then				 
							  disp3 <= "11111001";
							  disp4 <= "11111001";
						elsif mes = 12 then				 
							  disp3 <= "11111001";
							  disp4 <= "10100100";
						end if; -- acabou os meses
						if ano = 0 then
							  disp5 <= "11000000";
							  disp6 <= "11000000";
						elsif ano = 1 then		
							  disp5 <= "11000000";
							  disp6 <= "11111001";
						elsif ano = 2 then				 
							  disp5 <= "11000000";
							  disp6 <= "10100100";
						elsif ano = 3 then				 
							  disp5 <= "11000000";
							  disp6 <= "10110000";
						elsif ano = 4 then				 
							  disp5 <= "11000000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif ano = 5 then				 
							  disp5 <= "11000000";
							  disp6 <= "10010010";
						elsif ano = 6 then				 
							  disp5 <= "11000000";
							  disp6 <= "10000010";
						elsif ano = 7 then				 
							  disp5 <= "11000000";
							  disp6 <= "11111000";
						elsif ano = 8 then				 
							  disp5 <= "11000000";
							  disp6 <= "10000000";
						elsif ano = 9 then				 
							  disp5 <= "11000000";
							  disp6 <= "10011000";
						--10---------------------------------------------------------------------
						elsif ano = 10 then				 
							  disp5 <= "11111001";
							  disp6 <= "11000000";
						elsif ano = 11 then				 
							  disp5 <= "11111001";
							  disp6 <= "11111001";
						elsif ano = 12 then				 
							  disp5 <= "11111001";
							  disp6 <= "10100100";
						elsif ano = 13 then				 
							  disp5 <= "11111001";
							  disp6 <= "10110000";
						elsif ano = 14 then				 
							  disp5 <= "11111001";
							  disp6 <= "10011001";
						 --15-----------------------------------------------------
						elsif ano = 15 then				 
							  disp5 <= "11111001";
							  disp6 <= "10010010";
						elsif ano = 16 then				 
							  disp5 <= "11111001";
							  disp6 <= "10000010";
						elsif ano = 17 then				 
							  disp5 <= "11111001";
							  disp6 <= "11111000";
						elsif ano = 18 then				 
							  disp5 <= "11111001";
							  disp6 <= "10000000";
						elsif ano = 19 then				 
							  disp5 <= "11111001";
							  disp6 <= "10011000";
						 ---20----------------------------------------------------
						elsif ano = 20 then				 
							  disp5 <= "10100100";
							  disp6 <= "11000000";
						elsif ano = 21 then				 
							  disp5 <= "10100100";
							  disp6 <= "11111001";
						elsif ano = 22 then				 
							  disp5 <= "10100100";
							  disp6 <= "10100100";
						elsif ano = 23 then                
							  disp5 <= "10100100";
							  disp6 <= "10110000";
						elsif ano = 24 then
							  disp5 <= "10100100";
							  disp6 <= "10011001";
			---25-----------------------------------------------------
						elsif ano = 25 then               
							  disp5 <= "10100100";
							  disp6 <= "10010010";
						elsif ano = 26 then                
							  disp5 <= "10100100";
							  disp6 <= "10000010";
						elsif ano = 27 then               
							  disp5 <= "10100100";
							  disp6 <= "11111000";
						elsif ano = 28 then                
							  disp5 <= "10100100";
							  disp6 <= "10000000";
						elsif ano = 29 then               
							  disp5 <= "10100100";
							  disp6 <= "10011000";
						---30------------------------------------------------------
						elsif ano = 30 then
							  disp5 <= "10110000";
							  disp6 <= "11000000";
						elsif ano = 31 then
							  disp5 <= "10110000";
							  disp6 <= "11111001";
						elsif ano = 32 then
							  disp5 <= "10110000";
							  disp6 <= "10100100";
						elsif ano = 33 then
							  disp5 <= "10110000";
							  disp6 <= "10110000";
						elsif  ano = 34 then
							  disp5 <= "10110000";
							  disp6 <= "10011001";
						---35------------------------------------------------------
						elsif ano = 35 then
							  disp5 <= "10110000";
							  disp6 <= "10010010";
						elsif ano = 36 then
							  disp5 <= "10110000";
							  disp6 <= "10000010";
						elsif ano = 37 then
							  disp5 <= "10110000";
							  disp6 <= "11111000";
						elsif ano = 38 then
							  disp5 <= "10110000";
							  disp6 <= "10000000";
						elsif ano = 39 then
							  disp5 <= "10110000";
							  disp6 <= "10011000";
						--------------------- 40------------------------------------
						elsif ano = 40 then --40
							  disp5 <= "10011001";
							  disp6 <= "11000000";
						elsif ano = 41 then --41
							  disp5 <= "10011001";
							  disp6 <= "11111001";
						elsif ano = 42 then --42
							  disp5 <= "10011001";
							  disp6 <= "10100100";
						elsif ano = 43 then --43
							  disp5 <= "10011001";
							  disp6 <= "10110000";
						elsif ano = 44 then --44
							  disp5 <= "10011001";
							  disp6 <= "10011001";
						--------------------- 45-------------------------------------
						elsif ano = 45 then --45
							  disp5 <= "10011001";
							  disp6 <= "10010010";
						elsif ano = 46 then --46
							  disp5 <= "10011001";
							  disp6 <= "10000010";
						elsif ano = 47 then --47
							  disp5 <= "10011001";
							  disp6 <= "11111000";    
						elsif ano = 48 then --48
							  disp5 <= "10011001";
							  disp6 <= "10000000";
						elsif ano = 49 then --49
							  disp5 <= "10011001";
							  disp6 <= "10011000";
						--------------------- 50--------------------------------------			
						elsif ano = 50 then --50
							  disp5 <= "10010010";
							  disp6 <= "11000000";
						elsif ano = 51 then --51
							  disp5 <= "10010010";
							  disp6 <= "11111001";
						elsif ano = 52 then --52
							  disp5 <= "10010010";
							  disp6 <= "10100100";
						elsif ano = 53 then --53
							  disp5 <= "10010010";
							  disp6 <= "10110000";    
						elsif ano = 54 then --54
							  disp5 <= "10010010";
							  disp6 <= "10011001";
						--------------------- 55--------------------------------------
						elsif ano = 55 then --55
							  disp5 <= "10010010";
							  disp6 <= "10010010";
						elsif ano = 56 then --56
							  disp5 <= "10010010";
							  disp6 <= "10000010";    
						elsif ano = 57 then --57
							  disp5 <= "10010010";
							  disp6 <= "11111000";
						elsif ano = 58 then --58
							  disp5 <= "10010010";
							  disp6 <= "10000000";
						elsif ano = 59 then --59
							  disp5 <= "10010010";
							  disp6 <= "10011000";
						---------------------60--------------------------------------
						elsif ano = 60 then --60
							  disp5 <= "10000010";
							  disp6 <= "11000000";
						elsif ano = 61 then		
							  disp5 <= "10000010";
							  disp6 <= "11111001";
						elsif ano = 62 then				 
							  disp5 <= "10000010";
							  disp6 <= "10100100";
						elsif ano = 63 then				 
							  disp5 <= "10000010";
							  disp6 <= "10110000";
						elsif ano = 64 then				 
							  disp5 <= "10000010";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif ano = 65 then				 
							  disp5 <= "10000010";
							  disp6 <= "10010010";
						elsif ano = 66 then				 
							  disp5 <= "10000010";
							  disp6 <= "10000010";
						elsif ano = 67 then				 
							  disp5 <= "10000010";
							  disp6 <= "11111000";
						elsif ano = 68 then				 
							  disp5 <= "10000010";
							  disp6 <= "10000000";
						elsif ano = 69 then				 
							  disp5 <= "10000010";
							  disp6 <= "10011000";
						
						---------------------70--------------------------------------
						elsif ano = 70 then --70
							  disp5 <= "11111000";
							  disp6 <= "11000000";
						elsif ano = 71 then		
							  disp5 <= "11111000";
							  disp6 <= "11111001";
						elsif ano = 72 then				 
							  disp5 <= "11111000";
							  disp6 <= "10100100";
						elsif ano = 73 then				 
							  disp5 <= "11111000";
							  disp6 <= "10110000";
						elsif ano = 74 then				 
							  disp5 <= "11111000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif ano = 75 then				 
							  disp5 <= "11111000";
							  disp6 <= "10010010";
						elsif ano = 76 then				 
							  disp5 <= "11111000";
							  disp6 <= "10000010";
						elsif ano = 67 then				 
							  disp5 <= "11111000";
							  disp6 <= "11111000";
						elsif ano = 78 then				 
							  disp5 <= "11111000";
							  disp6 <= "10000000";
						elsif ano = 79 then				 
							  disp5 <= "11111000";
							  disp6 <= "10011000";
						---------------------80--------------------------------------
						elsif ano = 80 then --80
							  disp5 <= "10000000";
							  disp6 <= "11000000";
						elsif ano = 81 then		
							  disp5 <= "10000000";
							  disp6 <= "11111001";
						elsif ano = 82 then				 
							  disp5 <= "10000000";
							  disp6 <= "10100100";
						elsif ano = 83 then				 
							  disp5 <= "10000000";
							  disp6 <= "10110000";
						elsif ano = 84 then				 
							  disp5 <= "10000000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif ano = 85 then				 
							  disp5 <= "10000000";
							  disp6 <= "10010010";
						elsif ano = 86 then				 
							  disp5 <= "10000000";
							  disp6 <= "10000010";
						elsif ano = 87 then				 
							  disp5 <= "10000000";
							  disp6 <= "11111000";
						elsif ano = 88 then				 
							  disp5 <= "10000000";
							  disp6 <= "10000000";
						elsif ano = 89 then				 
							  disp5 <= "10000000";
							  disp6 <= "10011000";
						---------------------90--------------------------------------
						elsif ano = 90 then
							  disp5 <= "10011000";
							  disp6 <= "11000000";
						elsif ano = 91 then		
							  disp5 <= "10011000";
							  disp6 <= "11111001";
						elsif ano = 92 then				 
							  disp5 <= "10011000";
							  disp6 <= "10100100";
						elsif ano = 93 then				 
							  disp5 <= "10011000";
							  disp6 <= "10110000";
						elsif ano = 94 then				 
							  disp5 <= "10011000";
							  disp6 <= "10011001";
						 ---05-------------------------------------------------------------------
						elsif ano = 95 then				 
							  disp5 <= "10011000";
							  disp6 <= "10010010";
						elsif ano = 96 then				 
							  disp5 <= "10011000";
							  disp6 <= "10000010";
						elsif ano = 97 then				 
							  disp5 <= "10011000";
							  disp6 <= "11111000";
						elsif ano = 98 then				 
							  disp5 <= "10011000";
							  disp6 <= "10000000";
						elsif ano = 99 then				 
							  disp5 <= "10011000";
							  disp6 <= "10011000";
						end if; -- acabou os anos
				end if;
				
			
			end process;

end logic;