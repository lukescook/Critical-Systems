pragma SPARK_Mode;


package NuclearReactor is
   
   type Control_rods is (Up,Middle,Down);
   type Coolant is (Slow, Medium ,Fast);
   type Switch is (On, Off);
   
   -- the act of turning the alarm on
   function Temperature_To_High  (T : Integer; Cr : Control_rods; C : Coolant; Ci : Switch; W : Switch; A : Switch)return Boolean is
     (if T > 500 then ( A = On and C= fast and Ci = On and W = On and Cr = Down));
   
   --check that the alarm stays on
   function Alarm_ON  (Cr : Control_rods; C : Coolant; Ci : Switch; W : Switch; A : Switch)return Boolean is
     (if (A = ON) then (C= fast and Ci = On and W = On and Cr = Down));
   
   -- check the if the method power input is 600 then the alarm is also off
   function Alarm_Off  (P : Integer; A : Switch) return Boolean is
     (if (P = 600 ) then (A = Off));
   
   function Needs_500 (T : Integer; P : Integer; Cr : Control_rods; C : Coolant; Ci : Switch; W : Switch; A : Switch)return Boolean is
      (if (P = 500 and A = Off) then ((if (T = 300) then ( Cr = Middle and C = Slow and Ci = Off and W = Off)) and
                                          (if (T < 300) then ( Cr = Up and C = Slow and Ci = Off and W = Off)) and
                                        (if (T > 300) then ( Cr = Down and C = Slow and 
                                                                                    (if (T in 400 ..449) then (Ci = On and W = Off)) and
                                                                                  (if (T in 450 ..469) then (Ci = Off and W = On)) and
                                                                                    (if (T in 470 ..500) then (Ci = On and W = On))))));
   
   
   function Needs_More_500 (T : Integer; P : Integer; Cr : Control_rods; C : Coolant; Ci : Switch; W : Switch; A : Switch)return Boolean is
      (if( P > 500 and A = Off) then (Ci = Off and W = Off and
                                         (if (T < 300) then (Cr = up and (if (P in 501.. 520) then (C = Slow)) and
                                                               (if (P in 521.. 570) then (C = Medium)) and
                                                                 (if (P in 571.. 600) then (C = Fast)))) and
                                       (if(T = 300 and P in 501 .. 550) then (Cr = Up and C = Medium)) and
                                         (if(T = 300 and P in 551 .. 600) then (Cr = Up and C = Fast)) and
                                       (if( P in 501 .. 600 ) then ( (if (T in 301 .. 350) then (Cr = Middle and C = Medium)) and
                                                                        (if (T in 351 .. 400) then (Cr = Down and C = Medium)) and
                                                                      (if (T in 401 .. 450) then (Cr = Middle and C = Fast)) and
                                                                        (if (T in 451 .. 500) then (Cr = Down and C = Fast))))));
   
   
   function Needs_Less_500 (T : Integer; P : Integer; Cr : Control_rods; C : Coolant; Ci : Switch; W : Switch; A : Switch)return Boolean is
     (if(P < 500 and A = Off) then (C= Slow and W = On and (if (T = 300) then (Cr = Middle and Ci = Off )) and
                                        (if (T < 300) then (Cr = Up and Ci = Off )) and
                                      (if (T > 300) then (Cr = Down and 
                                                              (if (T in 301 .. 399) then (Ci = Off )) and
                                                         (if (T in 400 .. 500) then (Ci = On ))))));
   
   
   function safe (T : Integer; P : Integer; Cr : Control_rods; C : Coolant; Ci : Switch; W : Switch; A : Switch)return Boolean is
     (Temperature_To_High (T,Cr , C, Ci, W, A) 
      and Alarm_ON(Cr, C, Ci, W, A ) 
       and Needs_500(T, P, Cr, C, Ci, W, A)
       and Needs_More_500(T, P, Cr, C, Ci, W, A)
      and Needs_Less_500(T, P, Cr, C, Ci, W, A));
   
   
   procedure decide (T : in Integer; P : in Integer; Cr : out Control_rods; C : out Coolant; Ci : out Switch; W : out Switch; A : in out Switch) with
     Depends => (Cr => (T,P,A), C => (T,P,A), Ci => (T,P,A), W => (T,P,A), A => (T,P,A)),
     Pre => ( T in 100 .. 600 and P in 100 .. 600 and Alarm_Off(P, A)),
     Post => ( Temperature_To_High (T,Cr , C, Ci, W, A) and Alarm_ON(Cr, C, Ci, W, A ) 
               and Needs_500(T, P, Cr, C, Ci, W, A) and Needs_More_500(T, P, Cr, C, Ci, W, A)
              and Needs_Less_500(T, P, Cr, C, Ci, W, A));
   
     
end NuclearReactor;
     
     
   
     
   
