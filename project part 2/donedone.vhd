LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

 
ENTITY donedone IS  
   PORT ( switches: IN std_logic_vector(2 DOWNTO 0);
    key: IN std_logic_vector(3 downto 0);
    key1 :IN std_logic;
    LED_R : OUT std_logic_vector(3 downto 0):="0000"; 
    
    LEDs: OUT std_logic_vector(3 downto 0);
      lcdclk       : IN     std_logic;
      clk       : IN     std_logic;
      rst          : IN     std_logic:='1';   
      enable       : OUT    std_logic;
      onlcd        : OUT    std_logic;
      rs           : OUT    std_logic;
      readwrite    : OUT    std_logic;
      blon         : OUT    std_logic;
      Databus      : inout std_logic_vector(7 downto 0));
  
   END donedone; 
 
ARCHITECTURE FinalProject OF donedone IS 
type character_string is array ( 0 to 31 ) of std_logic_vector( 7 downto 0 );
  
  type state_type is (rst1, rst2,rst3,func_set,display_on,display_clear,display_off,mode_set,print_string,
                      line2,return_home,en_off);
                       
  signal state, next_command         : state_type;
  signal lcd_string_01       : character_string;
  signal lcd_string_02       : character_string;
  signal lcd_string_03       : character_string;
  signal lcd_string_04       : character_string;
  signal lcd_string_05       : character_string;
  signal lcd_string_06       : character_string;
  signal lcd_string_07       : character_string;


  
  signal input_data_bus, next_char   : std_logic_vector(7 downto 0);
  signal clk_count_400hz             : std_logic_vector(23 downto 0);
  signal char_count                  : std_logic_vector(4 downto 0);
  signal clk_400hz_enable,lcd_rw_int 	 : std_logic;
  
  signal data_bus_reg                    : std_logic_vector(7 downto 0);	
  signal LCD_CHAR_ARRAY              : std_logic_vector(3 DOWNTO 0);
  
  signal s:std_logic_vector(3 downto 0);
  signal e:std_logic:='0';
  signal f:std_logic:='0';
  signal g:std_logic:='0';
  signal h:std_logic:='0'; 
BEGIN 


Databus<=data_bus_reg;
lcd_string_01 <= 
	( 
	  "01000100","01001111","01001111","01010010","00100000","01001100","01001111","01000011","01001011","00100000","01010011","01011001","01010011","01010100","01000101","01001101",
		 
      "01010011","01000101","01001100","01000101","01000011","01010100","00100000","01010010","01001111","01001111","01001101","00100000","00111111","00100000","00100000","00100000"
      
     );  --door lock system select door ?
     
 lcd_string_02 <= 
	( 
		"01010010","01001111","01001111","01001101","00100000","00110001","00100000","01010011","01001001","01001100","01000101","01000011","01010100","01000101","01000100","00100000",
		
		"01000101","01001110","01010100","01000101","01010010","00100000","01010000","01000001","01010011","01010011","01010111","01001111","01010010","01000100","00100000","00100000"
	); -- Room 1 Selected
 lcd_string_03 <= 
	( 
		"01010010","01001111","01001111","01001101","00100000","00110010","00100000","01010011","01000101","01001100","01000101","01000011","01010100","01000101","01000100","00100000",
		
		"01000101","01001110","01010100","01000101","01010010","00100000","01010000","01000001","01010011","01010011","01010111","01001111","01010010","01000100","00100000","00100000"
	);-- Room 2 Selected
 lcd_string_04 <= 
	( 
		"01010010","01001111","01001111","01001101","00100000","00110011","00100000","01010011","01000101","01001100","01000101","01000011","01010100","01000101","01000100","00100000",
		
		"01000101","01001110","01010100","01000101","01010010","00100000","01010000","01000001","01010011","01010011","01010111","01001111","01010010","01000100","00100000","00100000"
	);-- Room 3 Selected
 lcd_string_05 <= 
	( 
		"01010010","01001111","01001111","01001101","00100000","00110100","00100000","01010011","01000101","01001100","01000101","01000011","01010100","01000101","01000100","00100000",

		"01000101","01001110","01010100","01000101","01010010","00100000","01010000","01000001","01010011","01010011","01010111","01001111","01010010","01000100","00100000","00100000"
	);-- Room 4 Selected

 lcd_string_06 <= 
	( 
		"00100000","01111110","00101010","00101010","00101010","01010111","01100101","01101100","01100011","01101111","01101101","01100101","00101010","00101010","00101010","01111111",
		
		"00100000","00100000","00100000","00100000","01000100","01001111","01001111","01010010","00100000","01001111","01010000","01000101","01001110","00100000","00100000","00100000"
	) ;--Door open
lcd_string_07 <=
	( 
		"01000100","01001111","01001111","01010010","00100000","01001100","01001111","01000011","01001011","00100000","01010011","01011001","01010011","01010100","01000101","01001101",
		
		"01010000","01000001","01010011","01010011","01010111","01001111","01010010","01000100","00100000","01010111","01010010","01001111","01001110","01000111","00100000","00100000"
	);--wrong password

	
		
data_bus_reg  <=input_data_bus  when lcd_rw_int = '0'else "ZZZZZZZZ"; 
readwrite <= lcd_rw_int;

process(clk,key,switches)
begin
if rising_edge(clk) then
--------------------------ROOM 1--------------------------------------------------------------------Password : 2143
		case(switches) is
			when "001" =>
				next_char <= lcd_string_02(CONV_INTEGER(char_count));
				LEDs<="0001";
				
					if(key1='1') then
						s<="0000";
						e<='0';
						f<='0';
						g<='0';
						h<='0';
					else
					
						if(s/="1111") then
							if(e='1' and f='1' and g='1' and h='1') then
								next_char<=lcd_string_07(CONV_INTEGER(char_count));
								LED_R<="1111";
						
							else
								case(key) is	
									when "1101" =>
										s(0)<='1';
										LEDs<="0001";
										e<='1';
									
									when "1110"=>
										f<='1';
										if(s(0)='1')then
										s(1)<='1';
										LEDs(1)<='1';
										end if;
										
									when "0111"=>
										g<='1';
										if(s(1)='1')then
										s(2)<='1';
										LEDs(2)<='1';
										end if;

									when "1011"=>
										h<='1';
										if(s(2)='1')then
										s(3)<='1';
										LEDs<="1111";
										end if;
									when others=>
									null;
							  end case;
						   end if;
					elsif(s="1111") then
							next_char <= lcd_string_06(CONV_INTEGER(char_count));
							LEDs<="1111";
					end if;
				end if;
-----------------------------------Room 2---------------------------------------------------Password: 1432---------------------------------------------				
		when "010" =>
				next_char <= lcd_string_03(CONV_INTEGER(char_count));
				LEDs<="0010";
				
					if(key1='1') then
						s<="0000";
						e<='0';
						f<='0';
						g<='0';
						h<='0';
					else
					
						if(s/="1111") then
							if(e='1' and f='1' and g='1' and h='1') then
								next_char<=lcd_string_07(CONV_INTEGER(char_count));
								LED_R<="1111";
						
							else
								case(key) is	
									when "1110" =>
										s(0)<='1';
										LEDs<="0001";
										e<='1';
									
									when "0111"=>
										f<='1';
										if(s(0)='1')then
										s(1)<='1';
										LEDs(1)<='1';
										end if;
										
									when "1011"=>
										g<='1';
										if(s(1)='1')then
										s(2)<='1';
										LEDs(2)<='1';
										end if;

									when "1101"=>
										h<='1';
										if(s(2)='1')then
										s(3)<='1';
										LEDs<="1111";
										end if;
									when others=>
									null;
							  end case;
						   end if;
					elsif(s="1111") then
							next_char <= lcd_string_06(CONV_INTEGER(char_count));
							LEDs<="1111";
					end if;
				end if;
------------------------------------------------------Room 3--------------------------------Password:4231------------------------------------
		when "011" =>
				next_char <= lcd_string_04(CONV_INTEGER(char_count));
				LEDs<="0100";
				
					if(key1='1') then
						s<="0000";
						e<='0';
						f<='0';
						g<='0';
						h<='0';
					else
						if(s/="1111") then
							if(e='1' and f='1' and g='1' and h='1') then
								next_char<=lcd_string_07(CONV_INTEGER(char_count));
								LED_R<="1111";
						
							else
								case(key) is	
									when "0111" =>
										s(0)<='1';
										LEDs<="0001";
										e<='1';
									
									when "1101"=>
										f<='1';
										if(s(0)='1')then
										s(1)<='1';
										LEDs(1)<='1';
										end if;
										
									when "1011"=>
										g<='1';
										if(s(1)='1')then
										s(2)<='1';
										LEDs(2)<='1';
										end if;

									when "1110"=>
										h<='1';
										if(s(2)='1')then
										s(3)<='1';
										LEDs<="1111";
										end if;
									when others=>
									null;
							  end case;
						   end if;
					elsif(s="1111") then
							next_char <= lcd_string_06(CONV_INTEGER(char_count));
							LEDs<="1111";
					end if;
				end if;		
--------------------------------------------------------Room 4------------------------------------------------------Password:2341--------------------------------------------------------------------------------		
		
		when "100" =>
				next_char <= lcd_string_05(CONV_INTEGER(char_count));
				LEDs<="1000";
				
					if(key1='1') then
						s<="0000";
						e<='0';
						f<='0';
						g<='0';
						h<='0';
					else
					if(s/="1111") then
							if(e='1' and f='1' and g='1' and h='1') then
								next_char<=lcd_string_07(CONV_INTEGER(char_count));
								LED_R<="1111";
						
							else
								case(key) is	
									when "1101" =>
										s(0)<='1';
										LEDs<="0001";
										e<='1';
									
									when "1011"=>
										f<='1';
										if(s(0)='1')then
										s(1)<='1';
										LEDs(1)<='1';
										end if;
										
									when "0111"=>
										g<='1';
										if(s(1)='1')then
										s(2)<='1';
										LEDs(2)<='1';
										end if;

									when "1110"=>
										h<='1';
										if(s(2)='1')then
										s(3)<='1';
										LEDs<="1111";
										end if;
									when others=>
									null;
							  end case;
						   end if;
					elsif(s="1111") then
							next_char <= lcd_string_06(CONV_INTEGER(char_count));
							LEDs<="1111";
					end if;
				end if;		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
		when others=>
			next_char <= lcd_string_01(CONV_INTEGER(char_count));	
			LEDs<="0000";
			LED_R<="0000";
			s<="0000";
			e<='0';
			f<='0';
			g<='0';
			h<='0';
		end case;
	end if;
end process;

process(lcdclk)
begin
      if (rising_edge(lcdclk)) then
         if (rst = '0') then
            clk_count_400hz <= x"000000";
            clk_400hz_enable <= '0';
         else
          if (clk_count_400hz <= x"00F424") then                                                  
              clk_count_400hz <= clk_count_400hz + 1;                                          
              clk_400hz_enable <= '0';                
          
          else
           clk_count_400hz <= x"000000";
           clk_400hz_enable <= '1';
          
          end if;
         end if;
      end if;
end process; 

process (lcdclk, rst)
begin
        if rst = '0' then
           state <= rst1;
           input_data_bus <= "00111000"; 
           next_command <= rst2;
           enable <= '1';
           rs <= '0';
           lcd_rw_int <= '0';  
        elsif rising_edge(lcdclk) then
             if clk_400hz_enable = '1' then  
                 case state is
                 when rst1 =>
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "00111000"; 
                            state <= en_off;
                            next_command <= rst2;
                            char_count <= "00000";
                 when rst2 =>
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "00111000"; 
                            state <= en_off;
                            next_command <= rst3;
                            
                 when rst3 =>
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "00111000";
                            state <= en_off;
                            next_command <= func_set;
            
                 when func_set =>                
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "00111000";
                            state <= en_off;
                            next_command <= display_off; 
                                                                                        
                 when display_off =>
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "00001000"; 
                            state <= en_off;
                            next_command <= display_clear;
                           
                 when display_clear =>
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "00000001";   
                            state <= en_off;
                            next_command <= display_on;
                           
                 when display_on =>
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "00001100";
                            state <= en_off;
                            next_command <= mode_set;
                 
                 when mode_set =>
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "00000110";
                            state <= en_off;
                            next_command <= print_string; 
                            
                 when print_string =>          
                            state <= en_off;
                            enable <= '1';
                            rs <= '1';
                            lcd_rw_int <= '0';
                            if (next_char(7 downto 4) /= x"0") then
                            input_data_bus <= next_char;
                            else
							if next_char(3 downto 0) >9 then 
			  input_data_bus <= x"4" & (next_char(3 downto 0)-9); 
                       else 
                                
                                    
                       input_data_bus <= x"3" & next_char(3 downto 0); 
                       end if;
                       end if;    
                            
                          if (char_count < 31)AND (next_char /= x"fe")then
                               char_count <= char_count +1;                            
                               else
                               char_count <= "00000";
                               end if;
                          if char_count = 15 then 
                                  next_command <= line2;
                          elsif (char_count = 31)  or (next_char = x"fe") then
                                     next_command <= return_home;
                               else 
                                     next_command <= print_string; 
                               end if; 
                 
                 when line2 =>
                            enable <= '1';
                            rs <= '0';
                            lcd_rw_int <= '0';
                            input_data_bus <= "11000000";
                            state <= en_off;
                            next_command <= print_string;      
				 
				 
			      when return_home=>
							enable<='1';
							rs<='0';
							lcd_rw_int <='0';
							input_data_bus<="10000000";
							state<=en_off;
							next_command<=print_string;
				 when en_off =>
                            
                			 state<=next_command;
                			  enable <= '0';
							 blon<='1';
							 onlcd<='1';


			 end case;
             end if;
             end if;
             end process;  
             

              
 END FinalProject; 

