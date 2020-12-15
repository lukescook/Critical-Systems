pragma SPARK_Mode;


package body NuclearReactor is
   
   
   
  
    procedure decide (T : in Integer; P : in Integer; Cr : out Control_rods; C : out Coolant; Ci : out Switch; W : out Switch; A : in out Switch) is
   begin
      -- if the alarm is on it stays on, it is turned off in main if P=600
      if (A = On ) then
         Cr := Down;
         C := Fast;
         Ci := On;
         W := On;
         -- under any condition if the temperature is above 500 the alarm is turned on
      elsif( T > 500) then
         Cr := Down;
         C := Fast;
         Ci := On;
         W := On;
         A := On;
         -- if the power grid needs 500
      elsif ( P = 500) then
         C := Slow;
         if( T = 300) then
            Cr := Middle;
            Ci := Off;
            W := Off;
            A := Off;
         elsif( T > 300) then
            Cr := Down;
            Ci := Off;
            W := Off;
            A := Off;
            if ( T in 400 ..449) then
               Ci := On; 
            elsif (T in 450 ..469) then 
               W := On;
            elsif (T in 470 ..500) then
               Ci := On; 
               W := On;
               
            end if;
         else
            Cr := Up;
            Ci := Off;
            W := Off;
            A := Off;
         end if;
         -- if the power grid needs more than 500
      elsif ( P > 500 and T >= 300) then
         Ci := Off;
         W := Off;
         A := Off;
         if ( T = 300 and P <= 550) then
            Cr := Up;
            C := Medium;
         elsif ( T = 300 and P <= 600) then
            Cr := Up;
            C := Fast;
         elsif ( T <= 350) then
            Cr := Middle;
            C := Medium;
         elsif (T <= 400) then
            Cr := Down;
            C := Medium;
         elsif (T <= 450) then
            Cr := Middle;
            C := fast;
         else
            Cr := Down;
            C := fast;
         end if;
      elsif ( P > 500 and T < 300) then
         Cr := Up;
         Ci := Off;
         W := Off;
         A := Off;
         if ( P <= 520) then
            C := Slow;
         elsif ( P <= 570) then
            C := Medium;
         else
            C := Fast;
         end if;
         -- if the power grid need less than 500
      else
         Cr := Middle;
         C := Slow;
         Ci := Off;
         W := On;
         A := Off;
         if ( T > 300) then
            Cr := Down;
            if ( T in 400 .. 500) then
               Ci := On;
            end if;
         elsif( T < 300) then
            Cr := Up;
         end if;
      end if;
      
            
           
            
               
            
   end decide;

     
end NuclearReactor;
     
     
   
     
   
