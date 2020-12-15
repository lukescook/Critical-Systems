pragma SPARK_Mode;
with AS_IO_Wrapper;  use AS_IO_Wrapper; 
with NuclearReactor;  use NuclearReactor;


procedure Main is
   T, P : Integer;
   Ci, W, A :Switch;
   Cr : Control_rods; 
   C : Coolant;
   User_Input : String(1 .. 20);
   User_Input_Int : Integer;
   Last : Integer;
begin
   AS_Init_Standard_Output;
   AS_Init_Standard_Input;
   A := Off;
   
   loop
      loop
         AS_Put("Enter the temperature of the system (degrees C) (100-600): ");   
         AS_Get(User_Input_Int);
         exit when User_Input_Int in 100 .. 600;
         As_Put_Line("Error value put into the system, value should be between 100 .. 600");
          end loop;
      T := User_Input_Int;
      loop
         AS_Put("Enter power output required by the system in (MW) (100-600): ");   
         AS_Get(User_Input_Int);
         exit when User_Input_Int in 100 .. 600;
         As_Put_Line("Error value put into the system, value should be between 100 .. 600");
          end loop;
      P := User_Input_Int;
      -- if the power grid takes 600 then the nuclear power is stabilised and the alarm turns off
      if ( P = 600) then
         A := Off;
      end if;
  
      decide(T,P,Cr,C, Ci, W, A);
      if( Cr = Up) then
         AS_Put_Line("Control rod is Up");
      elsif (Cr = Middle) then
         AS_Put_Line("Control rod is in the Middle");
      else
         AS_Put_Line("Control rod is Down");
         
      end if;
            if( C = Slow) then
         AS_Put_Line("Pump is going slowly");
      elsif (C = Medium) then
         AS_Put_Line("Pump is going medium speed");
      else
         AS_Put_Line("Pump is going fast");
      end if;
      if (Ci = On) then
         AS_Put_Line("Coolant injection is On");
      else
         AS_Put_Line("Coolant injection is Off");
      end if;
      if (W = On) then
         AS_Put_Line("Power generated is being Wasted");
      else
         AS_Put_Line("Power is all being used");
      end if;
      if (A = On) then
         AS_Put_Line("Alarm is On (YOU WILL HAVE TO SET POWER TO 600)");
      else
         AS_Put_Line("Alarm is Off");
      end if;
      
      loop
        pragma Loop_Invariant(T in 100 .. 600 and P in 100 .. 600 and safe(T, P, Cr, C, Ci, W, A));
	As_Put("Do you want to try again (y/n)? ");
	As_Get_Line(User_Input, Last);
	exit when Last > 0;
	As_Put_Line("Please enter a non-empty string");
      end loop;
      exit when User_Input(1 .. 1) = "n";
   end loop;   
end Main;


